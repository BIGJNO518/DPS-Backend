/**
 * @description  Apex class to house all logic related to generating Approval__c records for Deals that may require them
 * @date         September 13, 2023
 * @author       Matt Parrella (WatchBox)
*/

public with sharing class WB_OpportunityApprovals {

    /**
      * @description    Method that will, using the provided 'dealId' parameter, query for any Opportunity_Line_Item__c records related to the 'dealId' and has a RecordType of 'WatchSale'. If records are found, the method
      *                 will take the line item that has the highest CompanyOfferAmount__c value and use that value to compare against the 'UnitPriceMin__c' field on the OpportunityApprovalSettings__mdt records. If the CompanyOfferAmount__c
      *                 value is > the UnitPriceMin__c field in one of the OpportunityApprovalSettings__mdt records, then an ApprovalRequest__c (related to the Deal) & N Approval__c record(s) will be created and inserted into the database. The 'N' value will be
      *                determined from the sum of the 'ManagerApproverCount__c' and 'FinanceApproverCount__c' field valuesThe ApprovalRequest__c record and they will be related to the ApprovalRequest__c record.
      *
      *                Example: If the Metadata record's ManagerApproverCount__c = 1 and FinanceApproverCount__c = 2; then we will be creating 3 Approval__c records (2 with Type = 'Finance' and 1 with Type = 'Manager')
      *
      * @param          dealId - String - The Id of the Deal that is being checked for approvals
      *
      * @return         Map<String,String> - A custom JSON string containing information regarding the approval process (i.e. any errors that may have occurred, or perhaps there is no need for an approval)
      */
    @AuraEnabled
    public static Map<String,String> checkOriginationApprovals(String dealId) {
        String NO_APPROVAL_TEXT = 'No WatchSale Approvals Required';
        String SUCCESS_TEXT = 'success';
        String ERROR_TEXT = 'error';
        String originationRTID = Schema.SObjectType.Opportunity_Line_Item__c.getRecordTypeInfosByDeveloperName().get('WatchOrigination').getRecordTypeId();
        Map<String,String> responseMap = new Map<String,String>();

        // Get the 'WatchSale' Opportunity_Line_Item__c record that has the highest CompanyOfferAmount__c value, using the 'dealId' parameter as a filter
        Opportunity_Line_Item__c originationLineItem;
        try {
            originationLineItem = [SELECT   Id,
                                            CompanyOfferAmount__c,
                                            OwnerId,
                                            Opportunity__r.ApprovalStatus__c
                                   FROM     Opportunity_Line_Item__c
                                   WHERE    Opportunity__c = :dealId
                                   AND      RecordTypeId = :originationRTID
                                   AND      isDeleted__c  = FALSE
                                   ORDER BY CompanyOfferAmount__c DESC
                                   LIMIT    1];
        }
        catch(QueryException ex) {
            responseMap.put('result', SUCCESS_TEXT);
            responseMap.put('message', NO_APPROVAL_TEXT);
            return responseMap;
        }

        // If we found any 'WatchSale' Opportunity_Line_Item__c records, then we need to check if any approvals are needed
        if (originationLineItem.Opportunity__r.ApprovalStatus__c == 'Not Applicable' || originationLineItem.Opportunity__r.ApprovalStatus__c == null) {
            // Build Map of UnitPriceMax__c -> OpportunityApprovalSetting__mdt record
            List<Approval__c> approvalsToInsert = new List<Approval__c>();

            // Check if there is an existing ApprovalRequest__c record for this Deal
            ApprovalRequest__c approvalReqRecord;

            try {
                // Attempt to find existing ApprovalRequest__c record for this Deal
                approvalReqRecord = [SELECT Id FROM ApprovalRequest__c WHERE Opportunity__c = :dealId];
            }
            catch(QueryException ex) {
                // Create new ApprovalRequest__c record
                approvalReqRecord = new ApprovalRequest__c();
                insert approvalReqRecord;
            }


            Map<Decimal,OpportunityApprovalSettings__mdt> approvalSettingMap = new Map<Decimal,OpportunityApprovalSettings__mdt>();

            for (OpportunityApprovalSettings__mdt approvalSettingVar : [
                    SELECT      DefaultRecordOwner__c,
                                FinanceApproverCount__c,
                                Id,
                                LineItemRecordType__c,
                                ManagerApproverCount__c,
                                TierName__c,
                                UnitPriceMin__c
                    FROM        OpportunityApprovalSettings__mdt
                    WHERE       LineItemRecordType__c = 'WatchOrigination'
                    ORDER BY    TierName__c ASC
                ]) {
                approvalSettingMap.put(approvalSettingVar.UnitPriceMin__c,approvalSettingVar);
            }

            // Check if approvals are needed
            Integer financeCount = 0;
            Integer mgmtCount = 0;
            Integer totalApprovalsNeeded = 0;

            OpportunityApprovalSettings__mdt reqApprovalMetadata; // Var to hold selected metadata record

            // Check line items against metadata records to determine if approvals are needed
            for (Integer i = approvalSettingMap.values().size() - 1; i >= 0; i--) { // Iterate collection in reverse order so we start with highest Tier amount
                OpportunityApprovalSettings__mdt tempRecord = approvalSettingMap.values()[i];
                if (originationLineItem.CompanyOfferAmount__c > tempRecord.UnitPriceMin__c) {
                    reqApprovalMetadata = tempRecord;
                    financeCount = Integer.valueOf(reqApprovalMetadata.FinanceApproverCount__c);
                    mgmtCount = Integer.valueOf(reqApprovalMetadata.ManagerApproverCount__c);
                    totalApprovalsNeeded = financeCount + mgmtCount;
                    break;
                }
            }

            // Approvals are needed
            if (totalApprovalsNeeded > 0) {
                // Create Finance Approval(s)
                if (financeCount > 0) {
                    for (Integer i = 0; i < financeCount; i++) {
                        approvalsToInsert.add(new Approval__c(
                                ApprovalRequest__c = approvalReqRecord.Id,
                                QueueType__c = 'Finance',
                                MetadataTierName__c = reqApprovalMetadata.TierName__c,
                                Status__c = 'Pending',
                                Approver__c = reqApprovalMetadata.DefaultRecordOwner__c
                        ));
                    }
                }
                if (mgmtCount > 0) {
                    // Create Management Approval(s)
                    for (Integer i = 0; i < mgmtCount; i++) {
                        approvalsToInsert.add(new Approval__c(
                                ApprovalRequest__c = approvalReqRecord.Id,
                                QueueType__c = 'Management',
                                MetadataTierName__c = reqApprovalMetadata.TierName__c,
                                Status__c = 'Pending',
                                Approver__c = reqApprovalMetadata.DefaultRecordOwner__c
                        ));
                    }
                }
            } else {
                responseMap.put('result', SUCCESS_TEXT);
                responseMap.put('message', NO_APPROVAL_TEXT);
                return responseMap;
            }

            approvalReqRecord.RequiredFinanceCount__c = financeCount;
            approvalReqRecord.RequiredManagerCount__c = mgmtCount;
            approvalReqRecord.Opportunity__c = dealId;
            approvalReqRecord.RequestedBy__c = UserInfo.getUserId();
            approvalReqRecord.Type__c = 'Deal';
            approvalReqRecord.Status__c = 'Pending';

            if (!approvalsToInsert.isEmpty()) {
                try {
                    update approvalReqRecord;
                    insert approvalsToInsert;

                    // Update Opportunity.ApprovalStatus__c to 'Pending Approval'
                    Opportunity tempOpp = new Opportunity(
                            Id = dealId,
                            ApprovalStatus__c = 'Pending Approval'
                    );
                    update tempOpp;
                    responseMap.put('result', SUCCESS_TEXT);
                    responseMap.put('message', '');
                    return responseMap;
                }
                catch(DmlException ex) {
                    System.debug('*** WB_OpportunityApprovals.checkOriginationApprovals() Exception caught: ' + ex.getMessage());
                    responseMap.put('result', ERROR_TEXT);
                    responseMap.put('message', ex.getMessage());
                    return responseMap;
                }
            } else {
                responseMap.put('result', SUCCESS_TEXT);
                responseMap.put('message', NO_APPROVAL_TEXT);
                return responseMap;
            }
        } else {
            // Deal's ApprovalStatus__c field is either 'Pending', 'Approved', or 'Rejected'
            responseMap.put('result', ERROR_TEXT);
            responseMap.put('message', 'This Deal has already been submitted for approval.');
            return responseMap;
        }

    }
}
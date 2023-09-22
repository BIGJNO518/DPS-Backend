/**
 * @description  Test class to cover the logic within the 'WB_OpportunityApprovals' class
 * @date        September 14, 2023
 * @author      WatchBox (Matt Parrella)
*/

@isTest
public with sharing class WB_OpportunityApprovalsTest {
    @TestSetup
    static void setup_data() {
        // Create Account record
        Account testAcct = new Account();
        testAcct.FirstName = 'Chet';
        testAcct.LastName = 'Douglas';
        testAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Client').recordTypeId;

        insert testAcct;

        // Create Deal record
        Opportunity testOpp = new Opportunity();
        testOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Ecommerce').recordTypeId;
        testOpp.AccountId = testAcct.Id;
        testOpp.StageName = 'DIP';
        testOpp.ReportingLocation__c = 'Watchbox Bala';
        testOpp.CloseDate = Date.today().addDays(7);
        testOpp.Name = 'Apex Test Opportunity';

        insert testOpp;

        // Create Test Brand__c Records
        List<Brands__c> testBrands = new List<Brands__c>();
        for (Integer i = 1; i < 3; i++) {
            testBrands.add(
                    new Brands__c(
                            Name = 'Test Brand ' + i
                    )
            );
        }
        insert testBrands;

        // Create Test Brand Family Records
        List<Family__c> testBrandFamilies = new List<Family__c>();
        for (Integer i = 0; i < 2; i++) {
            testBrandFamilies.add(
                    new Family__c(
                            Name = 'Test Brand Family ' + i,
                            Brands__c = testBrands[i].Id
                    )
            );
        }
        insert testBrandFamilies;

        // Create Test Product Records
        List<Bid_Ask__c> testProducts = new List<Bid_Ask__c>();
        for (Integer i = 0; i < 2; i++) {
            testProducts.add(
                    new Bid_Ask__c(
                            Brand_Family__c = testBrandFamilies[i].Id,
                            Brands__c = testBrands[i].Id,
                            Reference_no__c = 'Test Reference Number ' + i,
                            Watch_Title__c = 'Test Watch Title ' + i
                    )
            );
        }
        insert testProducts;

        // Create Inventory Records
        List<Inventory__c> inventoryRecords = new List<Inventory__c>();
        for (Integer i = 0; i < 2; i++) {
            inventoryRecords.add(
                    new Inventory__c(
                            Product__c = testProducts[i].Id,
                            Cost__c = i == 0 ? 1000 : 2000,
                            Description__c = 'Test Description ' + i,
                            Location__c = testAcct.Id,
                            TargetPrice__c = 8230.00
                    )
            );
        }
        insert inventoryRecords;

        // Create Test Deal Line Items
        List<Opportunity_Line_Item__c> testItems = new List<Opportunity_Line_Item__c>();
        Id watchOrigRTID = Schema.SObjectType.Opportunity_Line_Item__c.getRecordTypeInfosByDeveloperName().get('WatchOrigination').getRecordTypeId();
        for (Integer i = 0; i < 2; i++) {
            testItems.add(new Opportunity_Line_Item__c(
                    Opportunity__c = testOpp.Id,
                    Inventory__c = inventoryRecords[i].Id,
                    Quantity__c = 1,
                    CompanyOfferAmount__c = i == 0 ? 15000 : 150000,
                    RecordTypeId = watchOrigRTID
            ));
        }
        insert testItems;
    }

    /** Tests the 'checkOriginationApprovals' method; Scenario: found line items that require approval(s) */
    @IsTest
    static void checkOriginationApprovals_test1_success() {
        String testDealId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Assert.isNotNull(testDealId, 'Test Opportunity Id is null');

        Test.startTest();
        Map<String,String> result = WB_OpportunityApprovals.checkOriginationApprovals(testDealId);
        Test.stopTest();

        Opportunity testDeal = [SELECT Id, ApprovalStatus__c FROM Opportunity WHERE Id = :testDealId LIMIT 1];

        Assert.isNotNull(result, 'Return value from \'checkOriginationApprovals()\' method is null');
        Assert.areEqual('Pending Approval', testDeal.ApprovalStatus__c, 'Expected the Opportunity Approval Status to be \'Pending Approval\'');
        Assert.areEqual('success', result.get('result'), 'Expected a \'success\' result status.');
        Assert.areEqual('', result.get('message'), 'Expected an empty string for the \'message\' value.');
    }

    /** Tests the 'checkOriginationApprovals' method; Scenario: no line items found that require approval(s) */
    @IsTest
    static void checkOriginationApprovals_test2_no_approvals() {
        // Remove line items created from @TestSetup
        List<Opportunity_Line_Item__c> lineItems = [SELECT Id, Opportunity__c FROM Opportunity_Line_Item__c];
        Assert.isNotNull(lineItems, 'Test Opportunity Line Items are null');
        String testDealId = lineItems[0].Opportunity__c;
        delete lineItems;

        // Get Inventory records for line item creation
        List<Inventory__c> inventoryRecords = [SELECT Id FROM Inventory__c];

        // Create new line items that are of WatchSale type (no approvals required)
        lineItems.clear();
        Assert.areEqual(0, lineItems.size(), 'Expected the \'lineItems\' list to be empty');
        Id watchSaleRTID = Schema.SObjectType.Opportunity_Line_Item__c.getRecordTypeInfosByDeveloperName().get('WatchSale').getRecordTypeId();
        for (Integer i = 0; i < 2; i++) {
            lineItems.add(new Opportunity_Line_Item__c(
                    Opportunity__c = testDealId,
                    Inventory__c = inventoryRecords[i].Id,
                    Quantity__c = 1,
                    CompanyOfferAmount__c = i == 0 ? 15000 : 150000,
                    RecordTypeId = watchSaleRTID
            ));
        }
        insert lineItems;

        Test.startTest();
        Map<String,String> result = WB_OpportunityApprovals.checkOriginationApprovals(testDealId);
        Test.stopTest();

        Opportunity testDeal = [SELECT Id, ApprovalStatus__c FROM Opportunity WHERE Id =: testDealId LIMIT 1];

        Assert.isNotNull(result, 'Return value from \'checkOriginationApprovals()\' method is null');
        Assert.isNull(testDeal.ApprovalStatus__c, 'Expected the Opportunity Approval Status to be null');
        Assert.areEqual('success', result.get('result'), 'Expected a \'success\' result status.');
        Assert.areEqual('No WatchSale Approvals Required', result.get('message'), 'Expected a \'No WatchSale Approvals Required\' message.');
    }

    /** Tests the 'checkOriginationApprovals' method; Scenario: Deal has already been submitted for approval */
    @IsTest
    static void checkOriginationApprovals_test3_already_submitted() {
        String testDealId = [SELECT Id FROM Opportunity LIMIT 1].Id;
        Assert.isNotNull(testDealId, 'Test Opportunity Id is null');

        Test.startTest();
        // First approval check submission
        Map<String,String> result = WB_OpportunityApprovals.checkOriginationApprovals(testDealId);

        // Attempt 2nd approval check
        result = WB_OpportunityApprovals.checkOriginationApprovals(testDealId);
        Test.stopTest();

        Opportunity testDeal = [SELECT Id, ApprovalStatus__c FROM Opportunity WHERE Id = :testDealId LIMIT 1];

        Assert.isNotNull(result, 'Return value from \'checkOriginationApprovals()\' method is null');
        Assert.areEqual('Pending Approval', testDeal.ApprovalStatus__c, 'Expected the Opportunity Approval Status to be \'Pending Approval\'');
        Assert.areEqual('error', result.get('result'), 'Expected a \'error\' result status.');
        Assert.areEqual('This Deal has already been submitted for approval.', result.get('message'), 'Expected \'This Deal has already been submitted for approval.\' string for the \'message\' value.');
    }
}
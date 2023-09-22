/**
 * Created by mparrella on 9/13/2023.
 */

import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent  } from 'lightning/actions';
import {CurrentPageReference} from 'lightning/navigation';
import checkOriginationApproval from '@salesforce/apex/WB_OpportunityApprovals.checkOriginationApprovals';

export default class wb_opportunityApproval extends LightningElement {
    @api recordId;
    loadingText = 'Analyzing Deal...';
    isLoading = true;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    connectedCallback() {
        this.checkApprovals();
    }


    checkApprovals() {
        this.checkOriginationApprovals();
    }


    checkOriginationApprovals() {
        checkOriginationApproval({
            dealId: this.recordId
        })
        .then(result => {
            if (result.result == 'success') {
                if (result.message == 'No WatchSale Approvals Required') {
                    this.dispatchEvent(new ShowToastEvent({
                        title: '',
                        message: 'No Approvals Required',
                        variant: 'success'
                    }));
                    this.closeSubmitForApproval();
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: '',
                            message: 'Submitted for approval successfully',
                            variant: 'success'
                        })
                    );
                    this.closeSubmitForApproval();
                }
            } else {
                this.isLoading = false;
                this.dispatchEvent(new ShowToastEvent({
                    title: '',
                    message: result.message,
                    variant: 'error'
                }));
                this.closeSubmitForApproval();
            }
        })
        .catch(error => {
            console.log('error: ', error.message);
        });
    }

    closeSubmitForApproval() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
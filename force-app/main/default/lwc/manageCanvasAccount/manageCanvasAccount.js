import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FORM_FACTOR from '@salesforce/client/formFactor';

/* Aura Enabled */
import resetPassword from '@salesforce/apex/CanvasValidation.resetPassword';
import syncOpusLmsLoginId from '@salesforce/apex/CanvasValidation.syncOpusLmsLoginId';

/* Fields */
import EXTERNAL_ID from '@salesforce/schema/lms_hed__LMS_Account__c.lms_hed__LMS_External_ID__c';
import LOGIN_ID from '@salesforce/schema/lms_hed__LMS_Account__c.lms_hed__Primary_Login__c';
import ALT_LOGIN_ID from '@salesforce/schema/lms_hed__LMS_Account__c.lms_hed__Alternate_Login__c';
import NONCREDIT_ID from '@salesforce/schema/lms_hed__LMS_Account__c.lms_hed__Account_Owner__r.Noncredit_ID__c';

import workspaceAPI from "c/workspaceAPI";

const NO_NONCREDIT_ID = new ShowToastEvent({title: 'Noncredit ID Missing', message: 'No Contact/Noncredit ID on Contact is not set.', variant: 'error'});

export default class ManageCanvasAccount extends LightningElement {

    get isSmall() {
        return (FORM_FACTOR == 'Small');
    }

    passwordReset = false;
    get isReset() {
        return this.passwordReset;
    }
    
    @api recordId;

    lmsAccount;
    @wire(getRecord, {recordId: '$recordId', fields: [EXTERNAL_ID, LOGIN_ID, ALT_LOGIN_ID, NONCREDIT_ID]})
    getRecordData({data, error}) {
        this.lmsAccount = data;
    }

    runOpusSync(e) {
        let noncreditId = getFieldValue(this.lmsAccount, NONCREDIT_ID);
        if(noncreditId == null || noncreditId == '') {
            this.dispatchEvent(NO_NONCREDIT_ID);
            return;
        }
        syncOpusLmsLoginId({account: {hed__School_Code__c: noncreditId}})
            .then((result) => {
                let messageBody = "Sync Success - "+JSON.stringify(result);
                this.dispatchEvent(new ShowToastEvent({title: 'Opus <-> Canvas Sync', message: messageBody, variant: 'success'}));
                workspaceAPI.refreshCurrentTab();
            })
            .catch((error) => {
                this.dispatchEvent(new ShowToastEvent({title: 'Opus <-> Canvas Sync', message: error.body.message, variant: 'error'}));
            });
    }

    newPassword = "";
    runPasswordReset(e) {
        resetPassword({canvasAccount: {
            lms_hed__LMS_External_ID__c: getFieldValue(this.lmsAccount, EXTERNAL_ID), 
            lms_hed__Primary_Login__c: getFieldValue(this.lmsAccount, LOGIN_ID),
            lms_hed__Alternate_Login__c: getFieldValue(this.lmsAccount, ALT_LOGIN_ID)
        }})
            .then((result) => {
                this.dispatchEvent(new ShowToastEvent({title: 'Password Reset', message: 'Password reset: '+result, variant: 'success'}));
                this.passwordReset = true;
                this.newPassword = result;
            })
            .catch((error) => {
                this.dispatchEvent(new ShowToastEvent({title: 'Password Reset', message: error.body.message, variant: 'error'}));
            });
    }

}
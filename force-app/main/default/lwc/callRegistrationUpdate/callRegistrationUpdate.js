import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/* Aura Enabled*/
import validateRegistration from '@salesforce/apex/RegistrationValidation.validateRegistration';
import validateLineItems from '@salesforce/apex/RegistrationValidation.validateLineItems';
import validateEnrollments from '@salesforce/apex/RegistrationValidation.validateEnrollments';
import getNoncreditCanvasLogin from '@salesforce/apex/CanvasValidation.getNoncreditCanvasLogin';

/* Fields */
import REG_ID from '@salesforce/schema/Registration__c.Registration_Id__c';
import NONCREDIT_ID from '@salesforce/schema/Registration__c.Online_Account__r.hed__School_Code__c';

import modalAlert from "c/modalAlert";

const MIDDLEWARE_ERROR = new ShowToastEvent({title: 'Integration Error', message: 'Error getting update from Middleware.', variant: 'error'});

export default class CallRegistrationUpdate extends LightningElement {

    @api recordId;

    registration;
    @wire(getRecord, {recordId: '$recordId', fields: [REG_ID, NONCREDIT_ID/*, 'csuoee__PE_Notification_Sent__c', 'csuoee__PE_Confirmation_Sent__c'*/]})
    getRecordData({data, error}) {
        this.registration = data;
    }

    runValidate() {
        modalAlert.open({
            title: 'Validating...',
            content: 'Checking Opus/SF information. This may take a moment... (ESC to close).'
        });
        
        validateRegistration({reg: {csuoee__Registration_Id__c: this.recordId}})
            .then((result) => {

            })
            .error((errorResult) => {
                this.dispatchEvent(MIDDLEWARE_ERROR);
            });
    }

    runValidateLineItems() {
        modalAlert.open({
            title: 'Validating Line Items...',
            content: 'Checking Opus/SF information. This may take a moment... (ESC to close).'
        });

        validateLineItems({reg: {csuoee__Registration_Id__c: this.recordId}})
            .then((result) => {

            })
            .error((errorResult) => {
                this.dispatchEvent(MIDDLEWARE_ERROR);
            });
    }

    runValidateEnrollments() {
        modalAlert.open({
            title: 'Validating Enrollments...',
            content: 'Checking Opus/SF information. This may take a moment... (ESC to close).'
        });

        validateEnrollments({reg: {csuoee__Registration_Id__c: this.recordId}})
            .then((result) => {

            })
            .error((errorResult) => {
                this.dispatchEvent(MIDDLEWARE_ERROR);
            });
    }

    runValidateCanvasLogin() {
        modalAlert.open({
            title: 'Validating Canvas Login...',
            content: 'Checking Opus/Canvas/SF information. This may take a moment... (ESC to close).'
        });

        getNoncreditCanvasLogin({account: {'hed__School_Code__c': getFieldValue(this.registration, NONCREDIT_ID)}})
            .then((result) => {
                
            })
            .error((errorResult) => {
                this.dispatchEvent(MIDDLEWARE_ERROR);
            });
    }

    runValidateCanvasEnrollments() {
        modalAlert.open({
            title: 'Validating Canvas Enrollments...',
            content: 'Checking Opus/Canvas/SF information. This may take a moment... (ESC to close).'
        });

        getNoncreditCanvasEnrollments({reg: {csuoee__Registration_Id__c: this.recordId}})
            .then((result) => {
                
            })
            .error((errorResult) => {
                this.dispatchEvent(MIDDLEWARE_ERROR);
            });
    }

}
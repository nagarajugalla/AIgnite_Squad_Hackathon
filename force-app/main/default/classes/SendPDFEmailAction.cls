global  class SendPDFEmailAction {
    
    @InvocableMethod(label='Send Email with Dynamic PDF' Description='This Method is used Send Email with the Specified PDF linked to PageRef')
    global static void sendEmailWithDynamicPdf(List<EmailRequest> requests) {
        for (EmailRequest req : requests) {
            try {
                system.debug('requests===='+requests);
                 system.debug('req===='+req);
                // Pass parameters to the Visualforce Page
                PageReference pdfPage = Page.GeneratedPDFPage;
                pdfPage.getParameters().put('name', req.lead.name);
                pdfPage.getParameters().put('leadplan', req.policyName);
               // system.debug('leadplanname ========'+string.valueof(req.lead.Policy_Premium__r.Policy_Plans__c));
                system.debug('policyName======='+req.policyName);
               pdfPage.getParameters().put('leadcoverage',req.policyCoverage);
                system.debug('leadcoverage ========'+req.policyCoverage);
                pdfPage.getParameters().put('finalamount', String.valueof(req.lead.Final_Annual_Premium__c));
               /* PageReference pdfPage = Page.GeneratedPDFPage;
                String url = '/apex/GeneratedPDFPage?name=' + EncodingUtil.urlEncode(req.name, 'UTF-8') ;
                    /*+
             '&email=' + EncodingUtil.urlEncode(req.email, 'UTF-8') +
             '&subject=' + EncodingUtil.urlEncode(req.subject, 'UTF-8') +
             '&body=' + EncodingUtil.urlEncode(req.body, 'UTF-8') ;*/
 /*'&leadplan=' + EncodingUtil.urlEncode(req.lead.Policy_Premium__r.Policy_Plans__c, 'UTF-8') +
 '&leadcoverage=' + EncodingUtil.urlEncode( req.lead.Policy_Premium__r.Coverage__c, 'UTF-8') +
 '&finalamount=' + EncodingUtil.urlEncode(String.valueof(req.lead.Final_Annual_Premium__c), 'UTF-8'); */


//pdfPage = new PageReference(url);

// Now get the content
                
                system.debug('content ===='+pdfPage.getContent());
                
                
                // Generate the PDF Blob
                Blob pdfBlob = pdfPage.getContent();

                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'sannidhicode@gmail.com'];
                // Create Email
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setOrgWideEmailAddressId(owea.get(0).Id);
                //email.setFromAddress(new String[] {req.fromemail});
                email.setToAddresses(new String[] { req.email });
                email.setSubject(req.subject);
                email.setHtmlBody(req.body);
                
                // Attach PDF
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('DynamicGeneratedPDF.pdf');
                attachment.setBody(pdfBlob);
                //attachment.setBody('pdfBlob');
                attachment.setContentType('application/pdf');
                
                email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
                system.debug('sendEmail========'+email);
                // Send Email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            } catch (Exception e) {
                System.debug('Error sending email: ' + e.getMessage());
            }
        }
    }
    
    global class EmailRequest {

        @InvocableVariable(label='Recipient Email')
        global String email;
        
        @InvocableVariable(label='Lead Record')
        global Lead lead;
        
        @InvocableVariable(label='Sender Email')
        global String fromemail;
        
        @InvocableVariable(label='User Name')
        global String name = 'sowmya';
        
        @InvocableVariable(label='Subject')
        global String subject;
        
        @InvocableVariable(label='Body')
        global String body ;
         @InvocableVariable(label='policyName')
        global String policyName;
        
        @InvocableVariable(label='policyCoverage')
        global String policyCoverage ;
    }
}
public with sharing class BoardPainelController {

    @AuraEnabled
    public static String addResult(String result, String mode){
        Word_S__c gameResult = new Word_S__c(Result__c= result, Mode__c = mode);
        insert gameResult;
        return 'sucess';
    }
}
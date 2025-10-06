public class AccountTriggerHandler {
    public static void scenario10(List<Account> accList, Map<Id, Account> oldmap){
        
        for(Account acc: accList){
            if(acc.Phone != oldMap.get(acc.Id).Phone ){
                acc.Description = '	Phone is updated! old Phone no. is ' + oldmap.get(acc.Id).Phone + 'new phone' + acc.Phone;
            }
        }
    }
    public static void scenario12(List<Account> accList, Map<Id,Account> oldMap){
        for(Account acc: accList){
            if((acc.Industry != null && acc.Industry=='Media') ||( oldmap != null && acc.Industry =='Media' && acc.Industry != oldmap.get(Acc.Id).Industry)){
                acc.Rating = 'Hot';
            }
        }
    }
    public static void scenario14(List<Account> accList, Map<Id,Account> oldMap){
        Map<Id, Account> accMap = new Map<Id, Account>();
        List<Contact> conList= new List<Contact>();
        List<Contact> newCon= new List<Contact>();
        for(Account acc:accList){
            if(acc.Phone !=null  && (acc.Phone != oldmap.get(Acc.Id).Phone ) ){
                accMap.put(acc.Id, acc);
            }
        }
        conList = [SELECT Id, HomePhone, AccountId From Contact WHERE AccountId IN :accMap.keySet()];
        
        for(Contact con :conList){
            con.HomePhone = accMap.get(con.AccountId).Phone;
            newCon.add(con);
        }
        if(!newCon.isEmpty()){
            update newCon;
        }
        
        
    }
    public static void scenario25(List<Account> accList){
        Profile p = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        for(Account acc:accList){
            if(UserInfo.getProfileId() != p.id){
                acc.addError('Only System admin can delete account');
            }
        }
    }
    public static void scenario27(List<Account> accList){
        Set<Id> accId = new Set<Id>();
        for(Account acc:accList){
            accId.add(acc.id);
        }
        Map<Id, Account> accMap = new map<Id, Account>([SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN: accId]);
        for(Account acc: accList){
            if(accMap.get(acc.Id).Opportunities.size()>0){
                acc.addError('You cannot delete account  Where opportunities are available');
            }
        }
    }
    public static void scenario28(List<Account> accList){
        Set<Id> accId = new Set<Id>();
        for(Account acc:accList){
            accId.add(acc.Id);
        }
        Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, (SELECT ID FROM Cases) FROM Account WHERE Id IN: accId]);
        for(Account acc:accList){
            if(accMap.get(acc.Id).Cases.size()>0){
                acc.AddError('Account cannot be deleted where in cases');
            }
        }
    }
    public static void scenarioNew(List<Account> accList){
        for(Account acc:accList){
            if(acc.AnnualRevenue < 1000){
                acc.AnnualRevenue.addError('Annual revneue cannot be less 1000 dollars');
            }
        }
    }
    public static void scenario3new(List<Account> accList){
        List<Contact> conList = new List<Contact>();
        for(Account acc:accList){
            Contact con = new Contact();
            con.AccountId = acc.Id;
       		con.LastName = acc.Name;
            conList.add(con);
        }
        if(!conList.isEmpty()){
            insert conList;
        }
    }
    public static void scenario245(List<Account> accList, Map<Id, Account> oldMap){
        
        for(Account acc: accList){
            if(oldmap.get(acc.Id).Name != null &&(acc.Name != oldmap.get(acc.Id).Name)){
                acc.addError('Account name once created cannot be modified');
            }
        }
    }
    public static void scenario255(List<Account> accList){
        for(Account acc :accList){
            if(acc.Active__c == 'True'){
                acc.AddError('Active account cannot be deleted');
            }
        }
    }
   
    
    public static void sendDeleteConfirmationEmail(List<Account> accList){
        // Prepare email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        // Send to the user who deleted the account
        email.setToAddresses(new String[] { UserInfo.getUserEmail() });
        
        email.setSubject('Account Deletion Confirmation');
        
        String body = 'Hello ' + UserInfo.getName() + ',\n\n';
        body += 'The following accounts have been deleted:\n\n';
        
        for(Account acc : accList){
            body += '- ' + acc.Name + '\n';
        }
        
        body += '\nRegards,\nSalesforce System';
        
        email.setPlainTextBody(body);
        
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }


}
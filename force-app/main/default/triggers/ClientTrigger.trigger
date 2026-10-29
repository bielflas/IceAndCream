trigger ClientTrigger on Client__c (before insert, before update, after insert, after update) {
    for(Client c : Trigger.new){
        if(!c.firstName.IsEmpty() && !c.lastName.IsEmpty() && !c.email.IsEmpty()){
            return c;
        }
        
        if(c.firstName == null || c.lastName == null || c.email == null){
            addError('These are necessary filds');
            return null;
        }
    }
}
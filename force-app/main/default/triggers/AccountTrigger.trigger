trigger AccountTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new){
        if(acc.Phone == null){
            acc.Phone.addError('This is a necessary Field');
        }
    }
}
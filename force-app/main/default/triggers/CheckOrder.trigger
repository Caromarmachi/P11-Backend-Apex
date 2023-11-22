trigger CheckOrder on Order (before update, after delete) {
    System.debug('Log CARO (trigger CheckOrder) : lancement trigger');

    CheckOrderService monService = new CheckOrderService();
    if(Trigger.isUpdate)  {  
        monService.checkStatusOrder((Order)trigger.new[0]);
    } else if (Trigger.isDelete){
        monService.checkAfterDeleteOrder((Order)trigger.old[0]);
    }


}
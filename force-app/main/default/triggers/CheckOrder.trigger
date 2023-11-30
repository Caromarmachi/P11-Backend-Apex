trigger CheckOrder on Order (before update, after delete) {
    System.debug('Log CARO (trigger CheckOrder) : lancement trigger');

    List<Order> listeOrderNew = trigger.new;
    List<Order> listeOrderOld = trigger.old;


    CheckOrderService monService = new CheckOrderService();
    if(Trigger.isUpdate)  {  
        monService.checkStatusOrder(listeOrderNew);
    } else if (Trigger.isDelete){
        monService.checkAfterDeleteOrder(listeOrderOld);
    }

}
public with sharing class CheckOrderService {

    public CheckOrderService() {//Methode constructeur, non utilisée dans notre cas

       // public void CheckOrder(List<Order> newOrders) {
        System.debug('Log CARO (classe service CheckOrderService) : creation du service');

    }

    /**
     * @description Methode qui verifie que la commande  
     * a des produits avant de l'enregistrer en statut activated
     * @author Carolina
     * @return void
     * @param List<Order>
     */
    public void checkStatusOrder(List<Order> mesCommandesList) {  
        System.debug('Log CARO (classe service CheckOrderService) : methode checkStatusOrder');
        //on cree une map avec les commandes
         Map<Id, Order> mesCommandesMap = new Map<Id, Order>();
         for (Order maCommande : mesCommandesList)  {
            if (maCommande.Status.equals('Activated')) {
                mesCommandesMap.put(maCommande.Id, maCommande);
            }
         }

         //on cree la liste des orderItem appartenant aux commandes
        List<OrderItem> maListeItem = [select OrderId from OrderItem where OrderItem.OrderId in:mesCommandesMap.keySet()];

        //on doit supprimer toutes les commandes qui ont des item
         for (OrderItem item : maListeItem) {
            mesCommandesMap.remove(item.OrderId);
         }
         //sur les commandes restantes on ajoute l'erreur
         String messageErreur = System.Label.MessageErreur;
         for(Id idOrder : mesCommandesMap.keySet()) {
            Order maCommande = mesCommandesMap.get(idOrder);
            maCommande.addError(messageErreur);
         }
    }


    /**
     * @description Methode qui modifie le champ active_c des comptes
     * @author Carolina
     * @return void
     * @param List<Order>
     */
    public void checkAfterDeleteOrder(List<Order> mesCommandesList) {
        System.debug('Log CARO (classe service CheckOrderService) : checkAfterDeleteOrder');

       // 1 Liste de commandes supprimées : mesCommandesList
        //map des commandes à supprimer
       Map<Id, Order> mesCommandesMap = new Map<Id, Order>();
       for (Order maCommande : mesCommandesList)  {
              mesCommandesMap.put(maCommande.Id, maCommande);
       }
       System.debug('Log CARO (classe service CheckOrderService) : map mesCommandesMap' + mesCommandesMap.toString());

        // 2 --> Map des comptes concernés  A
        Map<Id,Id> idMapAccountConcernes = new Map<Id,Id>();
        for (Order maCommande : mesCommandesList) {
            idMapAccountConcernes.put(maCommande.AccountId,maCommande.AccountId);
        }

        System.debug('Log CARO (classe service CheckOrderService) : map idMapAccountConcernes' + idMapAccountConcernes.toString());


        // --> liste des autres commandes des comptes concernés C
        List<Order> autresCommandes = [select Id,AccountId from Order where Order.Id not in:mesCommandesMap.keySet() AND Order.AccountId in:idMapAccountConcernes.keySet()];
        // --> on fait une liste des Id des comptes de cette liste C que l'on appelle B

        System.debug('Log CARO (classe service CheckOrderService) : autres commandes' + autresCommandes.isEmpty());

        Map<Id, Id> idMapAccountToRemove = new Map<Id, Id>();
        for (Order autreCommande : autresCommandes) {
            idMapAccountToRemove.put(autreCommande.AccountId,autreCommande.AccountId);
        }
        System.debug('Log CARO (classe service CheckOrderService) : map idMapAccountToRemove' + idMapAccountToRemove.toString());

        // on supprime les  comptes B de la liste A

        idMapAccountConcernes.keySet().removeAll(idMapAccountToRemove.keySet());
 
        // ensuite on met à jour le champ des comptes de la liste A modifiée.
        List<Account> accountToModify = [SELECT Id, Active__c FROM Account WHERE Id in:idMapAccountConcernes.keySet()];
        System.debug('Log CARO (classe service CheckOrderService) : accountToModify' + accountToModify.isEmpty());

        for (Account compte : accountToModify) {
            System.debug('Log CARO (classe service CheckOrderService) active_c = ' + compte.Active__c);
            compte.Active__c = false;    
        }
        update accountToModify;

    }

}
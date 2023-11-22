public with sharing class CheckOrderService {

    public CheckOrderService() {//Methode constructeur, non utilisée dans notre cas
        System.debug('Log CARO (classe service CheckOrderService) : creation du service');
    }

    /**
     * @description Methode qui verifie que la commande  
     * a des produits avant de l'enregistrer en statut activated
     * @author Carolina
     * @return void
     * @param Order
     */
    public void checkStatusOrder(Order maCommande) {
        System.debug('Log CARO (classe service CheckOrderService) : methode checkStatusOrder');
        if (maCommande.Status.equals('Activated')) { // on ne fait les traitements que si le tatut passe à activé
            //On recupere le nombre de produits associé à ma commande
            AggregateResult groupedResults = [SELECT COUNT(Id) nbCommande FROM OrderItem WHERE OrderItem.OrderId = :maCommande.Id];
            boolean hasProduit = false;
            if (groupedResults.get('nbCommande') != null) {
                decimal resultat = (decimal)groupedResults.get('nbCommande');
                if (resultat>0) {
                    hasProduit = true;
                }
            } 

            System.debug('Log CARO (classe service CheckOrderService) : le statut est activated');
            if (!hasProduit) {                    
                maCommande.addError('Meme pas en reve! Il n y a pas de produit');//System.Label.Label_OrderMessageErreur
                System.debug('Log CARO (classe service CheckOrderService) : pas de  produits');
            } else {
                System.debug('Log CARO (classe service CheckOrderService) : y a des produits');
            }

        } else {  //statut non activé
            System.debug('Log CARO (classe service CheckOrderService) : statut non activated, on ne fait rien');
        }
    }

    public void checkAfterDeleteOrder(Order maCommande) {
        System.debug('Log CARO (classe service CheckOrderService) : methode checkAfterDeleteOrder');
        AggregateResult countOrder = [SELECT COUNT(Id) nbOrder FROM Order WHERE Order.AccountId = :maCommande.AccountId];
        boolean hasOrder = false;
        if (countOrder.get('nbOrder') != null) {
            decimal resultat = (decimal)countOrder.get('nbOrder');
            System.debug('Log CARO (classe service CheckOrderService) : nombre de commande' + resultat);

            if (resultat>0) {
                hasOrder = true;
            }
        } 
        System.debug('Log CARO (classe service CheckOrderService) : recherche du compte');

        Account account = [SELECT Id, Active__c FROM Account WHERE Id = :maCommande.AccountId];
        if(!hasOrder) {
            account.Active__c = false;
        } else {
            account.Active__c = true;
        }
        update account;
    }

}
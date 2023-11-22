public with sharing class PopulateFakeDatas {

    private Account account1;

    public PopulateFakeDatas() {
    }

    public Account getAccount() {
        return this.account1;
    }

    public Order createOneOrder() {      
        this.account1 = new Account(Name = 'Test Account 1');
        insert account1;
        Order myOrder = new Order();
        myOrder.AccountId = account1.Id;
        myOrder.EffectiveDate = Date.today();
        myOrder.Status = 'Draft';
        myOrder.Pricebook2Id = Test.getStandardPricebookId();
        // definir tous les champs obligatoires

        insert myOrder;

        return myOrder;

    }

    public void create200Account() { 
        
        List<Account> maListe = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account account = new Account(Name = 'Test Account '+i);
            maListe.add(account);
        }
        insert maListe;
    }


    

}
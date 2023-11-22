
@isTest
private class CheckOrderServiceTest {
    @isTest
    static void testStatusOrder (){
        
        //creation des fakes datas
        PopulateFakeDatas myDataTool = new PopulateFakeDatas();
        Order myOrder = myDataTool.createOneOrder();
        Test.startTest();
        myOrder.Status = 'Activated';
        update myOrder;
        Test.stopTest();
        // Vérification des résultats
        System.assertEquals(true,myOrder.hasErrors(),'Test OK - l objet order a bien une erreur');
    }

    @isTest
    static void testAfterDeleteOrder (){
        //creation des fakes datas
        PopulateFakeDatas myDataTool = new PopulateFakeDatas();
        Order myOrder = myDataTool.createOneOrder();
        Test.startTest();
        myOrder.Active__c = true;
        Account compteLie = myDataTool.getAccount();
        delete myOrder;

        Test.stopTest();
        // Vérification des résultats
        System.assertEquals(false,compteLie.Active__c,'Test OK - la coche active a bien été desactivée');
    }



    }
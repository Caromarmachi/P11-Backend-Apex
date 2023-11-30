
@isTest
private class CheckOrderServiceTest {
    @isTest
    static void testStatusOrder (){
        
        //creation des fakes datas
        PopulateFakeDatas myDataTool = new PopulateFakeDatas();
        Order myOrder = myDataTool.createOneOrder();
        Test.startTest();
        myOrder.Status = 'Activated';
        boolean statutValide = false;
        try {
          update myOrder;
          statutValide = true;
        } catch (System.DmlException e) {
            System.debug('Log CARO : Exception voulue, on ne peut pas updater si pas d article donc ignoree');
        }
        Test.stopTest();
        // Vérification des résultats
        System.assertEquals(false,statutValide,'Test OK - l objet order a bien une erreur');
    }

    @isTest
    static void testAfterDeleteOrder (){
        //creation des fakes datas
        PopulateFakeDatas myDataTool = new PopulateFakeDatas();
        Order myOrder = myDataTool.createOneOrder();
        Test.startTest();
        Account compteLie = myDataTool.getAccount();
        update compteLie;

        delete myOrder;

        Test.stopTest();
        // Vérification des résultats
        System.assertEquals(false,compteLie.Active__c,'Test OK - la coche active a bien été desactivée');
    }



    }
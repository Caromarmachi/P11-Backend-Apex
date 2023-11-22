@isTest
private class BatchCreateTaskForContactTest {
    @isTest
    static void testOneAccount (){
        //populate les données dont j'ai besoin
        Account account1 = new Account(Name = 'Test Account 1');
        
        insert account1;


        Test.startTest();
        //lancer le batch
        BatchCreateTaskForContact monBatch = new BatchCreateTaskForContact();
        Database.executeBatch(monBatch);

        Test.stopTest();

        // Vérification des résultats
        List<Task> newTasks =  [SELECT Id, AccountId FROM Task WHERE Subject='Call'];
        Boolean auMoinsUneTache = false;
        if (newTasks!=null && newTasks.size()>0) {
            auMoinsUneTache = true;
        }

        System.assertEquals(true,auMoinsUneTache,'Test OK --> On a au moins une tache');

    }


    @isTest
    static void test200Account (){
        //populate les données dont j'ai besoin
        PopulateFakeDatas myDataTool = new PopulateFakeDatas();
        myDataTool.create200Account();


        Test.startTest();
        //lancer le batch
        BatchCreateTaskForContact monBatch = new BatchCreateTaskForContact();
        Database.executeBatch(monBatch);

        Test.stopTest();

        // Vérification des résultats
        List<Task> newTasks =  [SELECT Id, AccountId FROM Task WHERE Subject='Call'];
        Boolean auMoins200Tache = false;
        if (newTasks!=null && newTasks.size()>199) {
            auMoins200Tache = true;
        }

        System.assertEquals(true,auMoins200Tache,'Test OK --> On a au moins 200 taches');

    }

    }


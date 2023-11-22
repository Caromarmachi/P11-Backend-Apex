global with sharing class BatchCreateTaskForContact implements Schedulable, Database.Batchable<sObject> {

    private String query = 'SELECT Id, OwnerId, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order)'; 
    private List<Task> taskList = new List<Task>();

    global void execute(SchedulableContext sc) {
        System.debug('Log CARO (batch BatchCreateTaskForContact) : methode execute(SchedulableContext sc)');
        Database.executeBatch(this);

    }


    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Log CARO (batch BatchCreateTaskForContact) : methode start');

        return Database.getQueryLocator(query);


    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {
        System.debug('Log CARO (batch BatchCreateTaskForContact) : methode execute(Database.BatchableContext BC, List<Account> scope)');

        Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>(scope);
        System.debug('Log CARO : nb de comptes trouves ' + accountIdToAccountMap.keySet().size());

        List<Task> relatedTask =  [SELECT Id, AccountId, Subject FROM Task WHERE Subject='Call' AND WhatId IN :accountIdToAccountMap.keySet()];
        System.debug('Log CARO : nb de tache call ' + relatedTask.size());
        // on enleve de la liste des compte les comptes qui ont des taches call
        for (Task tache : relatedTask) {
            accountIdToAccountMap.remove(tache.AccountId);
        }

        System.debug('Log CARO : nb de comptes trouves apres suppression de ceux qui ont des taches call ' + accountIdToAccountMap.keySet().size());

        List<Task> tacheToCreate = new List<Task>();
        for(Id key : accountIdToAccountMap.keySet()) {
            Account account = accountIdToAccountMap.get(key);
            // creer une tache avec whatIT : compte  et le owner ID : 
            Datetime currentDate = System.now();
            Datetime dateInFiveDays = currentDate.addDays(5);
            Task newTask = new Task();
            newTask.OwnerId = account.OwnerId;
            newTask.WhatId = account.Id;
            newTask.Subject = 'Call';
            newTask.Status = 'New';
            newTask.Priority = 'Normal';
            newTask.IsReminderSet = true;
            newTask.ReminderDateTime = dateInFiveDays;
            tacheToCreate.add(newTask);
        }

        try {
            insert tacheToCreate;
        } catch (DMLException e) {
            System.debug('Tasks not inserted: ' + e);
        }

        System.debug('Log CARO : nb de taches crees ' + tacheToCreate.size());

    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Log CARO (batch BatchCreateTaskForContact) : methode finish');

        // Actions à exécuter après la fin de l'exécution du lot
    }
}
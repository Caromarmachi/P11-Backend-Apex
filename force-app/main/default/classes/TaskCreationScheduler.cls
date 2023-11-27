global class TaskCreationScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchCreateTaskForContact());
    }
}


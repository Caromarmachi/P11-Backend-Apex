@IsTest
private class TaskCreationSchedulerTest {
    @IsTest
    static void testSchedulerExecution() {
        Test.startTest();

        String jobId = System.schedule('TaskCreationScheduler', '0 0 0 ? * 2#1', new TaskCreationScheduler());
        System.debug('Log CARO : Batch job scheduled with ID: ' + jobId);

        Test.stopTest();

        
}

}
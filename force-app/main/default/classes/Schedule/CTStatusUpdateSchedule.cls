public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON = '0 0 3 * * ?';
    public void execute(SchedulableContext sc){
        CTUpdatePersonStatusBatch  personStatusUpdate = new CTUpdatePersonStatusBatch();
        Database.executeBatch(personStatusUpdate, 2000);

        CTUpdateLocationStatusBatch  locationStatusUpdate = new CTUpdateLocationStatusBatch();
        Database.executeBatch(locationStatusUpdate, 2000);
    }
    
}
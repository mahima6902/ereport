using app.ereport from '../db/report';

service ereport_service 
//@(require: 'authenticated-user') 
{
    entity Course_Details as projection on ereport.Course_Details;

    entity Registeration_Details as projection on ereport.Registeration_Details;

    entity Student_Details as projection on ereport.Student_Details;
}
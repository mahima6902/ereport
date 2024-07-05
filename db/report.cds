namespace app.ereport;
using { cuid , managed } from '@sap/cds/common';
using {vh} from '../db/valuehelp';

type Text : String(16);

//@odata.draft.enabled 
//tableA - course details
entity Course_Details {
    key courseid  : UUID  @(Core.Computed : true);

    @mandatory
    @title : 'Course Description'
    key coursedescription : String(50);

    @title : 'Duration of Course'
    duration : Integer enum {
    TwoYears = 2;
    ThreeYears = 3;
    FourYears  = 4;
    FiveYears  = 5;
    SixYears   = 6;
}; 
//not null;

//     @title : 'Number of Semesters'
//     semnumber : Integer = case duration 
//     when 2 then 4
//     when 3 then 6
//     when 4 then 8
//     when 5 then 10
//     when 6 then 12
//     else 1
// end                       @Core.Computed;
}


//tableB - student registeration details
entity Registeration_Details {
    key regnumber : UUID   @(Core.Computed : true);

    @title : 'Course ID'
    courseid : UUID;
    coursedetail : Association to Course_Details on coursedetail.courseid = courseid;

    @title : 'Date of joining'
    joindate : Date  @changelog;

    @mandatory
    @title : 'HSC Passing Year'
    hsc : Integer  @assert.range : [1900, 9999]    @changelog;

    @mandatory
    @title : 'SSC Passing Year'
    ssc : Integer  @assert.range : [1900, 9999]    @changelog;     
}


//tableC - student personal details
@assert.unique : {masterkey : [
    studentname,
    fathername,
]}

entity Student_Details {
    key reginumber : UUID;

    // @title : 'Course ID'
    // regnumber : Integer;
    reginum : Association to Registeration_Details on  reginum.regnumber = reginumber;

    @title : 'Student name'
    studentname : String(16)  @changelog;

    @title : 'Father name'
    fathername : String(16)  @changelog;
  
    @title : 'Age'
    age : Integer   @changelog;

    @title : 'Gender'
    gender : String(1) @assert.range : ['M', 'F', 'O'];

    @title : 'Address'
    address : String(64)   @changelog;

    @title : 'Contact Number'
    mobnumber : String(10) @assert.format : '^[0-9]{10}$';
}

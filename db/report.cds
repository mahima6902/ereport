namespace app.ereport;
using { cuid , managed } from '@sap/cds/common';
using {vh} from '../db/valuehelp';

type Text : String(16);

//@odata.draft.enabled 
//tableA - course details
entity Course_Details {
    key courseid  : Integer;

    @mandatory
    @title : 'Course Description'
    key coursedescription : String(50);

    @title : 'Number of semesters'
    semnumber : Integer ;
    //   = case duration
    // when 2 then 4
    // when 3 then 6
    // when 4 then 8
    // when 5 then 8
    // when 6 then 12
    // else 1
    // end;    

    @title : 'Duration of Course'
    duration : Integer enum {
    TwoYears = 2;
    ThreeYears = 3;
    FourYears  = 4;
    FiveYears  = 5;
    SixYears   = 6;
} not null;
}


//tableB - student registeration details
entity Registeration_Details {
    @title : 'Registeration Number'
    regnumber : String   @(Core.Computed : true);

    @title : 'Course ID'
    courseid : Integer;
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
    key reginumber : String;
    reginum : Association to Registeration_Details on  reginum.regnumber = reginumber;

    @title : 'Student name'
    studentname : String(16)  @changelog;

    @title : 'Father name'
    fathername : String(64)  @changelog;
  
    @title : 'Age'
    age : Integer   @changelog;

    @title : 'Gender'
    gender : String(1) @assert.range : ['M', 'F', 'O'];

    @title : 'Address'
    address : String(128)  @changelog;

    @title : 'Contact Number'
    mobnumber : String(16) @assert.format : '^[0-9]{10}$';
}


//table D - student academic details

entity Academic_Details {
  @title : 'Registeration Number'
  key regn : String;
  regin : Association to Registeration_Details on  regin.regnumber = regn;

  @title : 'Ongoing Semester'
  ongoingsemester : Integer;

  @title : 'Roll number'
  rollnum : String;

  @title : 'Section'
  section : String;

  @title : 'Subject Codes'
  subjectcodes : Composition of many {

    @title : 'Code of particular Subject'
    code : String;

    @title : 'Marks obtained'
    marks : String;
  };

  @title : 'Total marks obtained'
  totalmarks : Decimal;
}


//table E - Subject Details
entity Subject_Details : cuid {
  @title : 'Course ID'
  courseid : Integer;

  @title : 'Ongoing Semester'
  key ongoingsemester : Integer;

  @title : 'Subject Code'
  key code : String;

  @title : 'Subject Description'
  subdescription : String; 
}

view er.Course_Detail as select from Course_Details as cDetail
{
    cDetail.courseid as courseID,
    cDetail.coursedescription as courseName,
    cDetail.duration as completeDuration
}
using {app.ereport as er} from '../db/report';

service ereport_service //@(require: 'authenticated-user')

{
    entity Course_Details as projection on er.Course_Details;

    @cds.redirection.target: true
    entity Registeration_Details as projection on er.Registeration_Details;

    entity Student_Details as projection on er.Student_Details;

    entity Academic_Details as projection on er.Academic_Details;

    entity Subject_Details as projection on er.Subject_Details;

    entity F4_courseid as projection on ereport_service.Registeration_Details;
}

//annotations for table - A
@odata.draft.enabled
annotate er.Course_Details with @(UI: {
    CreateHidden              : false,
    UpdateHidden              : false,
    DeleteHidden              : false,
    HeaderInfo                : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'E-Report Page',
        TypeNamePlural: 'E-Report Page',
        Title         : {Value: courseid},
        Description   : {Value: 'E-Report Page'}
    },

    SelectionFields           : [
        courseid,
        coursedescription,
        duration,
        semnumber
    ],

    LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: courseid,
            Label: 'Course ID'
        },

        {
            $Type: 'UI.DataField',
            Value: coursedescription,
            Label: 'Course Description'
        },

        {
            $Type: 'UI.DataField',
            Value: duration,
            Label: 'Duration of Course'
        },

        {
            $Type: 'UI.DataField',
            Value: semnumber,
            Label: 'Number of Semesters'
        },
    ],

    Facets                    : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'Course Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#CourseEnrolled',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '2',
            Label : 'Timing Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#DurationTaken',
            }],
        },
    ],

    FieldGroup #CourseEnrolled: {Data: [
        {Value: courseid},
        {Value: coursedescription},
        {Value: duration},
        {Value: semnumber},
    ]},

    FieldGroup #DurationTaken : {Data: [
        {Value: courseid},
        {Value: coursedescription},
        {
            Value                  : duration,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            Value                  : semnumber,
            ![@Common.FieldControl]: #ReadOnly
        },
    ]},

});


//annotations for table - B
annotate er.Registeration_Details with @(UI: {
    HeaderInfo                : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'E-Report Page',
        TypeNamePlural: 'E-Report Page',
        Title         : {Value: regnumber},
        Description   : {Value: 'E-Report Page'}
    },

    SelectionFields           : [
        courseid,
        regnumber,
        hsc,
        ssc,
        joindate
    ],

    LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: regnumber,
            Label: 'Registeration Number'
        },

        {
            $Type: 'UI.DataField',
            Value: courseid,
            Label: 'Course ID'
        },

        {
            $Type: 'UI.DataField',
            Value: joindate,
            Label: 'Date of Joining'
        },

        {
            $Type: 'UI.DataField',
            Value: hsc,
            Label: 'HSC Passing Year'
        },

        {
            $Type: 'UI.DataField',
            Value: ssc,
            Label: 'SSC Passing Year'
        },
    ],

    Facets                    : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'Course Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#Course',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '2',
            Label : 'Other Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#OtherData',
            }],
        },
    ],

    FieldGroup #Course: {Data: [
        {Value: courseid},
        {Value: regnumber},
    ]},

    FieldGroup #OtherData : {Data: [
        {Value: joindate},
        {Value: hsc},
        {Value: ssc},
        {
            Value                  : regnumber,
            ![@Common.FieldControl]: #ReadOnly
        },

        {
            Value                  : joindate,
            ![@Common.FieldControl]: #ReadOnly
        },
    ]},

});

annotate er.Registeration_Details with {
    courseid @(
        title         : 'Course ID',
        sap.value.list: 'fixed-values',
        Commmon       : {
            ValueListWithFixedValues,
            ValueList: {

                CollectionPath: 'F4_courseid',
                Parameters    : [
                    {
                        $Type            : 'Common.ValueListParameterInOut',
                        ValueListProperty: 'registerationNumber',
                        LocalDataProperty: regnumber,
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'courseID',
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'joinDate',
                    },
                ]
            },
        }
    )

};


//annotations for table - C
@odata.draft.enabled
annotate er.Student_Details with @(UI: {
    CreateHidden              : false,
    UpdateHidden              : false,
    DeleteHidden              : false,
    HeaderInfo                : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'E-Report Page',
        TypeNamePlural: 'E-Report Page',
        Title         : {Value: reginumber},
        Description   : {Value: 'E-Report Page'}
    },

    SelectionFields           : [
        reginumber,
        studentname,
        age,
        gender
    ],

    LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: reginumber,
            Label: 'Registeration Number'
        },

        {
            $Type: 'UI.DataField',
            Value: studentname,
            Label: 'Name of Student'
        },

        {
            $Type: 'UI.DataField',
            Value: fathername,
            Label: 'Name of Father'
        },

        {
            $Type: 'UI.DataField',
            Value: age,
            Label: 'Age of Student'
        },

        {
            $Type: 'UI.DataField',
            Value: gender,
            Label: 'Gender of Student'
        },

        {
            $Type: 'UI.DataField',
            Value: address,
            Label: 'Addess of Student'
        },

        {
            $Type: 'UI.DataField',
            Value: mobnumber,
            Label: 'Contact Number of Student'
        }
    ],

    Facets                    : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'Student Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#Student',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '2',
            Label : 'Other Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#PersonalData',
            }],
        },
    ],

    FieldGroup #Student: {Data: [
        {Value: reginumber},
        {Value: studentname},
        {Value: age},
        {Value: gender},
    ]},

    FieldGroup #PersonalData : {Data: [
        {Value: fathername},
        {Value: address},
        {Value: mobnumber},
        {
            Value                  : mobnumber,
            ![@Common.FieldControl]: #ReadOnly
        },

        {
            Value                  : address,
            ![@Common.FieldControl]: #ReadOnly
        },
    ]},

});


//annotations for table - D

annotate er.Academic_Details with @( 
  cds.persistence.skip : false,  
  UI: {
    SelectionFields: [ regn, subjectcodes.code ],
    LineItem: [
        {
            $Type: 'UI.DataField',
            Value: regn,
            Label: 'Registeration Number'
        },

        {
            $Type: 'UI.DataField',
            Value: rollnum,
            Label: 'Roll Number'
        },

        {
            $Type: 'UI.DataField',
            Value: ongoingsemester,
            Label: 'Semester'
        },

        {
            $Type: 'UI.DataField',
            Value: totalmarks,
            Label: 'Total marks obtained'
        },

        {
            $Type: 'UI.DataField',
            Value: section,
            Label: 'Section'
        },
        {
            $Type: 'UI.DataField',
            Value: subjectcodes.code,
            Label: 'Subject Code'
        },

        {
            $Type: 'UI.DataField',
            Value: subjectcodes.marks,
            Label: 'Marks Obtained'
        },


    ],
    HeaderInfo: {
      $Type : 'UI.HeaderInfoType',
      TypeName: 'Student Record',
      TypeNamePlural: 'Student Records',
      Title: { Value: regn },
      Description: { Value: rollnum }
    },

   Facets                    : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'General Information',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#GenInfo',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '2',
            Label : 'Marking Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#marks',
            }],
        },
    ],

    FieldGroup #GenInfo: {Data: [
        {Value: regn},
        {Value: rollnum},
        {Value: ongoingsemester},
        {Value: section},
    ]},

    FieldGroup #marks : {Data: [
        {Value: subjectcodes.code},
        {Value: subjectcodes.marks},
        {Value: totalmarks},
        {
            Value                  : rollnum,
            ![@Common.FieldControl]: #ReadOnly
        },

        {
            Value                  : totalmarks,
            ![@Common.FieldControl]: #ReadOnly
        },
    ]},

});

annotate er.Academic_Details.subjectcodes with @(
  cds.persistence.skip : false,  
  UI: {
    LineItem: [
        {
            $Type: 'UI.DataField',
            Value: code,
            Label: 'Subject Code'
        },

        {
            $Type: 'UI.DataField',
            Value: marks,
            Label: 'Marks Obtained'
        },

    ]
  }
);


//annotations for table - E
@odata.draft.enabled
annotate er.Subject_Details with @(UI: {
    CreateHidden              : false,
    UpdateHidden              : false,
    DeleteHidden              : false,
    HeaderInfo                : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'E-Report Page',
        TypeNamePlural: 'E-Report Page',
        Title         : {Value: courseid},
        Description   : {Value: 'E-Report Page'}
    },

    SelectionFields           : [
        courseid,
        subdescription,
        code,
        ongoingsemester
    ],

    LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: courseid,
            Label: 'Course ID'
        },

        {
            $Type: 'UI.DataField',
            Value: subdescription,
            Label: 'Subject Description'
        },

        {
            $Type: 'UI.DataField',
            Value: ongoingsemester,
            Label: 'Ongoing Semester'
        },

        {
            $Type: 'UI.DataField',
            Value: code,
            Label: 'Subject Code'
        },
    ],
     Facets                    : [
        
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'Course Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#course',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '2',
            Label : 'Subject Details',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#subject',
            }],
        },
    ],

    FieldGroup #course: {Data: [
        {Value: courseid},
        {Value: ongoingsemester},
    ]},

    FieldGroup #subject : {Data: [
        {Value: subdescription},
        {Value: code},
    ]},

});
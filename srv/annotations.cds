using {ereport_service as srv} from './service';
using {app.ereport as er} from '../db/report';

annotate er.Course_Details with @(UI: {
    LineItem       : [
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
        }
    ],

//comment----------------------------------
    //         SelectionFields: [name],
    //         LineItem
    //         [
    //             {
    //                 Value : description
    //             }
    //         ]
    //         Identification : 
        //     [
        //         {
        //              Value : courseid
        //         }
        //     ],

    //         HeaderInfo : {
    //         TypeName : 'Course_Detail', 
    //         TypeNamePlural : 'Course_Details', 
    //         Title : 
    //         {
    //         Value : courseid
    //         }, 
    //         Description : 
    //         {
    //         Value : description
    //         }
    // }
//comment----------------------------------
});

annotate er.Registeration_Details with @(UI: {
    LineItem       : [
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
        }
    ],
});

//comment----------------------------------
// @(assert.integrity : {
//   sscAfterHsc : {
//     message : 'SSC passing year must be greater than HSC passing year',
//     condition : sscPassingYear > hscPassingYear
//   },
//   yearDifference : {
//     message : 'Difference between HSC and SSC passing years cannot exceed 3 years',
//     condition : sscPassingYear - hscPassingYear <= 3 and sscPassingYear - hscPassingYear > 0
//   },
//   validYears : {
//     message : 'HSC and SSC passing years must be in the past',
//     condition : hscPassingYear <= $now.year and sscPassingYear <= $now.year
//   }
// });
//comment----------------------------------

annotate er.Student_Details with @(UI: {
    LineItem       : [
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
});

annotate er.Academic_Details with @( 
  cds.persistence.skip : false,  
  UI: {
    SelectionFields: [ regn ],
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

    ],
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

annotate er.Subject_Details with @(
  cds.persistence.skip : false,  
  UI: {
    LineItem: [
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
    ]
  }
);

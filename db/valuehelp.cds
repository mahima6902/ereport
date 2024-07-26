using {cuid , managed} from '@sap/cds/common';
using {app.ereport as er} from '../db/report';

namespace vh;

@cds.odata.valuelist
entity Course_DetailsVH as
    projection on er.Course_Details {
        key courseid,
        key coursedescription,
            duration,
            semnumber,
    }

@cds.odata.valuelist
entity Registeration_Details as
    projection on er.Registeration_Details {
        key regnumber,
            courseid,
            joindate,
            hsc,
            ssc,
    }

@cds.odata.valuelist
entity Student_Details as
    projection on er.Student_Details {
        key reginumber,
            studentname,
            fathername,
            age,
            gender,
            address,
            mobnumber,
    }

    @cds.odata.valuelist
entity Academic_Details as
    projection on er.Academic_Details {
        key regn,
            rollnum,
            ongoingsemester,
            section,
            totalmarks,
            subjectcodes,
            subjectcodes.code,
            subjectcodes.marks,
    }

    @cds.odata.valuelist
entity Subject_Details as
    projection on er.Subject_Details {
        key courseid,
        key code,
        key ongoingsemester,
            subdescription,
    }


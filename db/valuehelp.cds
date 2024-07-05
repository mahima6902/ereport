using {cuid , managed} from '@sap/cds/common';
using {app.ereport as er} from '../db/report';

namespace vh;

@cds.odata.valuelist
entity Course_DetailsVH as
    projection on er.Course_Details {
        key courseid,
        key coursedescription,
            duration,
//            semnumber,
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
            reginum,
            studentname,
            fathername,
            age,
            gender,
            address,
            mobnumber,
    }


const cds = require('@sap/cds');
const xsenv = require('@sap/xsenv');
//const { ODataServer } = require('@sap/cds/lib/odata/server');
const { type } = require('express/lib/response');
module.exports = cds.service.impl(async function () {

const odata = new ODataServer(this);

//function to validate year
const validateYear = (year) => {
  const currentYear = new Date().getFullYear();
  return year >= 1900 && year <= currentYear;
};

this.before('CREATE', 'Course_Details', (req) => {
  const { duration } = req.data;
  if (![3, 4, 5, 6].includes(duration)) {
      req.error(400, 'Invalid duration. Must be 3, 4, 5, or 6.');
  }
  req.data.semnumber = duration * 2;
});

this.before('CREATE', 'Registeration_Details', (req) => {
  const { ssc, hsc } = req.data;
  if (ssc <= hsc) {
      req.error(400, 'SSC passing year must be greater than HSC passing year.');
  }
  if (ssc - hsc > 3) {
      req.error(400, 'Difference between HSC and SSC cannot be more than 3 years.');
  }
});

this.before('CREATE', 'Student_Details', (req) => {
  const { gender, mobnumber } = req.data;
  if (!['M', 'F', 'O'].includes(gender)) {
      req.error(400, 'Invalid gender. Must be M, F, or O.');
  }
  if (!/^\d+$/.test(mobnumber)) {
      req.error(400, 'Mobile number should only contain digits.');
  }
});


// Table A: Courses
const Course_Details = {
  schema: {
    courseid: { type: 'Integer', primaryKey: true },
    coursedescription: { type: 'String(50)', primaryKey: true },
    duration: { type: 'Integer', enum: [3, 4, 5, 6] },
    semnumber: { type: 'Integer', calculated: true }
  },
  
  calculatesemnumber: (duration) => {
    return duration * 2;
  },
  
  validateRecord: (record) => {
    if (!Course_Details.schema.duration.enum.includes(record.duration)) {
      throw new Error('Invalid duration. Must be 3, 4, 5, or 6.');
    }
    record.semnumber = Course_Details.calculatesemnumber(record.duration);
    return record;
  }
};

// Table B: Student Registration
const Registeration_Details = {
  schema: {
    regnumber: { type: 'String', primaryKey: true },
    courseid: { type: 'Integer', foreignKey: 'Course_Details.courseid' },
    ssc: { type: 'Integer' },
    joindate: {type : 'Date'},
    hsc: { type: 'Integer' }
  },
  
  validateRecord: (record, Course_Details) => {
    if (!Course_Details.find(course => course.courseid === record.coursid)) {
      throw new Error('Invalid Course ID. Must exist in Course_Details.');
    }

    if (!validateYear(record.ssc) || !validateYear(record.hsc)) {
      throw new Error('Invalid passing year.');
    }
    
    if (record.ssc <= record.hsc) {
      throw new Error('SSC passing year must be greater than HSC passing year.');
    }
    
    if (record.ssc - record.hsc > 3) {
      throw new Error('Difference between HSC and SSC cannot be more than 3 years.');
    }
    
    return record;
  }
};

// Table C: Student Details
const Student_Details = {
  schema: {
    reginumber: { type: 'String', primaryKey: true, foreignKey: 'Registeration_Details.regnumber' },
    gender: { type: 'String', enum: ['M', 'F', 'O'] },
    studentname: { type: 'String(16)' },
    fathername: { type: 'String(64)' },
    age: { type: 'Integer' },
    address: { type: 'String(128)' },
    mobnumber: { type: 'String(16)' },
  },
  
  validateRecord: (record, Registeration_Details) => {
    if (!Registeration_Details.find(student => student.reginumber === record.regnumber)) {
      throw new Error('Invalid Registration Number. Must exist in Registeration_Details.');
    }
    
    if (!Student_Details.schema.gender.enum.includes(record.gender)) {
      throw new Error('Invalid gender. Must be M, F, or O.');
    }
    
    if (!/^\d+$/.test(record.mobNo)) {
      throw new Error('Mobile number should only contain digits.');
    }
    
    return record;
  },
  
  getGenderFullForm: (gender) => {
    const genderMap = { 'M': 'Male', 'F': 'Female', 'O': 'Others' };
    return genderMap[gender] || 'Unknown';
  }
};

// Table D: Student Subjects
const Academic_Details = {
  schema: {
    regn: { type: 'String', foreignKey: 'Registeration_Details.regnumber' },
    ongoingsemester: { type: 'Integer' },
    rollnum : {type: 'String'},
    section : {type: 'String'},
    totalmarks : {type: 'Decimal'},
    subjectcode: { type: 'array' },
    marks : {type: 'String'},
    code : {type: 'String'},
  },
  
  validateRecord: (record, Course_Details, Registeration_Details) => {
    const studentRecord = Registeration_Details.find(student => student.regn === record.regnumber);
    if (!studentRecord) {
      throw new Error('Invalid Registration Number. Must exist in Registeration_Details.');
    }
    
    const courseRecord = Course_Details.find(course => course.courseid === studentRecord.courseid);
    if (!courseRecord) {
      throw new Error('Course not found for the given Registration Number.');
    }
    
    if (record.ongoingsemester < 1 || record.semester > courseRecord.semnumber) {
      throw new Error(`Invalid semester. Must be between 1 and ${courseRecord.semnumber}.`);
    }

    if (!record.subjectcode.every(subjectcode => courseRecord.subjectcode.includes(subjectcode))) {
      throw new Error('Invalid subject. All subjects must exist in the course curriculum.');
    }
    
    return record;
  }
};

// Table E: Course Subjects
const Subject_Details = {
  schema: {
    courseid: { type: 'Integer', primaryKey: true, foreignKey: 'Course_Details.courseid' },
    code: { type: 'String', primaryKey: true },
    ongoingsemester: { type: 'Integer', primaryKey: true },
    subdescription: {type: 'String'}
  },
  
  validateRecord: (record, Course_Details) => {
    const courseRecord = Course_Details.find(course => course.courseid === record.courseid);
    if (!courseRecord) {
      throw new Error('Invalid Course ID. Must exist in Course_Details.');
    }
    
    if (record.ongoingsemester < 1 || record.ongoingsemester > courseRecord.semnumber) {
      throw new Error(`Invalid semester. Must be between 1 and ${courseRecord.semnumber}.`);
    }    
    return record;
  }
};

const createRecord = (table, record, relatedTables = {}) => {
  try {
    const validatedRecord = table.validateRecord(record, relatedTables.Course_Details, relatedTables.Registeration_Details);
    console.log('Record created successfully:', validatedRecord);
  } catch (error) {
    console.error('Error creating record:', error.message);
  }
};

module.exports = {
  Course_Details,
  Registeration_Details,
  Student_Details,
  Academic_Details,
  Subject_Details,
  createRecord
};


// odata-services
    const model = {
        namespace: "eReport",
        entityTypes: {
            Course_Details: {
                courseid: { type: "Integer", key: true },
                coursedescription: { type: "String(50)", key: true },
                duration: { type: "Integer" },
                semnumber: { type: "Integer" }
            },
            Registeration_Details: {
                regnumber: { type: "String", key: true },
                courseid: { type: "Integer" },
                ssc: { type: "Integer" },
                hsc: { type: "Integer" },
                joindate: {type: "date"}
            },
            Student_Details: {
                reginumber: { type: "String", key: true },
                gender: { type: "String(1)" },
                mobnumber: { type: "String(16)" },
                studentname: { type: "String(16)" },
                fathername: { type: "String(64)" },
                age: { type: "Integer" },
                address: { type: "String(128)" }
            },
            Academic_Details: {
                regn: { type: "String" },
                ongoingsemester: { type: "Integer" },
                subjectcode: { type: "Collection(String)"},
                marks: {type: "Integer"},
                code: {type: "String"},
                rollnum: { type: "String" },
                section: { type: "String" },
                totalmarks: { type: "Decimal" },
            },
            Subject_Details: {
                courseid: { type: "String", key: true },
                code: { type: "String", key: true },
                ongoingsemester: { type: "Integer", key: true },
                subdescription: {type: "String"}
            }
        },
        entitySets: {
            Course_Details: { entityType: "eReport.Course_Details" },
            Registeration_Details: { entityType: "eReport.Registeration_Details" },
            Student_Details: { entityType: "eReport.Student_Details" },
            Academic_Details: { entityType: "eReport.Academic_Details" },
            Subject_Details: { entityType: "eReport.CourseSubject_Details" }
        }
    };

    const odataServer = ODataServer()
        .model(model)
        .adapter(Adapter(function(cb) { cb(null, db); }));

    odataServer.beforeCreate((req, res, next) => {
        const entitySet = req.params.collection;
        const entity = req.body;

    });
  });

      // Use OData middleware
    cds.on('bootstrap', (app) => {
      app.use("/odata", function(req, res) {
        odataServer.handle(req, res);
    });
    });

//   //starting server
//   const port = process.env.PORT || 4004
//   app.listen(port, () => {
//   console.log(`Server is listening on port ${port}`)
// })

module.exports = cds.server // Expose express app for testing
if (process.env.NODE_ENV !== 'test') {
  cds.once('served', () => {
    const app = cds.app
  })
}


  // const { Course_Details, Registeration_Details, Student_Details, Academic_Details, Subject_Details } = this.entities;
    
  //   this.on('READ', Course_Details, async (req) => { 
  //     const { SELECT } = cds.ql
  //     console.log('>> delegating to remote service...')
  //     return await SELECT.from(Course_Details)     
  //   })
  
  //   this.on('READ', Registeration_Details, async (req) => {
  //     const { SELECT } = cds.ql
  //     return await SELECT.from(Registeration_Details).expand('Course_Details')
  //   })

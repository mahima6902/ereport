using ereport_service as service from '../../srv/service';
annotate service.Course_Details with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : coursedescription,
            },
            {
                $Type : 'UI.DataField',
                Value : duration,
            },
            {
                $Type : 'UI.DataField',
                Value : semnumber,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : coursedescription,
        },
        {
            $Type : 'UI.DataField',
            Value : duration,
        },
        {
            $Type : 'UI.DataField',
            Value : semnumber,
        },
    ],
);


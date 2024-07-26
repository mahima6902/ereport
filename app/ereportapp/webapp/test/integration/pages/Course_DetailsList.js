sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ereportapp',
            componentId: 'Course_DetailsList',
            contextPath: '/Course_Details'
        },
        CustomPageDefinitions
    );
});
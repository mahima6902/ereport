sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'ereportapp',
            componentId: 'Course_DetailsObjectPage',
            contextPath: '/Course_Details'
        },
        CustomPageDefinitions
    );
});
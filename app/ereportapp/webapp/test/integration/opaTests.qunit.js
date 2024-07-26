sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ereportapp/test/integration/FirstJourney',
		'ereportapp/test/integration/pages/Course_DetailsList',
		'ereportapp/test/integration/pages/Course_DetailsObjectPage'
    ],
    function(JourneyRunner, opaJourney, Course_DetailsList, Course_DetailsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ereportapp') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheCourse_DetailsList: Course_DetailsList,
					onTheCourse_DetailsObjectPage: Course_DetailsObjectPage
                }
            },
            opaJourney.run
        );
    }
);
What to remember - Naming conventions.
                   Clear commenting, as the code will get increasingly more complex - Captial letter start after a space, use proper punctutation.
                   Need to start testing at some point.

01/01/2025 - Need to make the countries selectable and each country individually recognisable.
             October 18th commit has code that makes the map clickable however at the time i was not able to incorperate it into the globe. I will try and reuse this code and implement it at this stage of the process.

             ERROR - After testing, countries are only selectable after a filter is selected.
             This is because country fills must be present for the function to work, i have set country-fills to be there always
             
             ERROR - If the globe is reset, the country-fills dissapears and we go back to the same issue as before.
             I need to create a function that will keep the coutnry-fills always present.
             Fixed by editing the reset function to reset the country fills instead of removing it.
             
02/01/2025 - Need to create tests to see how users normally navigate to plan their trips.
             I will start with myself, choose a desination that i know nothing about, and record all of the searches, websites and paths i take to gather the information that i want. 
             The same tests will be given the other potential users to see what their process is as well.
             Through the data i will analyse what the main steps are through all the users and focal points to encorperate within the program.

03/01/2025 - Plan for next steps after testing has been complete:
             Wish to create the selected country as centre of attention.
             Information about the destination around. 
             Options to plan itinarary or see blog.

            Used flyTo property to move the the coutnry selected however the coordinates of the mouse click are centred instead of being the whole country.

            Need to calculate the centre of each country or find another geoJson file online or to download.
            Will use turf js for spatial awareness of countries to find the centre point.

07/01/2025 - Turf has been used to calculate the centre of the countries. However, countries have small islands and territories
             that are part of the country. The makes the centre point of the countries visually of centre but mathematically correct.
             I will just use the mathematically correct points for now as they enlarge the selected countries well and certain parts that have been pressed.
             Need to add comments to understand everything as this is getting more and more complex as i am implementing more features.

08/01/2025 - If the country is selected the other countries turn dark grey to emphasise the selected country. 
             However if a country is selected and then zoomed out the dark grey filter disappears.
             But the filters before did not remain. This was fixed, so now the previous filters still remain. 
             But the selected country is not effected by the filters now, so i need to make sure that it is.
             
             Worst case scenario, hard code to get the ISO_A3 of the selected country, and map the colour data from only that country as a single as all of the rest of the countries are mapped.

09/01/2025 - Fixed the filters after country deseelction.
             
             Issue - During month selection the radio buttons are not reset to none meaning that they visually provide false information in correlation to the data that is being mapped.
             Fixed - Chnaged the function to reset the radio button to none when a new month is selected.

            Will add outline to countries when the users hovers over then as it is not clear with the mapped colours where the border is.
            I have to create a new layer on the map that will be called hover.
            A listener willl wait for the mouse to move over a country fills layer and retrive the ISO_A3 and then does the layer on the map.
            It maps the layer to the retrieved ISO_A3
             Need to decide what information will be displayed upon selection before the user is redirected to create itinararies.

10/01/2025 - Will attempt to add markers for recommended locations. If successful will progress to make the markers hierarchical based on
             the users level of zoom into the selected country.

11/01/2025 - Need to add markers all around and create a plan for transitioning to the itinarary builder.

13/01/2025 - Decided to implement further filters that have been inspired from the airbnb website. 
             Need to restructure json files with more information while taking into account further plans.
             
14/01/2025 - IDEA - MOVE THE FILTER AND SELECTION PAGES TO THE RIGHT IF THE USER IS LOADED FROM A EASTERN SOCIETY WHERE THEY READ FROM
                    RIGHT TO LEFT AND KEEP IT ON THE LEFT IF IT IS A SOCIETY WHERE THEY READ FROM LEFT TO RIGHT.

15/01/2025 - 

             
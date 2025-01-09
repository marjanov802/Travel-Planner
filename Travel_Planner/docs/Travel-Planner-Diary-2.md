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
             
             
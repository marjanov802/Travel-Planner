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
             
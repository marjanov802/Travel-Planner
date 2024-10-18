Globe in the middle of the page follows visual hierarchy concepts.
Larger central elements are the first thing that peopel notice in a layout.
https://www.absolute-design.co.uk/blogs/advice-hub/visual-hierarchy-guiding-viewer-s-attention-through-strategic-focal-points
https://blog.thenounproject.com/graphic-design-principles-hierarchy/

Studies in visual saliency indicate that central , bold or INTERACTIVE elements like a glibe command attention more effecitivly than peripheral content.
Users instinctively gravitate toward prominent focal points, especially those that engage them with motion or interacitity.
Abobe research in attraction:
https://research.adobe.com/news/look-here-researcher-predicts-what-attracts-attention-in-photos-and-designs/
By making the globe interactive , allowing users to rotate and zoom, you are further enchancing the engagement through exploration which has been shown to hold attention longer
https://www.absolute-design.co.uk/blogs/advice-hub/visual-hierarchy-guiding-viewer-s-attention-through-strategic-focal-points


NAVIGATION BAR:
OPTIONS ARE TO CREATE A NAVIGATION BAR WITH EVERYTHING OR A FILTERS BUTTON WITH THE FILTERS AND THE NAVIGATION BAR TO BE MORE IMPORTATNT INFORMATION.
will create two wireframes
Filter button seems better due to proressive disclouser- showing only essential items at first.
Hiding the filters behind reduces cognitive load- research shows that progressive disclousure improves usability by revealing information gradually, allowing users to focus on one task at a time:
https://www.interaction-design.org/literature/article/emphasis-setting-up-the-focal-point-of-your-design
https://www.absolute-design.co.uk/blogs/advice-hub/visual-hierarchy-guiding-viewer-s-attention-through-strategic-focal-points

Its also cleaner and less cluttered, if it wasnt it could make the page feel more complex, visual simplicity:
https://research.adobe.com/news/look-here-researcher-predicts-what-attracts-attention-in-photos-and-designs/

NAVIGATION BAR MAY WORK IF YOU HAVE A FEW FILTERS HWOEVER THIS IS MORE COMPLEX SO A MODAL IS MORE APPROPRITE.

The navigation will be at the top of the page currently- however if the top of the page feels to crwoded with the globe pushing it up the navigation will be moved to the left of the page.
We will have to decide on the navigation layout once we have seen how bug the globe is and in the wireframes


17/102024 - 
Using map box with svelte framework and vite build pack as they go hand in hand
First issue was resizing the mapbpx to the screen but that was solved via the x and y axis overflow , i set it to hidden
next i want to change the colour of each country based on the data that i give it , for example hotter countries would be a warmer colour
to do this i frist need a geojson of the countries boarderlines so that each country is defined. Next i would need to get the country by id as mapbpx uses iso-3166 which is a 3 letter identifyer for each cpuntry.
After that i would need to match the id to the country data which wopuld be provided in a dataset or list.
However a issue here is i dont want to hard code all the countries for each month or season as it is too teadious and doesnt make sense if we can get around it.
I am currently looking into using an api to request data such as temperature by month for countries and then using the apu data to colour coordinate the map.
API makes it complicated as no service has the specific data that i need and that can be accessed through a api.
Have moved onto using a json or csv file to store the data and then call it in the code

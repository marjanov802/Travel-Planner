# Diary
There are seperate diaries in each of the interfaces under the docs folder, i have included their content at the bottom of this diary.

30/09/2024 - Researching papers on HCI issues for project plan

5/10/2024 - Project plan has been completed

15/10/2024 - Have started a seperate diary within in project files, these diaries will contain research and information for developement and will also be the foundation of my report as i am recording all of the information step by step.

Wireframes for Travel Planner have been completed by hand, now i will digitalise them and make them more complex online 


20/10/2024 - Completed basic globe implementation through dataset importation.
Will focus on navigation and implemting functions within the navigation


23/10/2024 - Completed month selector with all fucntions working to loading different datasets based on the months.
Next step is to focus on the filters which will load other datasets , and how to implement them by passing the months through the function as well.

27/10/2024 - Attemping to gather all datapoints needed for all of the different filters however some do not exist causing the issue of missing datapoints which i must create based on real data gathered by nations or companies that measure geographical data.

10/11/2024 - Globe complete with seperate diary within the globe branch, now working on the recipe app

11/11/2024 - Research on app production started - what langauges or interfaces to use and how to do it

15/11/2024 - Creation of login page and further research on how to use the dart lanaguage

19/11/2024 - Further developement of login and sign up

24/11/2024 - Research on the colour palletes that should be used and how to present them as well as font sizes

26/11/2024 - Implement the set up page and strucutre of the rest of the app including the main page

28/11/2024 - Going back to find better colour palletes

30/11/2024 - Started gathering information for interim report

04/12/2024 - Started the interim report



Travel Planner Diary:
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
20/10/2024 - To create the nav bar i will use a UI library in conjunction with my code
Currently i am thinking of using tailwind due to its oop design meaning i could create a class and reuse it throughout the website by calling it
23/10/2024 - Nav bar scrapped for now , need to get functionality working
Best sites or applications focus on UI not UX so lets get the interaction good
Created some reusable functions and the month selector to switch files also works.
Now am going to create a drop down for things such as rain , temp and danger so different data is loaded in that reguard onto the map.
Data of how many tourists enter and exit countries every month does not exist online through my research so i will either have to create my own recommendation data by personal experience or create a algorithm that will use other factors to decide whether the country would be recommended to visit or not during that month.


Mobile Recipe App Diary:
5/11/2024 -
Creating the welcome page, should i use tap or swipe to start, i think tap considering its for elderly people who struggle with certain motions.
want to make the button attractive in some way for example i could make it pulsate, that invites the user to press the button.
The colour palette before the app has been configured would need to be something very clear and neutral for all users until they have set up to their prefrences, has to look profesional as well so we will stick to certain colour palettes throughout the app other than if they have selected something else.
6/11/2024 -
Much progress with the developement of the app however now the main.dart page has become to long and complex , especially when adding new features or fixing issues.
What i will do is break down the files, seperate files for seperate pages , for example the main page main contain the flow or how i will navigate around the site and basic structure but it may just consisst of calling seperate files from outside and around the other files.
for example , main.dart , would call setup.dart when the user reaches the setup page.
Also having second thoughts about the apps login page as elderly people may not want to go through the hassle
May include a skip button and let them enter as a guest , that way they will be able to enter with default settings and if they want to they can change them by accessing the settings.
Main menu-
Using large cards to hold different options, if font size to large user can scroll
Going to use icons which are recognisable to make navigation easier, and text as well
Explore Recipes -
Recipes are all on cards. Not sure on whether to include images yet as some images could be similar.
Ingredients page-
ISSUE - when font size is max the buttons go over the size of the screen
BACKGROUND INFORMATION -
ISSUE
cognitive load
Complex interfaces with too many features overwhelm users
https://ieeexplore.ieee.org/document/7002686
Unfamiliar gestures
Advanced gestures like pinch-to-zoom or multi-finger swipes are unintuitive for some elderly users
https://link.springer.com/article/10.1007/s10209-022-00933-4
TO FIX
Use large, easily tappable buttons and high-contrast, readable fonts.
Example: Samsung's "Easy Mode," which simplifies the interface.
https://www.samsung.com/uk/sustainability/accessibility/overview/
ISSUES
Inaccessible Text and Colors:
Small fonts and low-contrast text make reading difficult for users with low vision.
https://link.springer.com/article/10.1007/s10209-022-00933-4
Screen Reader Compatibility:
Many apps fail to label buttons and icons properly for screen readers.
Navigation Challenges:
Lack of audio cues or tactile feedback creates difficulties in identifying app elements.
https://www.android.com/accessibility/vision/
SOLUTION
High-Contrast Themes:
Offer dark mode and high-contrast options as standard features.
https://www.android.com/accessibility/vision/
Screen Reader Integration:
Ensure apps are fully compatible with VoiceOver (iOS) and TalkBack (Android).
https://www.android.com/accessibility/vision/
Customizable Settings:
Allow users to adjust font sizes, contrast levels, and button spacing.
https://www.samsung.com/au/support/mobile-devices/using-easy-mode/?srsltid=AfmBOoqgsXOOkUSjodEiEEuW7vSJOPFhJkYG0Y0vqiDIMD6kVxzQhSld
Haptic Feedback:
Add vibrations to confirm button presses or navigation actions.
https://support.google.com/accessibility/android/answer/9031274?hl=en-GB
Auditory Cues:
Use sounds to signal errors, successful actions, or guidance prompts.
https://www.android.com/accessibility/vision/









### CameraShy - The World is Your Playground
Turn the world into your playground with CameraShy. A free-for-all tag game where the objective is to find your friends throughout the designated area and snap their picture to eliminate them.

## Inspiration
Our team really considered the theme of **Connectivity**, and what it feels like to be connected. That got us to thinking about games we used to be able to play that involved contact such as Tag, Assassin, etc. We decided to see if we could create an **upgraded** spin on these games that would be timelessly fun, yet could also adhere to modern social-distancing guidelines.

## What it does
CameraShy is a free-for-all game, where the objective of the player is to travel within the designated geo-field, looking for other players, yet hiding from them as well. When they find a player, their goal is to snap a picture of them within the app, which acts as a "tagging" mechanism. The image is then compared against images of the players' faces, and if it is a match then the player who took the image gains a point, and the unsuspecting victim is eliminated from the competition. The last player standing, wins. Players themselves can create an arena and customize the location, size, game length, and player limit, sending a unique code to their friends to join.

## How we built it
CameraShy is separated into two main portions - the application itself, and the backend database.

###**Application**
We used both the Swift language, and SwiftUI language in building the application frontend. This includes all UI and UX. The application handles the creation of games, joining of games, taking of pictures, location handling, notification receiving, and any other data being sent to it or that needs to be sent to the backend. To authenticate users and ensure privacy, we utilized Apple's _Sign in With Apple_ , which anonymizes the users' information, only giving us an email, which may be masked by Apple based on the User's choice.

###**Server**
We used MongoDB for our backend. With it, we centralized our ongoing games, sent updates on player locations, arena location, arena boundary, time left, players list, and much more. When a user creates an account, their image is stored on the database with a unique identifier. During a game, when an image of a player is uploaded it is quickly put through Azure's Facial Recognition API, using the previously uploaded player images as reference to identify who was in the shot, if anyone was. We are proud to say that this also works with mask wearers. Finally, the server sends notifications to devices based on if they won/lost/left the arena and forfeited the game.

## Challenges we ran into
Taking on a decently sized project like this, we were bound to run into challenges (especially with 3/4 of us being first-time Hackers!). Here are a few of the challenges we ran into:

###1. HTTPS Confirmation
We had issues with our database which set us a few hours back, but we found a way around it all pitched in (frontend devs as well) to figure out a solution as to why our database would not register with an HTTPS certificate.

###2. Different Swift Languages
While both Swift and SwiftUI are unique languages written by Apple, for Apple devices, they are very different in nature. Swift relies on Storyboarding and is mostly imperative, whereas SwiftUI utilizes a different approach, and is declarative. With one front-end developer utilizing Swift, and the other SwiftUI, it was difficult to merge Views and connect features properly, but together we learnt a bit of the others' language in the process.

###3. Facial Recognition with Masks
As anyone with a device that utilizes Facial Identification might know, Facial Recognition with a mask on can be difficult. We underwent numerous tests to figure out if it was even possible to utilize facial recognition with a mask, and figured out workarounds in order to do so properly.

## Accomplishments that we're proud of
One accomplishments we're proud of is being able to utilize multiple endpoints and APIs together seamlessly. At the beginning we were wary of dealing with so much data (geographical location, player counts, time, notification IDs, apple unique identifiers, images, facial recognition, and more!), but looking back from where we are now, we are glad we took the risk, as our product is so much better as as a result.
Another noteworthy accomplishment is our fluid transitions between SwiftUI and Swift. As previously mentioned, this was not a simple task, and we're very happy with how the product turned out.

## What we learned
As we overcame our challenges and embarked on our first Hackathon, the most important thing we learnt was that working as a team on a project does not necessarily mean each person has their own role. In many cases, we had to work together to help each other out, thinking of ideas for areas that were not our expertise. As a result, we were able to learn new tools and ways of doing things, as well as dabble in different coding languages.

## What's next for CameraShy - The World is Your Playground
Our next steps for CameraShy is to embrace user and game customizability. We would like to create a user-oriented settings view that allows them to clear their data off our servers themselves, reset their accounts, and more.
In terms of game customizability, what we have now is just the beginning. We have a long list of potential features including geographic neutral zones and bigger game arenas. Most importantly for us, however, is to continue fine-tuning what we've built so far before we go ahead and implement something new.

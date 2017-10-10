# Tutorial

These files are from the tutorial system I built for the game. We needed it to be flexible and easily altered, but also to be able to trigger anything that can happen in the game.

The tutorial is made up of TutorialStepData (in TutorialStepData.hx), with each such instance representing a single step along the tutorial. TutorialStepData instances have optional start and end functions (triggered upon entry/exit of that state), and optional start/end text (displayed in a popup), but they all have criteria that determine when the player has successfully completed that part of the tutorial.

Criteria are defined via TutorialStepCriteria instances (also in TutorialStepData.hx). Each such instace is defined by three things:
- a type of criteria, drawn from a long list of constants representing the various aspects of the game (like CRIT_SPECIFIC_CARD_READY)
- an argument (such as the ID of the card)
- a relationship that can exist between the two (less than, greater than, exactly equal, etc)

Each step in the tutorial generally required custom code, which meant writing a lot of one-off functions. These were implemented in a few different files representing different iterations (the most recent being TutorialV3.hx). It all came together in TutorialManager with calls such as:

`addTutorialStep(0, [[TutorialManager.CRIT_READY_LOCATION]], TutorialV3.showCardCosts_s0);`

...which would add a step to the first stage of the tutorial (stage 0), that would persist until there was a location card ready to play (TutorialManager.CRIT_READY_LOCATION), and that would point out some information to the player upon entry (code implemented in TutorialV3.showCardCosts_s0).

The tutorial alternated between completely open-ended sections and parts that were on-rails. As such, we needed to limit certain capabilities in the game until the player had passed a given point in the tutorial, so they wouldn't be able to use mechanics that hadn't been explained yet. To do that, I implemented a checkCapability function in TutorialManager. That would allow us to check whether or not a given feature was enabled yet via code like the following:

`GameRegistry.tutorial.checkCapability(TutorialManager.CAP_ADD_CINEBOXES)`

Tutorial systems are always a bit hard- make them too loose, and the lack of structure makes things hard to maintain, too stuctured and it becomes hard to trigger the appropriate actions (many of which require breaking the game's normal functionality temporarily). All in all, I was pretty happy with the specific blend in this implementation- loose in the custom functions per step, structured in the overall flow of TutorialStepCriteria and tutorial stages.
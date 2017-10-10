package com.jamwix.hs.tutorial;

import com.jamwix.hs.tutorial.TutorialStepData;
import com.jamwix.hs.tutorial.TutorialStepData.TutorialStepCriteria;

import com.jamwix.hs.ui.popups.PopupDoc;
import com.jamwix.hs.tutorial.TutorialSteps;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.ui.popups.PopupLevelHint;
import com.jamwix.hs.levels.Level;

import com.jamwix.utils.IntPoint;


class TutorialManager
{
	// this is the number of pixels to move the pointer in a single second
	// 150: bugged as too slow
	static public var POINTER_PIXELS_PER_SECOND:Int = 220;

	static public var SHOW_DAILY_CHALLENGE_LEVEL:Int = 15;

	// cards that start in the hand
	static public var FIRST_LEVEL_START_PLOT:Int = 51;
	static public var FIRST_LEVEL_START_ACTOR:Int = 130;
	static public var FIRST_LEVEL_START_LOC:Int = 26;

	// added to the hand midway through the level
	static public var FIRST_LEVEL_ADD_CARDS:Array<Int> = [186, 221, 280, 245];

	// 208: Slim Carrey
	// 223: Terrorist Madman
	// 9: A Doomed 747
	static public var REPLACE_START_CARDS:Array<Int> = [208, 223, 9];
	static public var REPLACE_DRAW_ACTOR:Int = 341; // 208;
	static public var REPLACE_DRAW_CHARACTER:Int = 111; // grizzled cop

	static public var EXAMPLE_CARD_UPGRADE_CARD_ID:Int = 113;	// Wacky Chang

	static public var DRAW_SPECIAL:Int = 263;

	// the max level for which everything is controlled
	// used to prevent the sled from moving to map level markers it shouldn't
	// if the player quits the tutorial at odd times
	static public var TUTORIAL_MAX_LEVEL:Int = 1;

	static public var FIRST_POWERUP_ID:Int = 2;

	static public var FIRST_LEVEL_TURNS:Int = 15;

	static public var HINT_WAIT_TIME:Float = 2;

	static public var CORE_TUTORIAL_END_STAGE:Int = 4;

	// lots and lots of different criteria values
	static public var CRIT_ADD:Int = 0;
	static public var CRIT_SUB:Int = 1;
	static public var CRIT_REPLACE:Int = 2;

	static public var CRIT_MATCH_GEM:Int = 100;
	static public var CRIT_MATCH_GEM0:Int = CRIT_MATCH_GEM + 1;
	static public var CRIT_MATCH_GEM1:Int = CRIT_MATCH_GEM + 2;
	static public var CRIT_MATCH_GEM2:Int = CRIT_MATCH_GEM + 3;
	static public var CRIT_MATCH_GEM3:Int = CRIT_MATCH_GEM + 4;
	static public var CRIT_MATCH_GEM4:Int = CRIT_MATCH_GEM + 5;
	static public var CRIT_MATCH_GEM5:Int = CRIT_MATCH_GEM + 6;

	static public var CRIT_ADD_ITEM:Int 		= 120;
	static public var CRIT_ADD_ACTOR:Int 		= CRIT_ADD_ITEM + CardData.TYPE_ACTOR + 1;
	static public var CRIT_ADD_CHARACTER:Int 	= CRIT_ADD_ITEM + CardData.TYPE_CHARACTER + 1;
	static public var CRIT_ADD_LOCATION:Int 	= CRIT_ADD_ITEM + CardData.TYPE_LOCATION + 1;
	static public var CRIT_ADD_PLOT:Int 		= CRIT_ADD_ITEM + CardData.TYPE_PLOT + 1;
	static public var CRIT_ADD_SPECIAL:Int 		= CRIT_ADD_ITEM + CardData.TYPE_SPECIAL + 1;

	static public var CRIT_CARD_READY:Int 		= 140;
	static public var CRIT_READY_ACTOR:Int 		= CRIT_CARD_READY + CardData.TYPE_ACTOR + 1;
	static public var CRIT_READY_PLOT:Int 		= CRIT_CARD_READY + CardData.TYPE_PLOT + 1;
	static public var CRIT_READY_CHARACTER:Int 	= CRIT_CARD_READY + CardData.TYPE_CHARACTER + 1;
	static public var CRIT_READY_LOCATION:Int 	= CRIT_CARD_READY + CardData.TYPE_LOCATION + 1;
	static public var CRIT_READY_SPECIAL:Int 	= CRIT_CARD_READY + CardData.TYPE_SPECIAL + 1;

	static public var CRIT_SPECIFIC_CARD_READY	= 300;	// used to check for a specific card's readiness (add the card ID before setting or checking)

	static public var CRIT_HASMATCH_CINEBOX:Int = 160;

	static public var CRIT_CLOSE_DOC:Int 			= 0;
	static public var CRIT_DRAW_CARD:Int 			= 1;
	static public var CRIT_COMBINE_PEOPLE:Int 		= 4;
	static public var CRIT_STATE:Int 				= 5;
	static public var CRIT_START_GAME:Int 			= 6;
	static public var CRIT_CARDS_PLAYABLE:Int 		= 7;
	static public var CRIT_STAR_SELECT_VIS:Int 		= 8;
	static public var CRIT_CARD_INFO_UP:Int 		= 9;
	static public var CRIT_CARDS_ADDED_TOTAL:Int 	= 10;
	static public var CRIT_TURNS_REMAINING:Int 		= 11;
	static public var CRIT_RELEASING:Int 			= 12;
	static public var CRIT_STORE_OPEN:Int 			= 13;
	static public var CRIT_ANY_CLICK:Int 			= 14;
	static public var CRIT_PAUSE_MILLIS:Int  		= 15;
	static public var CRIT_CLICKED_PLAY:Int 		= 16;
	static public var CRIT_CLICKED_LEVEL:Int  		= 17;
	static public var CRIT_SHOW_VERDICT:Int 		= 18;
	static public var CRIT_SLED_ARRIVED:Int 		= 19;
	static public var CRIT_CURRENT_LEVEL:Int 		= 20;
	static public var CRIT_COMBO_FOUR:Int 			= 21;
	static public var CRIT_FX_EQUIP_SHOW:Int 		= 22; 	// if the equip FX UI is visible
	static public var CRIT_EQUIPPED_FX:Int 			= 34; 	// set when the player equips an FX item
	static public var CRIT_FX_USED:Int 				= 35; 	// set when the player uses an FX power
	static public var CRIT_USED_MAGNET:Int 			= 36;	// player has chosen the type of gem to grab
	static public var CRIT_PACK_PROMPT_SHOWN:Int 	= 37; 	// true when the player is shown the pack prompt
	static public var CRIT_PACK_BOUGHT:Int 			= 38; 	// player has bought a pack
	static public var CRIT_OPEN_PACK_START:Int 		= 39; 	// player has swiped to open the pack
	static public var CRIT_OPEN_PACK_END:Int 		= 40;	// the pack open animation has finished
	static public var CRIT_LEVEL_TYPE:Int 			= 41; 	// used to trigger stages on first encounter of a level type
	static public var CRIT_TRIGGER_ANTIPOISON:Int 	= 42;	// when the player taps a "TAP!" antipoison gem
	static public var CRIT_GEMDROP_COMPLETE:Int 	= 43; 	// used to delay prompt until gems have fallen
	static public var CRIT_CARD_UPGRADE:Int 		= 44; 	// set when the upgrade confirm UI has been displayed
	static public var CRIT_UPGRADE_CONFIRM:Int 		= 45; 	// set when the player has confirmed the upgrade
	static public var CRIT_CLOSED_INFO:Int 			= 46; 	// set when the card info is closed
	static public var CRIT_WON_LEVEL:Int 			= 47; 	// set when user won the level

	static public var CRIT_FORCE_STOP:Int 			= 1000;	// used when working on the tutorial to ensure that a stage cannot be completed

	// IDs for various capabilities, used to prevent the player from having access to 
	// aspects of the game that they shouldn't (yet)
	static public var CAP_DISCARD_CARDS:Int  		= 0;	// if the player is allowed to discard cards
	static public var CAP_SHOW_FX_MENU:Int 			= 1;	// if the FX menu is displayed / active
	static public var CAP_COUNTDOWN_TURNS:Int 		= 2;	// whether or not the level is timed
	static public var CAP_SAVE_RESULTS:Int  		= 3;
	static public var CAP_DRAW_SPECIALS:Int 		= 4;	// used to prevent special cards from being drawn
	static public var CAP_START_LEVEL:Int  			= 5;
	static public var CAP_FORCE_THEATER_50:Int 		= 6;	// DEPRECATED: would force audience in theater state
	static public var CAP_FORCE_THEATER_80:Int 		= 7;	// DEPRECATED: would force audience in theater state
	static public var CAP_SHOW_VERDICT:Int 			= 8;
	static public var CAP_OPEN_STORE:Int 			= 9;
	static public var CAP_RETURN_TO_MAP:Int  		= 10;
	static public var CAP_FX_ENABLED:Int 			= 11;
	static public var CAP_OPEN_FX:Int 				= 12;
	static public var CAP_SET_BUDGET:Int 			= 13;
	static public var CAP_MAP_STAGES:Int 			= 14;
	static public var CAP_MOVE_MAP:Int 				= 15;
	static public var CAP_STARTLEVEL_DISMISS:Int 	= 16;
	static public var CAP_CLICK_PLAY:Int 			= 17;
	static public var CAP_VIEW_STAGES:Int  			= 18;	// if the player can go to the map stage select screen
	static public var CAP_CAN_REPLAY:Int 			= 19;
	static public var CAP_SHARE_POSTER:Int 			= 20;
	static public var CAP_SHOW_DAILYREWARD:Int 		= 21;
	static public var CAP_DIRECTORS_MENU:Int 		= 22;	// DEPRECATED: if the player could click on the directors button
	static public var CAP_SHOW_TIPS:Int 			= 23;	// whether or not to show the player tips
	static public var CAP_CLOSE_LEVELSTART:Int 		= 24;
	static public var CAP_SHOW_OFFERS:Int 			= 25;
	static public var CAP_CHARGE_FOR_LEVEL:Int 		= 26;
	static public var CAP_SHOW_RATEGAME:Int 		= 27;
	static public var CAP_CACHE_DOC:Int 			= 28;
	static public var CAP_CACHE_STAGE0:Int 			= 29;
	static public var CAP_CACHE_STAGE1:Int 			= 30;
	static public var CAP_CACHE_STAGE2:Int 			= 31;
	static public var CAP_ADD_CINEBOXES:Int 		= 32;	// whether or not green boxes show in the match game
	static public var CAP_CARD_COMBOS:Int 			= 33; 	// whether or not to allow card choice combos
	static public var CAP_VIEW_MENU:Int 			= 34; 	// if the player can go to the menu
	static public var CAP_VIEW_CARDS:Int   			= 35; 	// if the player can view the card management screen
	static public var CAP_CHARGE_FOR_FX:Int 		= 36; 	// used to make FX usages beyond 1 free for the first stage
	static public var CAP_FULL_PRICE_CARDS:Int 		= 37; 	// used to limit costs to 6 gems during the tutorial
	static public var CAP_EARLY_RELEASE:Int 		= 38; 	// whether or not to show the early release button
	static public var CAP_SHOW_ALL_FX_SLOTS:Int 	= 39; 	// if false, hide slots 2 and 3 in the FX equip screen
	static public var CAP_FORCE_WIN:Int 			= 40; 	// if true, ensure that the player makes at least one star
	static public var CAP_CAN_BUY_FX:Int 			= 41; 	// used to prevent players from buying FX powers with soft currency during the tutorial
	static public var CAP_CLOSE_FX_EQUIP:Int 		= 42; 	// prevent the player from closing out the FX equip popup without actually equipping one
	static public var CAP_SHOW_PASSIVE_HINTS:Int 	= 43; 	// whether or not to show passive Doc popup-based hints
	static public var CAP_CANCEL_UPGRADE:Int 		= 44; 	// prevent the player from canceling during the card upgrade portion of the tutorial
	static public var CAP_FORCE_UPGRADE_SUCCESS:Int = 45; 	// force the first upgrade to work, even if they don't have enough money
	static public var CAP_CHANGE_CARD_TABS:Int 		= 46; 	// keep the player from changing tabs on the card management screen and breaking the upgrade tutorial
	static public var CAP_GOTO_MAP:Int 				= 47; 	// prevent the player from going back to the map during card upgrading
	static public var CAP_VIEW_CARD_INFO:Int 		= 48; 	// prevent the player from viewing card info during upgrading
	static public var CAP_CAN_VIEW_ADS:Int 			= 49; 	// whether or not to show passive Doc popup-based hints
	static public var CAP_CANCEL_PACKBUY:Int 		= 50; 	// prevent player from canceling out of buying a pack
	static public var CAP_PLAY_INTRO:Int 			= 51; 	// whether we should play the intro movie
	static public var CAP_ARCADE_BOMB:Int 			= 52; 	// allows bomb levels to spawn in arcade
	static public var CAP_ARCADE_POISON:Int 		= 53; 	// allows poison levels to spawn in arcade
	static public var CAP_COLLECTION_REWARD:Int		= 54; 	// disable the popup for cinebit collection rewards
	static public var CAP_TRIGGER_POISON:Int 		= 55;	// prevent poison gems during the first part of stage 9
	static public var CAP_CHARGE_FOR_PACKS:Int 		= 56; 	// prevent "buy stars" popup during the tutorial
	static public var CAP_SHOW_STARMACHINE:Int 		= 57;	// whether or not to show the star machine
	static public var CAP_SHOW_DAILY_CHALLENGE:Int 		= 58;	// whether or not to show the daily challenge notification

	static public var LEVEL_TO_STAGE:Array<Int> = [0, 1, 2, 3, 4, 7, 7, 8];

	private var _criteriaValues:Map<Int, Int>;
	private var _stepData:Map<Int, TutorialStepData>;

	private var _tutorialData:Array<Array<TutorialStepData>>;
	private var _stageStartFuncs:Array<Void->Void>;

	private var _currentStep:TutorialStepData;

	private var _currentStageNum:Int;
	private var _currentStepNum:Int;
	private var _tutorialComplete:Bool;

	private var _pauseCriteria:Bool;

	private var _hintTimer:Float;

	public function new()
	{
		LEVEL_TO_STAGE.push(GameRegistry.levels.firstBomb());
		LEVEL_TO_STAGE.push(GameRegistry.levels.firstPoison());

		POINTER_PIXELS_PER_SECOND = Globals.UIInt(220);

		_criteriaValues = new Map<Int, Int>();
		_stepData = new Map<Int, TutorialStepData>();

		_currentStep = null;

		_tutorialData = new Array<Array<TutorialStepData>>();
		_pauseCriteria = true;

		_stageStartFuncs = new Array<Void->Void>();

		setupStages();

		_tutorialComplete = false;
		_currentStageNum = GameRegistry.stats.getTutorialStage();
		if (_currentStageNum < 0) _currentStageNum = 0;
		_currentStepNum = 0;

		_hintTimer = 0;

		if (_currentStageNum >= _tutorialData.length)
		{
			_tutorialComplete = true;
			_currentStep = null;
			return;
		}

		if (Globals.TUTORIAL_DISABLED)
		{
			_tutorialComplete = true;
		}

		if (!_tutorialComplete)
		{
			_currentStep = _tutorialData[_currentStageNum][_currentStepNum];
		}
	}

	private function setupStages():Void
	{
		// it pains me to have the following, since it really looks like something that
		// should be a loop, but each of the setup functions does very different things
		setupStage0();
		setupStage1();
		setupStage2();
		setupStage3();
		setupStage4();
		setupStage5();
		setupStage6();
		setupStage7();
		setupStage8();
		setupStage9();
	}

	public function setTutorialComplete()
	{
		_tutorialComplete = true;
		_currentStageNum = _tutorialData.length;
		_currentStep = null;
		GameRegistry.stats.setTutorial(_currentStageNum);
	}

	public function setStageComplete()
	{
		debugSetStage(_currentStageNum + 1);
	}

	public function setStageToMaxLevel():Void
	{
		var maxLevel:Int = GameRegistry.stats.getMaxLevel();

		for (stageNum in 0...LEVEL_TO_STAGE.length)
		{
			var stageLevel:Int = LEVEL_TO_STAGE[stageNum];
			if (stageLevel >= maxLevel)
			{
				debugSetStage(stageNum);
				return;
			}
		}

		setTutorialComplete();
	}

	// It's in these functions that the tutorial is laid out.
	// Each stage has a number of steps, and each step has some arbitrary setup code (or not),
	// some text that is displayed at the start (or not), and
	// one or more criteria that, once met, will cause the tutorial to advance to the next step
	private function setupStage0():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart0);

		// STEP 0
		// go straight into the playgame state
		// SETUP: plot, actor, and location in the hand, inactive
		// CRIT: playgame state loaded
		// addTutorialStep(0,
		// 		[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL]]);
		// 0
		addTutorialStep(0,
				[[TutorialManager.CRIT_START_GAME]]);

		// 1
		addTutorialStep(0,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL]]);

		// 2
		addTutorialStep(0,
				[[TutorialManager.CRIT_CLICKED_LEVEL]],
				TutorialV3.showStartLevel_s0);

		// 3
		addTutorialStep(0,
				[[TutorialManager.CRIT_CLICKED_PLAY]],
				TutorialV3.highlightPlayButton_s1);

		// 4
		addTutorialStep(0,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL]]);

		// Doc: “It’s time to create a movie! Let’s start by TAPPING this PLOT [ICON] Cinebit here.
		// These Cinebits give your movies a story!”
		// CRIT: show card info
		// 5
		addTutorialStep(0,
				[[TutorialManager.CRIT_CARD_INFO_UP]],
				TutorialV3.showFirstCard_s0);

		// 6
		addTutorialStep(0,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				null,
				'These Cinebits give your movies a story!');


		// Doc: “Match enough ORANGE gems to use this PLOT [ICON] Cinebit and add it to your film strip!
		// SETUP: set playfield with orange gems, no cineboxes
		// CRIT: plot card ready
		// 7
		addTutorialStep(0,
				[[TutorialManager.CRIT_READY_PLOT]],
				TutorialV3.promptMatchForPlot);


		// Doc: You’ve got enough gems to spend on your PLOT now! Drag it onto your film strip!
		// SETUP: flash filmstrip slot
		// CRIT: plot card added
		// 8
		addTutorialStep(0,
				[[TutorialManager.CRIT_ADD_PLOT]],
				TutorialV3.showAddPlot_s0);

		// Doc: Now check out this [RED STAR ICON] ACTOR Cinebit here.
		// SETUP: point at actor card
		// CRTI: show info
		// 9
		addTutorialStep(0,
				[[TutorialManager.CRIT_CARD_INFO_UP]],
				TutorialV3.showActorCard_s0);


		// Doc: Match enough RED gems to use this Cinebit and add it to your film strip!
		// SETUP:
		// CRIT: actor card ready
		// 10
		addTutorialStep(0,
				[[TutorialManager.CRIT_READY_ACTOR]],
				TutorialV3.matchForActor);

		// Doc: “You’ve got enough gems to spend on ACTOR now! Drag it onto your film strip!”
		// [Once there’s enough gems FLASH FILM STRIP.] (flash film slot)
		// CRIT: actor added
		// 11
		addTutorialStep(0,
				[[TutorialManager.CRIT_ADD_ACTOR]],
				TutorialV3.showAddActor_s0);

		// Doc: “Now let’s add this location! Get enough [BLUE HOUSE ICON] BLUE gems to add it!”
		// 12
		addTutorialStep(0,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showLocation_s0,
				'Now let’s add this location!');

		// Doc: “The gems you need to add a Cinebit are always shown right there.” (hand points to bar)
		// 13
		addTutorialStep(0,
				[[TutorialManager.CRIT_READY_LOCATION]],
				TutorialV3.showCardCosts_s0);

		// 14
		addTutorialStep(0,
				[[TutorialManager.CRIT_ADD_LOCATION]],
				TutorialV3.promptAddLocation);

		// [on adding another Cinebit to the film strip] Doc: “You’re getting the hang of it now!”
 		// 15
 		addTutorialStep(0,
				[[TutorialManager.CRIT_CLOSE_DOC]],
 				TutorialV3.addTurns10_s0,
 				'I\'m going to put 15 turns on the clock, let\'s see how many Cinebits you can add to your movie!');

		addTutorialStep(0,
				[[TutorialManager.CRIT_WON_LEVEL, 0, TutorialStepCriteria.REL_EQUAL]]);

	}

	private function setupStage1():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart1);

		addTutorialStep(1,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL]]);

		addTutorialStep(1,
				[[TutorialManager.CRIT_CLICKED_LEVEL]],
				TutorialV3.showStartLevel_s1);

		addTutorialStep(1,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_CURRENT_LEVEL, 1, TutorialStepCriteria.REL_EQUAL]]);

		// Doc: “Match gems and create the best movie you can before you run out of turns”
		addTutorialStep(1,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.allowReleaseOnNoCards,
				'Match gems and create the best movie you can before you run out of turns');

		// “See what kind of amazing movie you can build with these Cinebits in [X] turns… GO!”
		addTutorialStep(1,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showRemainingTurns_s1);

		addTutorialStep(1,
				[[TutorialManager.CRIT_WON_LEVEL, 1, TutorialStepCriteria.REL_EQUAL]]);

	}

	private function setupStage2():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart2);

		addTutorialStep(2,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL]]);

		// 0
		addTutorialStep(2,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_CURRENT_LEVEL, 2, TutorialStepCriteria.REL_EQUAL]]);


		// Starting conditions: New board,15 turns, and a single actor LOCKED onto filmstrip
		// [HIGHLIGHT ACTOR LOCKED ONTO FILM STRIP]

		// Doc: “This actor [ACTOR NAME] is locked in your film under studio contract! That means you can’t replace em. You’ve got to come up with a hit movie starring HIM/HER!”
		// 1
		addTutorialStep(2,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showLockedActor);

		/*
		// 2
		addTutorialStep(2,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showLockedActor2);

		// [after GENRE appears] Doc: “If you don’t like your movie genre, just try new Cinebits and watch how it changes.”
		// 3

		// Doc: “Add too many thumbs down [THUMB DOWN ICON] in a genre, and your movie may become something different.”
	 	// 4
		addTutorialStep(2,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.explainThumbs);

		// 5
		addTutorialStep(2,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.explainThumbs2);
		*/


		// [SETUP A MATCH 4]
		// Doc: “Try matching 4 gems and see what happens!”
		// Doc: “Match combos create powerful special gems. Try matching different gems to discover all the secret magic effects!”
		// 6
		addTutorialStep(2,
				[[TutorialManager.CRIT_COMBO_FOUR]],
				TutorialV3.setupMatchFour);

		// 7
		addTutorialStep(2,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.clearMatchFour,
				'Match combos create powerful special gems. Try matching different gems to discover all the secret magic effects!');

		addTutorialStep(2,
				[[TutorialManager.CRIT_WON_LEVEL, 2, TutorialStepCriteria.REL_EQUAL]]);

	}

	private function setupStage3():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart3);

		// 0
		addTutorialStep(3,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_CURRENT_LEVEL, 3, TutorialStepCriteria.REL_EQUAL]]);

		// Doc: “This movie’s in trouble and needs help. Let’s tap this actor and see what’s wrong.”
		// SETUP: point at actor
		// CRIT: show info
		// 1
		addTutorialStep(3,
				[[TutorialManager.CRIT_CARD_INFO_UP]],
				TutorialV3.startSecondLevel_s1);

		// Doc: “Here’s the problem, you’ve got an action packed PLOT [ICON], and LOCATION [ICON] but this actor’s not good at action. He’s not helping your movie at all!”
		// 2
		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showGenreMismatch_s1);

		// Doc: “To make a great action movie, you need more action cinebits! Let’s see if we can find a better actor for this role.”
		// 3
		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialSteps.hideCardInfo,
				'To make a great action movie, you need more action cinebits! Let’s see if we can find a better actor for this role.');

		// Doc: “Look at that! A Cinebit Mystery Box! Open it and you’ll get a Cinebit from your collection.”
		// 4
		addTutorialStep(3,
				[[TutorialManager.CRIT_DRAW_CARD]],
				TutorialV3.setupActorDraw_s1);

		// Doc: “Look for the GREEN MYSTERY BOXES to drop new Cinebits into your hand. Match them now!”
		// 5
		/*
		addTutorialStep(3,
				[[TutorialManager.CRIT_DRAW_CARD]],
				TutorialV3.showActorDraw_s1,
				'Look for the GREEN MYSTERY BOXES to drop new Cinebits into your hand. Match them now!');
		*/

		// Doc: “Here we go, actor Chris Hamswart is much better fit with this plot and location. He’ll help you make an awesome action movie!”
		// 5
		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.setupActorMatch_s1);

		addTutorialStep(3,
				[[TutorialManager.CRIT_READY_ACTOR]],
				TutorialV3.promptActorMatch);

		// 6
		addTutorialStep(3,
				[[TutorialManager.CRIT_ADD_ACTOR]],
				TutorialV3.showSwapActors_s1);

		// 7
		addTutorialStep(3,
				[[TutorialManager.CRIT_HASMATCH_CINEBOX, 1, TutorialStepCriteria.REL_EQUAL]],
				TutorialV3.waitForCinebox);
		// 8
		addTutorialStep(3,
				[[TutorialManager.CRIT_DRAW_CARD]],
				TutorialV3.setupCharacterDraw);

		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.promptCharacterMatch);

		// 8
		addTutorialStep(3,
				[[TutorialManager.CRIT_SPECIFIC_CARD_READY + TutorialManager.REPLACE_DRAW_CHARACTER]],
				TutorialV3.setupCharacterMatch_s1);


		// Doc: “Now let’s beef up this actor’s role. Add the grizzled cop CHARACTER [SHOW PURPLE ICON] to Chris Hamswart and see what happens!”
		// 9
		addTutorialStep(3,
				[[TutorialManager.CRIT_ADD_CHARACTER]],
				TutorialV3.promptAddCharacter_s1);

		// Doc: “Now I’ll put 10 turns on the clock, and let’s try and make this movie amazing!”
		// 10
		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.addTurns10_s1,
				'Now I’ll put 15 turns on the clock. Add as many CineBits as you can!');

		addTutorialStep(3,
				[[TutorialManager.CRIT_WON_LEVEL, 3, TutorialStepCriteria.REL_EQUAL]]);

		// Doc: “Great job! Keep experimenting and you’ll discover the secrets of Cinemagic!”
		// 11
		/*
		addTutorialStep(3,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				null,
				'Great job! Keep experimenting and you’ll discover the secrets of Cinemagic!');
		*/

		/*
		addTutorialStep(3,
				[[TutorialManager.CRIT_FORCE_STOP]],
				null,
				'STOPPED, STAGE 3');
		*/
	}

	private function setupStage4():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart4);

		addTutorialStep(4,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_CURRENT_LEVEL, 4, TutorialStepCriteria.REL_EQUAL]]);

		addTutorialStep(4,
				[[TutorialManager.CRIT_GEMDROP_COMPLETE]],
				TutorialV3.setupCineboxCombo);

		// [SETUP MATCH 4 GREEN] - force the 3 choices?
		// Doc: “I wonder what happens if you match 4 mystery boxes!?”
		addTutorialStep(4,
				[[TutorialManager.CRIT_COMBO_FOUR]],
				TutorialV3.showCineboxCombo);

		// Doc: “Astounding! GREEN MYSTERY BOX [show icon] COMBOS gives you a choice in what Cinebit you get.”
		addTutorialStep(4,
				[[TutorialManager.CRIT_DRAW_CARD]],
				TutorialV3.promptCardChoice);

		// Doc: “Movies are made from 2 plots, 2 character, and 2 actors, and just 1 location. You can have fewer, but you’ll make less at the box office.”
		addTutorialStep(4,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				null,
				'Movies are made of 2 plots, 2 character, 2 actors, and just 1 location. You can have fewer, but you’ll make less at the box office.');

		addTutorialStep(4,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.add10Turns,
				'See how many you can add in 15 turns!');

		addTutorialStep(4,
				[[TutorialManager.CRIT_WON_LEVEL, 4, TutorialStepCriteria.REL_EQUAL]]);

	}

	// explain FX system
	private function setupStage5():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart5);

		addTutorialStep(5,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_CLICKED_LEVEL, 7, TutorialStepCriteria.REL_EQUAL]]);

		// Start of level screen, Doc tells Amelia to equip magnet on start screen.
		// Doc: “I’ve made you something special from my laboratory at Industrial Science and Magic! Equip the magnet now and let’s go!”
		addTutorialStep(5,
				[[TutorialManager.CRIT_FX_EQUIP_SHOW]],
				TutorialV3.showEquipFX);

		addTutorialStep(5,
				[[TutorialManager.CRIT_EQUIPPED_FX]],
				TutorialV3.showEquipMagnet);

		addTutorialStep(5,
				[[TutorialManager.CRIT_CLICKED_PLAY]],
				TutorialV3.showStartLevelFX);

		addTutorialStep(5,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL]]);

		addTutorialStep(5,
				[[TutorialManager.CRIT_GEMDROP_COMPLETE]]);

		// Starting conditions: New board,15 turns, and a standard level. REVEAL FX SYSTEM AT TOP.
		// Doc: “Time to use your new special FX power. Get ready for magic! Tap the magnet now!”
		addTutorialStep(5,
				[[TutorialManager.CRIT_FX_USED]],
				TutorialV3.promptUseMagnet);

		addTutorialStep(5,
				[[TutorialManager.CRIT_USED_MAGNET]],
				TutorialV3.promptUseMagnet2);

		// Doc: “Fantastic! You’ll get 1 free magic use every level to start with. Unlock more Cinebits and your special FX powers will increase higher and higher!
		addTutorialStep(5,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.allowAllFXEquip,
				'Fantastic! You’ll start with 1 free magic use every stage. Unlock more Cinebits and your special FX powers will increase higher and higher!');

		addTutorialStep(5,
				[[TutorialManager.CRIT_WON_LEVEL, 7, TutorialStepCriteria.REL_EQUAL]]);

	}

	// force a pack buy, and explain card upgrading
	private function setupStage6():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart6);

		// 0
		addTutorialStep(6,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL]]);

		// 1
		addTutorialStep(6,
				[[TutorialManager.CRIT_PACK_BOUGHT]],
				TutorialV3.showBuyPack);

		// 2
		// 				[[TutorialManager.CRIT_OPEN_PACK_START]],
		// 				[[TutorialManager.CRIT_STATE, Globals.STATE_STORE, TutorialStepCriteria.REL_EQUAL]],

		addTutorialStep(6,
				[[TutorialManager.CRIT_OPEN_PACK_END]],
				TutorialV3.promptOpenPack);

		// 3
		/*
		addTutorialStep(6,
				[[TutorialManager.CRIT_OPEN_PACK_END]]);
		*/

		// 4 Doc: “Tap that button and let’s check out your Cinebit Collection!”
		addTutorialStep(6,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MANAGE_CARDS, TutorialStepCriteria.REL_EQUAL]],
				TutorialV3.showViewCinebits);

		// [GO TO MANAGEMENT SCREEN]
		// Doc : “Every Cinebit you get becomes a part of your movie making powers! Collect them all and gain incredible new powers!”
		// 5
		addTutorialStep(6,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.forceShowUpgradeCard,
				'Every Cinebit you get becomes a part of your movie making powers! Collect them all and gain incredible new powers!');

		// force card upgrading

		// Doc: “Let’s upgrade a cinebit now! Tap there to upgrade!” [point at upgrade button] [force upgrade]
		// 6
		addTutorialStep(6,
				[[TutorialManager.CRIT_CARD_UPGRADE]],
				TutorialV3.showUpgradeCard);

		// 7
		addTutorialStep(6,
				[[TutorialManager.CRIT_UPGRADE_CONFIRM]],
				TutorialV3.showUpgradeButton);

		// 8
		addTutorialStep(6,
				[[TutorialManager.CRIT_CLOSED_INFO]]);


		// Doc: “Fantastic work! Now that cinebit is even more powerful, earning more box office gold than ever!”
		// 9
		addTutorialStep(6,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showUpgradeResult);
				// ,
				// 'Fantastic work! Now that cinebit is even more powerful, earning more box office gold than ever!');


		// [BACK TO MAP ONTO NEXT STAGE]
		// 10
		addTutorialStep(6,
				[[TutorialManager.CRIT_STATE, Globals.STATE_MAP, TutorialStepCriteria.REL_EQUAL]]);

		// Doc: “Explore! Experiment! Enjoy! You’ll discover the secrets of CineMagic as you create the greatest movies the cinema has ever seen!”
		// 11
		addTutorialStep(6,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				null,
				'Explore! Experiment! Enjoy! You’ll discover the secrets of CineMagic as you create the greatest movies the cinema has ever seen!');

	}

	// explain specials
	private function setupStage7():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart7);

		addTutorialStep(7,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_HASMATCH_CINEBOX, 1, TutorialStepCriteria.REL_EQUAL]]);

		addTutorialStep(7,
				[[TutorialManager.CRIT_DRAW_CARD]],
				TutorialV3.setSpecialDraw);

		addTutorialStep(7,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.showDrawnSpecial);
	}

	// explain bomb mode
	private function setupStage8():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart8);

		addTutorialStep(8,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_LEVEL_TYPE, Level.TYPE_BOMB, TutorialStepCriteria.REL_EQUAL]]);

		// 1ST BOMB MODE:
		// Doc: “DANGER! This scene is full of bombs!!! Match them before they go off or they’ll blast Cinebits out of your movie!!!” [POINTS AT BOMB GEM]
		addTutorialStep(8,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.pointAtBomb,
				'DANGER! This scene is full of bombs!!! Match them before they go off or they’ll blast Cinebits out of your movie!!!');

	}

	// explain poison mode
	private function setupStage9():Void
	{
		_stageStartFuncs.push(TutorialV3.stageStart9);

		addTutorialStep(9,
				[[TutorialManager.CRIT_STATE, Globals.STATE_PLAY, TutorialStepCriteria.REL_EQUAL],
				 [TutorialManager.CRIT_LEVEL_TYPE, Level.TYPE_POISON, TutorialStepCriteria.REL_EQUAL]]);

		// 1ST BOMB MODE:
		// Doc: “HOLY MOLEY! There are MONSTERS in your scene! Avoid them at all costs! Don’t match them!”
		addTutorialStep(9,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				TutorialV3.pointAtPoison,
				'HOLY MOLEY! There are MONSTERS in your scene! Avoid them at all costs!');

		// Doc: “DO NOT MATCH THEM! THEY’LL INFEST YOUR MOVIE!”
		addTutorialStep(9,
				[[TutorialManager.CRIT_CLOSE_DOC]],
				null,
				'DO NOT MATCH THEM! THEY’LL INFEST YOUR MOVIE!');

		addTutorialStep(9,
				[[TutorialManager.CRIT_COMBO_FOUR]],
				TutorialV3.setupAntipoisonMatch);

		// [FORCE PLAYER TO MATCH 4 COMBO]
		// Doc: “By doing a combo, you’ve made a special TAP GEM! Use these to blast monsters off your board and out of your movie!”
		addTutorialStep(9,
				[[TutorialManager.CRIT_TRIGGER_ANTIPOISON]],
				TutorialV3.showAntipoisonGem);

	    // need one last step to re-enable match ability
		addTutorialStep(9,
				[[TutorialManager.CRIT_MATCH_GEM]],
				TutorialV3.allowMatch);
	}

	// explain genre mode
	private function setupStage10():Void
	{
		// 1ST GENRE MODE:
		// Doc: “On genre levels, you’ll only pull Cinebits from that type. In this scene you’ll find [GENRE] in mystery boxes.”
		// [IF FAILED]
		// Doc: “Tough break! Try building up your collection and upgrading to get more [GENRE TYPE] Cinebits”
		// [OFFERS UPGRADE]
		// [TAKES YOU TO STORE]

	}


	// used to allow various capabilities to be turned off during parts of the tutorial
	// This is another case where there wasn't a clean way to generalize- we needed to be
	// able to have totally arbitrary logic for each capability.
	public function checkCapability(?cap:Int = -1):Bool
	{
		if (Globals.TUTORIAL_DISABLED) return true;

		var maxLevel:Int = GameRegistry.stats.getMaxLevel();

		// trace('TESTING CAPABILITY: ' + cap);
		switch (cap)
		{
			case TutorialManager.CAP_DISCARD_CARDS:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
				// return true;
			}
			case TutorialManager.CAP_COUNTDOWN_TURNS:
			{
				var takeTurns:Bool = true;

				if (_currentStageNum == 0) takeTurns = _currentStepNum >= 16;
				if (_currentStageNum == 3) takeTurns = _currentStepNum >= 9;

				return takeTurns;

				// return (_currentStageNum >= 1);
			}
			case TutorialManager.CAP_SAVE_RESULTS:
			{
				return true;
			}
			case TutorialManager.CAP_DRAW_SPECIALS:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
			}
			case TutorialManager.CAP_SET_BUDGET:
			{
				return (_currentStageNum >= 2);
			}
			case TutorialManager.CAP_RETURN_TO_MAP:
			{
				var allowed:Bool = (_currentStageNum == 5 && _currentStepNum == 0) ||
								   (_currentStageNum == 7 && _currentStepNum == 0) ||
								   (_currentStageNum == 8 && _currentStepNum == 0) ||
								   (_currentStageNum == 9 && _currentStepNum == 0);

				// this is for returning to the map from the play state
				return (_tutorialComplete || allowed);
			}
			case TutorialManager.CAP_GOTO_MAP:
			{
				// this is for going to the map from the top-right buttons
				var gotoMap:Bool = true;
				if (_currentStageNum == 6 && _currentStepNum < 8) gotoMap = false;

				return (_tutorialComplete || gotoMap);
			}
			case TutorialManager.CAP_MOVE_MAP:
			{
				return (_tutorialComplete || _currentStageNum > 1);

			}
			case TutorialManager.CAP_STARTLEVEL_DISMISS:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
			}
			case TutorialManager.CAP_OPEN_STORE:
			{
				var openStore:Bool = true;
				if (_currentStageNum < 3) openStore = false;
				if (_currentStageNum == 6 && _currentStepNum < 8) openStore = false;

				return (_tutorialComplete || openStore);
			}
			case TutorialManager.CAP_CLICK_PLAY:
			{
				// prevent the play button fucntion for the first few steps of the
				// second stage

				var canPressPlay:Bool = true;

				// if (_currentStageNum == 0) canPressPlay = false;
				// if (_currentStageNum == 1 && _currentStepNum <= 1) canPressPlay = false;

				return canPressPlay;

				/*
				return (_currentStageNum != 1 ||
						_currentStepNum > 3);
				*/
			}
			case TutorialManager.CAP_VIEW_STAGES:
			{
				return (_tutorialComplete || _currentStageNum >= 4);

				// only allow player to view stage select if they've made it to the second map
				// return GameRegistry.stats._stats.maxLevel >= 10;
			}

			case TutorialManager.CAP_START_LEVEL:
			{
				return true;
				// return (_tutorialComplete || _currentStageNum >= 1);
			}
			case TutorialManager.CAP_CAN_REPLAY:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
			}
			case TutorialManager.CAP_SHARE_POSTER:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
			}
			case TutorialManager.CAP_SHOW_DAILYREWARD:
			{
				return (!GameRegistry.game.firstSession &&
						(_tutorialComplete || _currentStageNum >= 4));
			}
			case TutorialManager.CAP_DIRECTORS_MENU:
			{
				// return (_tutorialComplete || _currentStageNum >= 2);
				return false;	// directors menu is deprecated
			}
			case TutorialManager.CAP_SHOW_TIPS:
			{
				var showTips:Bool = true;

				// default to off if in the core tutorial
				if (_currentStageNum < 6) showTips = false;

				return (_tutorialComplete || showTips);
			}
			case TutorialManager.CAP_CLOSE_LEVELSTART:
			{
				var canClose:Bool = true;

				if (_currentStageNum < 3) canClose = false;
				if (_currentStageNum == 5) canClose = false;

				return (_tutorialComplete || canClose);
			}
			case TutorialManager.CAP_SHOW_OFFERS:
			{
				return (_tutorialComplete || _currentStageNum >= 7);
			}
			case TutorialManager.CAP_CHARGE_FOR_LEVEL:
			{
				return (_tutorialComplete || _currentStageNum >= 2);
			}
			case TutorialManager.CAP_SHOW_RATEGAME:
			{
				return (_tutorialComplete || maxLevel >= Globals.RATE_MIN_LEVEL);
			}
			case TutorialManager.CAP_CACHE_DOC:
			{
				return (!_tutorialComplete || _currentStageNum < 2);
			}
			case TutorialManager.CAP_CACHE_STAGE0:
			{
				return (!_tutorialComplete && _currentStageNum == 0);
			}
			case TutorialManager.CAP_CACHE_STAGE1:
			{
				return (!_tutorialComplete && _currentStageNum == 1);
			}
			case TutorialManager.CAP_CACHE_STAGE2:
			{
				return (!_tutorialComplete && _currentStageNum == 2);
			}
			case TutorialManager.CAP_ADD_CINEBOXES:
			{
				var canAdd:Bool = true;

				if (_currentStageNum < 3) canAdd = false;
				if (_currentStageNum == 3) canAdd = _currentStepNum >= 6;
				if (_currentStageNum == 4) canAdd = _currentStepNum >= 4;

				return canAdd;
			}
			case TutorialManager.CAP_CARD_COMBOS:
			{
				var combosAllowed:Bool = true;

				if (_currentStageNum < 4) combosAllowed = false;

				return combosAllowed;
			}
			case TutorialManager.CAP_VIEW_MENU:
			{
				var viewMenu:Bool = false;
				if (_currentStageNum >= 7) viewMenu = true;
				if (_currentStageNum == 6) viewMenu = _currentStepNum >= 9;
				return (_tutorialComplete || viewMenu);
			}
			case TutorialManager.CAP_VIEW_CARDS:
			{
				return (_tutorialComplete || _currentStageNum >= 6);
			}
			case TutorialManager.CAP_FULL_PRICE_CARDS:
			{
				return (_tutorialComplete || _currentStageNum >= 1);
			}
			case TutorialManager.CAP_EARLY_RELEASE:
			{
				var canReleaseEarly:Bool = _currentStageNum >= 3;
				if (_currentStageNum == 1) canReleaseEarly = true;

				return (_tutorialComplete || canReleaseEarly);
			}
			case TutorialManager.CAP_FX_ENABLED:
			{
				var showFX:Bool = true;

				if (_currentStageNum < 5 || maxLevel < 7) showFX = false;
				return (_tutorialComplete || showFX);
			}
			case TutorialManager.CAP_OPEN_FX:
			{
				return (_tutorialComplete || _currentStageNum >= 5);
			}
			case TutorialManager.CAP_CHARGE_FOR_FX:
			{
				return (_tutorialComplete || _currentStageNum >= 6);
			}
			case TutorialManager.CAP_SHOW_ALL_FX_SLOTS:
			{
				return (_tutorialComplete || _currentStageNum >= 6);
			}
			case TutorialManager.CAP_FORCE_WIN:
			{
				var forceWin:Bool = true;
				// trace('CHECKING FORCE WIN');
				if (_tutorialComplete || _currentStageNum >= CORE_TUTORIAL_END_STAGE) forceWin = false;
				return forceWin;
			}
			case TutorialManager.CAP_CAN_BUY_FX:
			{
				return (_tutorialComplete || _currentStageNum >= 6);
			}
			case TutorialManager.CAP_CLOSE_FX_EQUIP:
			{
				return (_tutorialComplete || _currentStageNum >= 6);
			}
			case TutorialManager.CAP_SHOW_PASSIVE_HINTS:
			{
				return (_tutorialComplete || _currentStageNum > 6);
			}
			case TutorialManager.CAP_CANCEL_UPGRADE:
			{
				return (_tutorialComplete || _currentStageNum >= 7);
			}
			case TutorialManager.CAP_FORCE_UPGRADE_SUCCESS:
			{
				return (!_tutorialComplete && _currentStageNum == 6);
			}
			case TutorialManager.CAP_CHANGE_CARD_TABS:
			{
				var canChangeTabs:Bool = false;
				if (_currentStageNum > 6) canChangeTabs = true;
				if (_currentStageNum == 6 && _currentStepNum >= 8) canChangeTabs = true;

				return (_tutorialComplete || canChangeTabs);
			}
			case TutorialManager.CAP_VIEW_CARD_INFO:
			{
				var viewInfo:Bool = true;
				if (_currentStageNum == 6 && _currentStepNum < 8) viewInfo = false;

				return (_tutorialComplete || viewInfo);
			}
			case TutorialManager.CAP_CAN_VIEW_ADS:
			{
				return (_tutorialComplete || _currentStageNum > 2);
			}
			case TutorialManager.CAP_CANCEL_PACKBUY:
			{
				var canCancel:Bool = true;
				if (_currentStageNum == 6) canCancel = false;
				if (_currentStageNum == 6 && _currentStepNum > 5) canCancel = true;
				return (_tutorialComplete || canCancel);
			}
			case TutorialManager.CAP_PLAY_INTRO:
			{
				return (!_tutorialComplete && _currentStageNum < 2);
			}
			case TutorialManager.CAP_ARCADE_BOMB:
			{
				return maxLevel >= GameRegistry.levels.firstBomb();
			}
			case TutorialManager.CAP_ARCADE_POISON:
			{
				return maxLevel >= GameRegistry.levels.firstPoison();
			}
			case TutorialManager.CAP_COLLECTION_REWARD:
			{
				return (_tutorialComplete || _currentStageNum > 6);
			}
			case TutorialManager.CAP_TRIGGER_POISON:
			{
				var triggerPoison:Bool = true;
				if (_currentStageNum == 9) triggerPoison = false;
				return (_tutorialComplete || triggerPoison);
			}
			case TutorialManager.CAP_CHARGE_FOR_PACKS:
			{
				return (_tutorialComplete || _currentStageNum >= 7);
			}
			case TutorialManager.CAP_SHOW_STARMACHINE:
			{
				return (_tutorialComplete || _currentStageNum >= 7);
			}
			case TutorialManager.CAP_SHOW_DAILY_CHALLENGE:
			{
				return (_tutorialComplete || maxLevel >= SHOW_DAILY_CHALLENGE_LEVEL);
			}
		}
		return true;
	}

	public function tutorialComplete():Bool
	{
		return (_tutorialComplete || _currentStageNum >= _tutorialData.length);
	}

	public function debugSetStage(stage:Int):Void
	{
		if (stage < 0 || stage >= _tutorialData.length)
		{
			trace('BAD TUTORIAL STAGE: ' + stage);
			return;
		}

		_tutorialComplete = false;
		GameRegistry.stats.setTutorial(stage);
		clearCriteria();
		setTutorialStep(stage, 0);
		if (stage == 0) registerAction(TutorialManager.CRIT_START_GAME);
		startTutorial();
	}

	private function setTutorialStep(stage:Int, step:Int):Void
	{
		if (stage <= _tutorialData.length)
		{
			if (step <= _tutorialData[stage].length)
			{
				if (_tutorialData[stage][step] != null)
				{
					_currentStageNum = stage;
					_currentStepNum = step;
					_currentStep = _tutorialData[_currentStageNum][_currentStepNum];
				}
			}
		}
	}

	// used to re-run setup functions if a given level requires it
	public function checkLevelStart(level:Int):Void
	{
		/*
		var firstBomb:Int = GameRegistry.levels.firstBomb();
		var firstPoison:Int = GameRegistry.levels.firstPoison();
		if (level == firstBomb)
		{
			GameRegistry.popups.addPopup(new PopupLevelHint(PopupLevelHint.HINT_BOMB_MODE), false, true);
			return;
		}

		if (level == firstPoison)
		{
			GameRegistry.popups.addPopup(new PopupLevelHint(PopupLevelHint.HINT_POISON_MODE), false, true);
			return;
		}
		*/

		switch (level)
		{

			case 2:
			{
				// TutorialSteps.setupMovieStage2();
			}
			case 3:
			{
				// TutorialSteps.setupMovieStage3();
			}

		}
	}

	private function startStage():Void
	{
		if (_stageStartFuncs[_currentStageNum] != null)
		{
			_stageStartFuncs[_currentStageNum]();
		}
	}

	public function getTutorialStage():Int
	{
		return _currentStageNum;
	}

	public function resetTutorial():Void
	{
		_currentStageNum = 0;
		_currentStepNum = 0;
		_currentStep = _tutorialData[_currentStageNum][_currentStepNum];
		_tutorialComplete = false;

		if (Globals.TUTORIAL_DISABLED) _tutorialComplete = true;
		trace('TUTORIAL RESET');
	}

	public function startTutorial():Void
	{
		if (_tutorialComplete) return;

		trace('STARTING TUTORIAL ' + _currentStageNum + ' ' + _currentStepNum);

		startStage();
		_pauseCriteria = false;
		_currentStep.start();
	}

	public function check():Void
	{
		// used to prevent anything in the stage change process from
		// triggering the next stage
		if (_pauseCriteria) return;

		if (_currentStep.isComplete(_criteriaValues))
		{
			_hintTimer = 0;

			var tutName:String =
			   "ftue_stage_" + _currentStageNum + "_step_" + _currentStepNum;
			GameRegistry.analytics.endTimedEvent(tutName);

			// trace('FINISHED STAGE ' + _currentStageNum + ', STEP: ' + _currentStepNum);
			_pauseCriteria = true;

			_currentStep.end();
			clearCriteria();

			_currentStepNum += 1;

			// check to see if we've advanced to the next stage
			if (_currentStepNum >= _tutorialData[_currentStageNum].length)
			{
				// trace('FINISHED STAGE ' + _currentStageNum);
				_currentStepNum = 0;
				_currentStageNum += 1;

				GameRegistry.stats.setTutorial(_currentStageNum);

				// check to see if we've completed the tutorial
				if (_currentStageNum >= _tutorialData.length)
				{
					clearCriteria();
					trace('TUTORIAL COMPLETE!!!!');
					_tutorialComplete = true;
					return;
				}
			}


			_currentStep = _tutorialData[_currentStageNum][_currentStepNum];

			if (_currentStep != null)
			{
				// trace('STARTING STAGE: ' + _currentStageNum + ' STEP: ' + _currentStepNum);
				var tutName:String =
				   "ftue_stage_" + _currentStageNum + "_step_" + _currentStepNum;
				GameRegistry.analytics.logEvent(tutName);
				_currentStep.start();

			}
			_pauseCriteria = false;
		}
	}

	public function addTutorialStep(stage:Int,
					crit:Array<Array<Int>>,
					?sFunc:Void->Void = null,
					?sMsg:String = '',
					?eFunc:Void->Void = null,
					?eMsg:String = '',
					?point:IntPoint = null):Void
	{
		if (_tutorialData[stage] == null)
		{
			_tutorialData[stage] = new Array<TutorialStepData>();
		}

		_tutorialData[stage].push(new TutorialStepData(stage, _tutorialData[stage].length, crit, sFunc, sMsg, eFunc, eMsg, point));
	}

	// This is the main way that the tutorial advances. Calls to registerAction appear in various places
	// in the game, each time the player does somthing that might trigger the completion of a tutorial step.
	// This will default to replacing the current value with the new one (which will default to -1)
	// also defaults to replacing the existing value with the one passed in
	public function registerAction(criteria:Int, ?arg:Int = -1, ?action:Int = 2, removePause:Bool = false):Void
	{

		if (_tutorialComplete) return;

		var newArg:Int = arg;
		if (arg != -1)
		{
			newArg = 0;
			if (_criteriaValues.exists(criteria))
			{
				newArg = _criteriaValues.get(criteria);
			}

			switch (action)
			{
				case TutorialManager.CRIT_ADD:
				{
					newArg += arg;
				}
				case TutorialManager.CRIT_SUB:
				{
					newArg -= arg;
				}
				case TutorialManager.CRIT_REPLACE:
				{
					newArg = arg;
				}
			}
		}

		if (criteria != TutorialManager.CRIT_PAUSE_MILLIS)
		{
			// trace('SET ' + criteria + ' TO ' + newArg);
		}
		// TODO: might be a good idea to not run check() every update if the current step
		// doesn't have a CRIT_PAUSE_MILLS criteria
		_criteriaValues.set(criteria, newArg);

		if (criteria != TutorialManager.CRIT_PAUSE_MILLIS || _currentStep.hasPause)
		{
			if (removePause) _pauseCriteria = false;
			check();
		}
	}

	private function clearCriteria():Void
	{
		// trace('CLEARING TUTORIAL CRITERIA');
		GameRegistry.popups.clearTutorialElements();
		_criteriaValues = new Map<Int, Int>();
		trace('CRITERIA CLEARED');
	}

	public function update(dt:Float):Void
	{
		if (_tutorialComplete) return;

		_hintTimer += dt;

		if (_hintTimer >= HINT_WAIT_TIME)
		{
			_hintTimer = 0;
		}
	}
}

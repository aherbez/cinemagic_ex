package com.jamwix.hs.tutorial;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

import com.jamwix.hs.cards.Card;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.match.Gem;
import com.jamwix.hs.states.StatePlayGame;
import com.jamwix.hs.states.StateMapView;
import com.jamwix.hs.ui.popups.PopupDoc;
import com.jamwix.hs.ui.playgame.FilmStrip;
import com.jamwix.hs.cards.HandDisplay;
import com.jamwix.hs.tutorial.TutorialManager;
import com.jamwix.hs.tutorial.TutorialStepData;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.reviews.Critic;
import com.jamwix.hs.ui.popups.PopupArrow;
import com.jamwix.hs.ui.BankBar;
import com.jamwix.hs.ui.popups.PopupStarSelect;
import com.jamwix.hs.ui.GreenButton;
import com.jamwix.hs.levels.Level;
import com.jamwix.hs.cards.Attributes;
import com.jamwix.hs.states.StatePlayGame;
import com.jamwix.hs.states.StateCardManager;


import com.jamwix.utils.IntPoint;
import com.jamwix.utils.JWUtils;

/*
	We iterated a lot on the tutorial, and wanted to be able to swap back and forth between implementations,
	hence the separate files.

	You'll also notice that this is just a large number of static functions, each one of which does various things.
	Tutorial systems have to be "messy" to a certain degree, since you're constantly breaking the game's
	normal functionality. Implementing arbitrary functions here is one of the ways that such breakages were
	contained.
*/
class TutorialV3
{
	static public function allowMatch():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setMatchEnabled(true);
		}
	}

	static public function showAntipoisonGem():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.clearAllowedMatch();

			var pos:IntPoint = spg.findSpecialGemPos(Gem.TYPE_ANTIPOISON);
			GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);

			spg.setMatchEnabled(false);
		}

		var msg:String = 'By doing a combo, you’ve made a special TAP GEM! Touch these to blast monsters off your board and out of your movie!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 40);
	}

	static public function setupAntipoisonMatch():Void
	{
		TutorialSteps.enableMatch();

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setAllowedMatch([[4,1],[4,2]], -1, true);
		}

		var msg:String = 'Try making a match-four combo!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}

	static public function pointAtPoison():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialSetBoard([
				[3,5,0,2,3,1,0,1],
				[5,3,4,1,2,0,4,2],
				[5,0,2,2,5,2,0,1],
				[2,1,4,3,0,4,4,0],
				[1,2,1,1,3,0,1,3],
				[4,1,3,0,2,1,2,0]]
			);

			spg.tutorialSetBomb(3, 1);
			spg.tutorialSetBomb(5, 1);
			spg.tutorialSetBomb(3, 3);
			spg.tutorialSetBomb(5, 3);

			TutorialSteps.disableMatch();
			spg.tutorialPointAtGem(3, 1);
		}
	}

	static public function pointAtBomb():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var pos:IntPoint = spg.findSpecialGemPos(Gem.TYPE_BOMB);
			GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);
		}
	}

	static public function showUpgradeResult():Void
	{
		var scm:StateCardManager = GameRegistry.game.stateCardManager();
		if (scm != null)
		{
			scm.tutorialLockUpgradeSlot(-1);
		}
		var msg:String = 'Fantastic work! Now that cinebit is even more powerful, earning more box office gold than ever!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT, true, 42);

	}


	static public function showUpgradeConfirm():Void
	{
		var scm:StateCardManager = GameRegistry.game.stateCardManager();
		if (scm != null)
		{
			// scm.tutorialShowCard(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID);
		}
	}


	static public function showUpgradeButton():Void
	{
		var scm:StateCardManager = GameRegistry.game.stateCardManager();
		if (scm != null)
		{
			// scm.tutorialShowCard(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID);
			var pos:IntPoint = new IntPoint(0, 0);
			pos.x = Std.int(Globals.WIDTH/2) + Globals.UIInt(218);
			pos.y = Std.int(Globals.HEIGHT/2) + Globals.UIInt(422);

			GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);
		}
	}

	// ensure that the proper card is shown at the top left of the manage cards screen
	static public function showUpgradeCard():Void
	{
		var scm:StateCardManager = GameRegistry.game.stateCardManager();
		if (scm != null)
		{
			// scm.tutorialShowCard(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID);
			var pos:IntPoint = scm.tutorialGetUpgradePos(0);
			scm.tutorialLockUpgradeSlot(0);

			GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);

			var msg:String = 'Let’s upgrade a cinebit now! Tap there to upgrade!';
			GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);
		}

	}

	static public function forceShowUpgradeCard():Void
	{
		var scm:StateCardManager = GameRegistry.game.stateCardManager();
		if (scm != null)
		{
			scm.tutorialShowCard(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID);
		}
	}

	static public function showViewCinebits():Void
	{
		var pos:IntPoint = new IntPoint(0,0);
		pos.x = Std.int(Globals.WIDTH/2 + Globals.UIInt(412));
		pos.y = Std.int(Globals.HEIGHT/2 + Globals.UIInt(468));

		GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);

		var msg:String = 'Tap that button and let’s check out your Cinebit Collection!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT, false);
	}

	static public function promptOpenPack():Void
	{
		var msg:String = 'Swipe the pack to open it!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);
	}


	static public function showBuyPack():Void
	{
		// make sure our upgrade card is upgradable!
		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID);
		if (cd.levelXP > CardData.LEVEL_AMT_2)
		{
			GameRegistry.cards.setCardXp(TutorialManager.EXAMPLE_CARD_UPGRADE_CARD_ID, CardData.LEVEL_AMT_2);
		}

		GameRegistry.offers.tutorialOfferPack();

		var pos:IntPoint = new IntPoint(0,0);
		pos.x = Std.int(Globals.WIDTH/2 + Globals.UIInt(488));
		pos.y = Std.int(Globals.HEIGHT/2 + Globals.UIInt(406));

		GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);

		var msg:String = 'You’ve earned it! Buy a pack of Cinebits and let’s see what’s inside!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT, false);
	}

	static public function allowAllFXEquip():Void
	{
		GameRegistry.powerups.tutorialLockEquipPower(-1);
	}

	static public function promptUseMagnet2():Void
	{
		var msg:String = 'Now select the type of gem to grab!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);


	}

	static public function promptUseMagnet():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var pos:IntPoint = spg.tutorialGetFXLoc(0);
			pos.x = Globals.UIInt(pos.x) + Globals.UIInt(50);
			pos.y = Globals.UIInt(pos.y) + Globals.UIInt(30);

			// if (Globals.IS_WIDE)
			if (Globals.IS_16_9)
			{
				// pos.x += Std.int(Globals.WOFF / 2);
				pos.x = Globals.UIInt(324);
				pos.y = Globals.UIInt(602);
			}

			GameRegistry.popups.showArrowAt(pos, PopupArrow.TOPLEFT);
		}

		var msg:String = 'Time to use your new special FX power. Get ready for magic! Tap the magnet now!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 44);
	}

	static public function showStartLevelFX():Void
	{
		var pos:IntPoint = new IntPoint(Globals.UIInt(1176), Globals.UIInt(1253));

		if (Globals.IS_WIDE)
		{
			pos.x += Std.int(Globals.WOFF/2) + Globals.UIInt(30);
		}

		// GameRegistry.popups.highlightRegions(playHighlightRects());
		GameRegistry.popups.showArrowAt(pos, 3);

		var msg:String = 'Now let’s try it out! Touch the play button.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT, false);

	}

	static public function showEquipMagnet():Void
	{
		var p:IntPoint = new IntPoint(0,0);
		p.x = Std.int(Globals.WIDTH/2 - Globals.UIInt(646));
		p.y = Std.int(Globals.HEIGHT/2 + Globals.UIInt(148));
		GameRegistry.popups.showArrowAt(p, PopupArrow.BOTLEFT);

		var msg:String = 'Equip the magnet by touching here!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);
	}

	static public function showEquipFX():Void
	{
		var p:IntPoint = new IntPoint(0,0);
		p.x = Std.int(Globals.WIDTH/2 - Globals.UIInt(228));
		p.y = Std.int(Globals.HEIGHT/2 - Globals.UIInt(334));
		GameRegistry.popups.showArrowAt(p, PopupArrow.TOPLEFT);

		GameRegistry.powerups.tutorialLockEquipPower(TutorialManager.FIRST_POWERUP_ID);

		var msg:String = 'I’ve made you something special in the Laboratory of Science and Magic! Press here to equip it.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 46);
	}

	static public function add10Turns():Void
	{
		GameRegistry.game.setTurns(15);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialShowTurns();
			spg.tutorialEnableTips();
		}
	}

	static public function showDrawnSpecial():Void
	{
		var msg:String = 'You found a BONUS [GEM_SPECIAL] Cinebit! Amazing! These bonuses ALWAYS help your movie score more box office gold.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT, true, 40);

		var cardPos:IntPoint = GameRegistry.hand.getCardPositionByID(TutorialManager.DRAW_SPECIAL);

		GameRegistry.popups.showArrowAt(cardPos, PopupArrow.BOTLEFT);

	}

	static public function setSpecialDraw():Void
	{
		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.DRAW_SPECIAL);
	}

	static public function promptCardChoice():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.clearAllowedMatch();
		}

		var msg:String = 'Astounding! GREEN MYSTERY BOX [GEM_CINEBOX] COMBOS gives you a choice in what Cinebit you get.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 44);

	}

	static public function showCineboxCombo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		spg.tutorialShowMatch([[4,2],[4,3]]);

		GameRegistry.resources.preventGemCredit(-1);


		var msg:String = 'I wonder what happens if you match 4 mystery boxes!?';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 46);
	}

	static public function setupCineboxCombo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialSetBoard([
				[3,5,4,2,3,4,3,1],
				[5,1,4,1,2,1,3,4],
				[5,0,2,2,5,3,2,1],
				[2,1,5,5,1,5,3,0],
				[1,2,1,2,4,0,1,3],
				[4,1,3,2,2,1,2,0]]
			);

			spg.setAllowedMatch([[4,2],[4,3]]);
		}
	}

	static public function clearMatchFour():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.clearAllowedMatch();
			spg.tutorialEnableTips();
		}
		TutorialV3.allowReleaseOnNoCards();
	}

	static public function setupMatchFour():Void
	{

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialShowMatch([[3,1],[3,2]]);
		}

		// turn off lock preventing houses from being matched
		GameRegistry.resources.preventGemCredit(-1);

		var msg:String = 'Try matching 4 gems and see what happens!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}


	static public function explainThumbs2():Void
	{
		var msg:String = 'Add too many thumbs down [ICON_THUMB_DOWN] in a genre, and your movie may become something different.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);
	}

	static public function explainThumbs():Void
	{
		var msg:String = 'If you don’t like your movie genre, just try new Cinebits and watch how it changes.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);
	}

	static public function showLockedActor2():Void
	{
		var msg:String = 'You’ve got to come up with a hit movie starring [GENDER]!';

		var cd:CardData;

		// if (actor.hasAttribute(Attributes.ATT_MALE)) _peopleGenders[i] = CardData.GENDER_MALE;
		var cid:Int = -1;

		if (GameRegistry.game.posterDat != null)
		{
			if (GameRegistry.game.posterDat.people != null)
			{
				if (GameRegistry.game.posterDat.people[0] != null)
				{
					cid = GameRegistry.game.posterDat.people[0].actorID;
				}
			}
		}

		if (cid != -1)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cid);
			var gender:String = 'him';
			if (cd.hasAttribute(Attributes.ATT_FEMALE))
			{
				gender = 'her';
			}

			msg = StringTools.replace(msg, '[GENDER]', gender);
		}

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}

	static public function showLockedActor():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialSetBoard([
				[3,2,1,2,3,4,3,1],
				[0,1,4,3,1,1,3,4],
				[2,0,3,2,3,3,2,1],
				[2,1,2,1,1,4,3,0],
				[1,2,1,2,4,0,1,3],
				[4,1,3,2,2,1,2,0]]
			);

			spg.setAllowedMatch([[3,1],[3,2]]);
		}

		var msg:String = 'This actor, [ACTOR NAME], is locked in your film under studio contract! That means you can’t replace em.';

		var cid:Int = -1;

		if (GameRegistry.game.posterDat != null)
		{
			if (GameRegistry.game.posterDat.people != null)
			{
				if (GameRegistry.game.posterDat.people[0] != null)
				{
					cid = GameRegistry.game.posterDat.people[0].actorID;
				}
			}
		}

		if (cid != -1)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cid);
			msg = StringTools.replace(msg, '[ACTOR NAME]', cd.cardName);
		}


		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT, true, 44);

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var p:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.25),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));
		GameRegistry.popups.showArrowAt(p, PopupArrow.BOTLEFT);

	}

	static public function addTurns10_s1():Void
	{
		GameRegistry.game.setTurns(15);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialShowTurns();
			spg.tutorialLockFilmstripSlot(-1);
			spg.tutorialEnableTips();
		}
	}

	static public function promptAddCharacter_s1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// TODO: disallow any film strip element other than the first
			spg.tutorialLockFilmstripSlot(1);
			TutorialSteps.enableMatch();

			spg.tutorialLockRating(-1, false);
			spg.disableGemWeight();
		}

		var msg:String = 'Now let’s beef up this actor’s role. Add the CHAR_NAME CHARACTER [GEM_CHARACTER] to ACTOR_NAME and see what happens!';

		var cdChar:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_CHARACTER);
		var cdActor:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_ACTOR);

		msg = StringTools.replace(msg, 'CHAR_NAME', cdChar.cardName);
		msg = StringTools.replace(msg, 'ACTOR_NAME', cdActor.cardName);

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 40);

		var start:IntPoint = GameRegistry.hand.getCardPositionByID(TutorialManager.REPLACE_DRAW_CHARACTER);

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));

		GameRegistry.popups.highlightRegions(addCharacterRects());
		GameRegistry.popups.animatePointer(start, end, true);

	}

	public static function addCharacterRects():Array<Rectangle>
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		var filmStrip:FilmStrip = spg.getFilmstrip();
		var handDisplay:HandDisplay = spg.getHandDisplay();

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var seRect:Rectangle = filmStrip.seRect(1);
		seRect.x += filmStrip.x;
		seRect.y += filmStrip.y;

		var r1:Rectangle = new Rectangle();
		if (GameRegistry.hand != null)
		{
			r1 = GameRegistry.hand.getHighlightRect(0);
		}

		return [r1, seRect];
	}

	static public function setupCharacterMatch_s1():Void
	{

		var msg:String = 'Match [GEM_CHARACTER] icons to add CHAR_NAME to your movie!';

		var cdChar:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_CHARACTER);

		msg = StringTools.replace(msg, 'CHAR_NAME', cdChar.cardName);

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

		TutorialSteps.enableMatch();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setGemWeight(0);
		}


	}

	static public function promptCharacterMatch():Void
	{
		// var msg:String = 'Match [GEM_CHARACTER] icons to add CHAR_NAME to your movie!';
		var msg:String = 'CHAR_NAME! Awesome! That’s a great character for an action flick!';

		var cdChar:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_CHARACTER);

		msg = StringTools.replace(msg, 'CHAR_NAME', cdChar.cardName);

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT);

		GameRegistry.hand.moveCardToFront(TutorialManager.REPLACE_DRAW_CHARACTER);
		// TutorialSteps.enableMatch();

		GameRegistry.resources.tutorialClearMana();

		var cardPos:IntPoint = GameRegistry.hand.getCardPositionByID(TutorialManager.REPLACE_DRAW_CHARACTER);

		GameRegistry.popups.showArrowAt(cardPos, PopupArrow.BOTLEFT);

	}

	static public function setupCharacterDraw():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var match:Array<IntPoint> = spg.findMatchOfType(5);

			// spg.setAllowedMatch([[3,1],[3,2]], 5);

			spg.setAllowedMatch([[match[0].x, match[0].y],
								[match[1].x, match[1].y]], 5, true);

		}

		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.REPLACE_DRAW_CHARACTER);

		var msg:String = 'Let’s see what’s in these CineBoxes [GEM_CINEBOX] !';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}

	static public function waitForCinebox():Void
	{
		TutorialSteps.enableMatch();

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var result:Array<IntPoint> = spg.findMatchOfType(5);
			var hasMatch:Bool = true;
			if (result[0].x == -1 || result[0].y == -1 || result[1].x == -1 || result[1].y == -1) hasMatch = false;
			if (hasMatch)
			{
				GameRegistry.tutorial.registerAction(TutorialManager.CRIT_HASMATCH_CINEBOX, 1, 2, true);
				return;
			}
			else
			{
				spg.setGemWeight(5);
			}
		}

		var msg:String = 'Keep matching gems! Let’s try to find another CineBox [GEM_CINEBOX] match!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);
	}


	static public function showSwapActors_s1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// TODO: disallow any film strip element other than the first
			spg.tutorialLockFilmstripSlot(1);

			spg.tutorialLockRating(-1, false);
		}

		var start:IntPoint = GameRegistry.hand.getCardPositionByID(TutorialManager.REPLACE_DRAW_ACTOR);

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));
		GameRegistry.popups.animatePointer(start, end);

		GameRegistry.popups.highlightRegions(swapActorRects());

		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_ACTOR);

		var msg:String = 'Now drag ' + cd.cardName + ' onto Carry to replace him.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 44);

	}

	public static function loadSwapActorHighlight():Void
	{
		TutorialSteps.cacheHighlight(swapActorRects);
	}

	public static function swapActorRects():Array<Rectangle>
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var r1:Rectangle = new Rectangle();
		if (GameRegistry.hand != null)
		{
			r1 = GameRegistry.hand.getHighlightRect(0);
		}

		var r2:Rectangle = new Rectangle();
		r2.x = filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X);
		r2.y = filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + FilmStrip.ELEMENT_HEIGHT + Globals.UIInt(8);
		r2.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH);
		r2.height = FilmStrip.ELEMENT_HEIGHT;

		return [r1, r2];
	}

	static public function promptActorMatch():Void
	{
		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_ACTOR);

		var msg:String = 'Match [GEM_ACTOR] to add [PRONOUN2]!';

		msg = StringTools.replace(msg, '[NAME]', cd.cardName);

		if (cd.hasAttribute(Attributes.ATT_FEMALE))
		{
			msg = StringTools.replace(msg, '[PRONOUN2]', 'her');
		}
		else
		{
			msg = StringTools.replace(msg, '[PRONOUN2]', 'him');
		}

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setGemWeight(2);
		}

	}

	static public function setupActorMatch_s1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.clearAllowedMatch();
		}

		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.REPLACE_DRAW_ACTOR);

		var msg:String = 'Here we go, actor [NAME] is much better fit with this plot and location. [PRONOUN] help you make an awesome action movie!';

		msg = StringTools.replace(msg, '[NAME]', cd.cardName);

		if (cd.hasAttribute(Attributes.ATT_FEMALE))
		{
			msg = StringTools.replace(msg, '[PRONOUN]', "She'll");
		}
		else
		{
			msg = StringTools.replace(msg, '[PRONOUN]', "He'll");
		}

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, true, 40);

		var cardPos:IntPoint = GameRegistry.hand.getCardPositionByID(TutorialManager.REPLACE_DRAW_ACTOR);

		GameRegistry.popups.showArrowAt(cardPos, PopupArrow.BOTLEFT);


	}

	static public function setupActorDraw_s1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{

			spg.setMatchEnabled(true);
			spg.tutorialLockCardInfo(false);
			spg.tutorialLimitInfo(-1);

			spg.setAllowedMatch([[3,1],[3,2]], 5, true);

			// turn off lock preventing houses from being matched
			GameRegistry.resources.preventGemCredit(-1);

			// GameRegistry.popups.animatePointer(start, end);
		}

		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.REPLACE_DRAW_ACTOR);

		var msg:String = 'Look at that! A Cinebit Mystery Box! Open it and you’ll get a Cinebit from your collection. Match them now!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 46);


	}

	static public function showGenreMismatch_s1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialLockCardInfo(true);
			spg.tutorialLimitInfo(208);	// Slim Carrey
		}

		// point at genre in filmstrip
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		// point at genre in card detail view
		var genreX:Int = Globals.UIInt(1200);
		// if (Globals.IS_WIDE)
		if (Globals.IS_16_9)
		{
			genreX += Std.int(Globals.WOFF/2);
		}
		else
		{
			genreX = Globals.UIInt(952);
		}

		// arrow at genre label
		var arrowX:Int = Std.int(filmPos.x + Globals.UIInt(FilmStrip.filmStripWidth) * 0.55);
		var arrowY:Int = Globals.HEIGHT - Std.int(Globals.UIInt(108) * 0.75);
		GameRegistry.popups.showArrowAt(new IntPoint(arrowX, arrowY), PopupArrow.BOTLEFT);

		// arrow at "action"
		GameRegistry.popups.showArrowAt(new IntPoint(genreX, Globals.UIInt(876)), PopupArrow.TOPLEFT);

		var msg:String = 'Here’s the problem, you’ve got an action packed PLOT [GEM_PLOT] and LOCATION [GEM_LOCATION] but this actor’s not good at action.';
		//var msg:String = 'PLOT [GEM_PLOT] LOCATION [GEM_LOCATION] ACTOR [GEM_ACTOR] CHARACTER [GEM_CHARACTER] BOX [GEM_CINEBOX]';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT, true, 40);

		// loadShowAltActorHighlight();
	}

	static public function genreMistmatchRects():Array<Rectangle>
	{

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var r:Rectangle = new Rectangle();
		r.x = filmPos.x + Globals.UIInt(44);
		r.y = Globals.HEIGHT - Globals.UIInt(108);
		r.width = Globals.UIInt(608);
		r.height = Globals.UIInt(108);

		// show bad rating in action
		var r2:Rectangle = new Rectangle();
		r2.x = Globals.UIInt(914);
		if (Globals.IS_WIDE) r2.x += Std.int(Globals.WOFF/2);
		r2.y = Globals.UIInt(800);
		r2.width = Globals.UIInt(300);
		r2.height = Globals.UIInt(114);

		return [r, r2];
	}

	static public function startSecondLevel_s1():Void
	{
		// add cards to the filmstrip
		// plot, character,
		// leave: location, actor
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{

			spg.tutorialSetBoard([
				[0,2,1,3,3,1,3,1],
				[0,2,4,5,0,1,0,5],
				[2,0,5,2,5,0,5,1],
				[2,1,0,1,0,4,3,0],
				[0,2,0,2,5,0,1,5],
				[5,2,5,2,2,0,5,0]]
			);

			spg.setMatchEnabled(false);


			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			// var cid:Int;
			var cd:CardData;

			for (i in TutorialManager.REPLACE_START_CARDS)
			{
				cd = GameRegistry.cards.getCardByID(i);
				spg.tutorialAddCardToFilmstrip(cd);

			}

			spg.tutorialSetCinemeter(3);

			spg.tutorialLockGenre(CardData.GENRE_ACTION, false);
			spg.tutorialLockRating(0.2, true);

			// GameRegistry.popups.highlightRegions(startSecondRects());

		}

		var msg:String = 'This movie’s in trouble and needs help. Let’s tap this actor and see what’s wrong.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT, false, 46);


		// var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		// GameRegistry.popups.showArrowAt(p, 1);
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var p:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.35),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));
		// GameRegistry.popups.animatePointer(start, end);
		GameRegistry.popups.showArrowAt(p, PopupArrow.TOPLEFT);

		loadShowActorRects();
	}

	static public function startSecondRects():Array<Rectangle>
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var r:Rectangle = spg.getCinemeterPos();
			r.x -= (r.width * 0.1);
			r.y -= (r.height * 0.1);
			r.width = r.width * 1.2;
			r.height = r.height * 1.2;

			if (Globals.IS_WIDE) r.x -= Std.int(Globals.WOFF/2);
			return [r];
		}

		return null;
	}

	static public function showActorRects():Array<Rectangle>
	{
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var p:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X)),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y)));

		var r:Rectangle = new Rectangle();
		r.x = p.x;
		r.y = p.y + FilmStrip.ELEMENT_HEIGHT + Globals.UIInt(8);
		r.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH);
		r.height = FilmStrip.ELEMENT_HEIGHT;

		return [r];
	}

	static public function loadShowActorRects():Void
	{
		TutorialSteps.cacheHighlight(showActorRects);
	}

	static public function showRemainingTurns_s1():Void
	{
		var level:Level = GameRegistry.levels.currLevel();
		var turns:Int = level.maxTurns;

		var msg:String = 'See what kind of amazing movie you can build with these Cinebits in [X] turns… GO!';

		msg = StringTools.replace(msg, '[X]', Std.string(turns));
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT, true, 40);
		GameRegistry.game.statePlayGame().tutorialEnableTips();

	}


	static public function highlightPlayButton_s1():Void
	{
		// TODO: Fix the xpos of the button reference

		// var pos:IntPoint = new IntPoint(Std.int(Globals.UIInt(934) + Globals.UIInt(150)),
		// 								Std.int(Globals.UIInt(1150) + Globals.UIInt(PopupStarSelect.POS_Y)));

		// var r:Rectangle = new Rectangle(pos.x - GreenButton.WIDTH * 0.1,
		// 								pos.y - GreenButton.HEIGHT * 0.1,
		// 								GreenButton.WIDTH * 1.2,
		// 								GreenButton.HEIGHT * 1.2);


		var pos:IntPoint = new IntPoint(Globals.UIInt(1176), Globals.UIInt(1253));

		if (Globals.IS_WIDE)
		{
			pos.x += Std.int(Globals.WOFF/2) + Globals.UIInt(30);
		}

		// GameRegistry.popups.highlightRegions(playHighlightRects());
		GameRegistry.popups.showArrowAt(pos, 3);

		// var msg:String = 'Touch the play button!';
		// GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT, false);

	}

	static public function playHighlightRects():Array<Rectangle>
	{
		var r:Rectangle = new Rectangle(Globals.UIInt(1106)	, Globals.UIInt(1190),
										Globals.UIInt(563), Globals.UIInt(220));


		if (Globals.IS_WIDE)
		{
			r.x += Std.int(Globals.WOFF/2);// + Globals.UIInt(30);
		}

		if (Globals.RETINA)
		{
			r.y += Globals.UIInt(50);
		}

		return [r];
	}

	static public function showStartLevel_s0():Void
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(0);
			GameRegistry.popups.highlightRegions(showStartRects());
			GameRegistry.popups.showArrowAt(pos);
		}

		var msg:String = 'Welcome to CineMagic! Touch here to start';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 44);

	}

	static public function showStartRects():Array<Rectangle>
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(0);

			var r:Rectangle = new Rectangle();
			r.x = pos.x - Globals.UIInt(175);
			r.y = pos.y - Globals.UIInt(175);
			r.width = Globals.UIInt(350);
			r.height = Globals.UIInt(350);

			return [r];
		}

		return null;
	}

	static public function showStartLevel_s1():Void
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(1);
			GameRegistry.popups.showArrowAt(pos);
		}

		var msg:String = 'Let’s take down another bad movie!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}


	static public function addTurns10_s0():Void
	{

		// turn on cost display, add 10 turns
		GameRegistry.game.setTurns(15);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialShowTurns();
			spg.disableGemWeight();
		}

		var cd:CardData;

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			for (i in 0...TutorialManager.FIRST_LEVEL_ADD_CARDS.length)
			{
				cd = GameRegistry.cards.getCardByID(TutorialManager.FIRST_LEVEL_ADD_CARDS[i]);
				spg.tutorialAddToHand(cd);
			}

			spg.tutorialEnableTips();
		}
		GameRegistry.resources.tutorialClearMana();
		TutorialV3.allowReleaseOnNoCards();
	}

	static public function allowReleaseOnNoCards():Void
	{
		GameRegistry.game.statePlayGame().setReleaseOnNoCards();
	}
	static public function addCards_s0():Void
	{
		// put 5 cards into the hand
		// 40: archeologist
		// 42: assassination plot
		// 57: boxing match
		// 62: business tycoon
		// 71: crispy baler
		// TutorialSteps.setupFilmStrip(null, null, [40, 42, 57, 62, 71]);

		var cd:CardData;

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			for (i in 0...TutorialManager.FIRST_LEVEL_ADD_CARDS.length)
			{
				cd = GameRegistry.cards.getCardByID(TutorialManager.FIRST_LEVEL_ADD_CARDS[i]);
				spg.tutorialAddToHand(cd);
			}
		}
		GameRegistry.resources.tutorialClearMana();

	}

	static public function promptAddLocation():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialSetMatchGemType(-1);
		}

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)),
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 4.5)));
		GameRegistry.popups.animatePointer(start, end, true);

		GameRegistry.popups.highlightRegions(addLocationRects());
		var msg:String = 'Now add the location to your movie!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT, false, 44);
	}

	public static function addLocationRects():Array<Rectangle>
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		var filmStrip:FilmStrip = spg.getFilmstrip();

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var seRect:Rectangle = filmStrip.seRect(4);
		seRect.x += filmStrip.x;
		seRect.y += filmStrip.y;
		seRect.height -= Globals.UIInt(20);

		/*
		var r1:Rectangle = new Rectangle();
		r1.x = handPos.x;
		r1.y = handPos.y;
		r1.width = Globals.UIInt(Card.CARD_WIDTH) + Globals.UIInt(8);
		r1.height = Globals.UIInt(Card.CARD_HEIGHT);
		*/

		var r1:Rectangle = new Rectangle();
		if (GameRegistry.hand != null)
		{
			r1 = GameRegistry.hand.getHighlightRect(0);
		}

		return [r1, seRect];
	}
	static public function showCardCosts_s0():Void
	{
		var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		p.x += Globals.UIInt(100);
		p.y += Globals.UIInt(130);
		// p.y += Std.int(Card.CARD_HEIGHT/5);
		GameRegistry.popups.showArrowAt(p, 1);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setMatchEnabled(true);
			spg.setGemWeight(1);
		}

		var msg:String = 'The gems you need to add a Cinebit are always shown right there. Match [GEM_LOCATION] BLUE gems to add it!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 44);
	}

	static public function showLocation_s0():Void
	{
		var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		GameRegistry.popups.showArrowAt(p, 1);

		// make the top plot slot flash
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// var p:IntPoint = GameRegistry.hand.getCardPosition(0);
			// GameRegistry.popups.showArrowAt(p, 1);

			spg.tutorialLockFilmstripSlot(-1);
			spg.tutorialSetMatchGemType(1);
		}

		TutorialSteps.disableMatch();

		GameRegistry.resources.tutorialClearMana();
	}

	static public function showAddActor_s0():Void
	{
		// make the top plot slot flash
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// var p:IntPoint = GameRegistry.hand.getCardPosition(0);
			// GameRegistry.popups.showArrowAt(p, 1);

			spg.tutorialLockFilmstripSlot(1);
			spg.tutorialSetMatchGemType(-1);
		}

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)),
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));
		GameRegistry.popups.animatePointer(start, end, true);

		var msg:String = 'You’ve got enough gems to spend on [ACTOR] now! Drag [GENDER] onto your film strip!';

		var cd:CardData = GameRegistry.hand.cardDataAt(0);
		if (cd != null)
		{
			msg = StringTools.replace(msg, '[ACTOR]', cd.cardName);

			if (cd.hasAttribute(Attributes.ATT_MALE))
			{
				msg = StringTools.replace(msg, '[GENDER]', 'him');
			}
			else
			{
				msg = StringTools.replace(msg, '[GENDER]', 'her');
			}
		}

		GameRegistry.popups.highlightRegions(addActorRects());
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 40);


	}

	public static function addActorRects():Array<Rectangle>
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		var filmStrip:FilmStrip = spg.getFilmstrip();

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var seRect:Rectangle = filmStrip.seRect(1);
		seRect.x += filmStrip.x;
		seRect.y += filmStrip.y;

		/*
		var r1:Rectangle = new Rectangle();
		r1.x = handPos.x;
		r1.y = handPos.y;
		r1.width = Globals.UIInt(Card.CARD_WIDTH) + Globals.UIInt(8);
		r1.height = Globals.UIInt(Card.CARD_HEIGHT);
		*/

		var r1:Rectangle = new Rectangle();
		if (GameRegistry.hand != null)
		{
			r1 = GameRegistry.hand.getHighlightRect(0);
		}

		return [r1, seRect];
	}

	static public function matchForActor():Void
	{
		var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		GameRegistry.popups.showArrowAt(p, 1);

		GameRegistry.resources.tutorialClearMana();

		var msg:String = 'Match enough [GEM_ACTOR] gems to add this ACTOR Cinebit to your film strip!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 46);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialSetMatchGemType(2);
			spg.setMatchEnabled(true);
			spg.setGemWeight(2);

		}
	}


	static public function showActorCard_s0():Void
	{
		var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		GameRegistry.popups.showArrowAt(p, 1);

		GameRegistry.resources.tutorialClearMana();

		var msg:String = 'Now check out this [GEM_ACTOR] ACTOR Cinebit here. Touch and hold to see details.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.setMatchEnabled(false);
		}
	}

	static public function showAddPlot_s0():Void
	{
		// make the top plot slot flash
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// var p:IntPoint = GameRegistry.hand.getCardPosition(0);
			// GameRegistry.popups.showArrowAt(p, 1);

			spg.tutorialLockFilmstripSlot(0);
			spg.tutorialSetMatchGemType(-1);
		}

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)),
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 0.5)));
		GameRegistry.popups.animatePointer(start, end, true);

		GameRegistry.popups.highlightRegions(addPlotRects());
		var msg:String = 'You’ve got enough gems to spend on your PLOT now! Drag it onto your film strip!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 40);

	}

	public static function addPlotRects():Array<Rectangle>
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		var filmStrip:FilmStrip = spg.getFilmstrip();

		var filmPos:Point = new Point();
		filmPos.x = filmStrip.x;
		filmPos.y = filmStrip.y;//GameRegistry.ui.getFilmStripPosition();
		var seRect:Rectangle = filmStrip.seRect(0);
		seRect.x += filmStrip.x;
		seRect.y += filmStrip.y;

		/*
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var r1:Rectangle = new Rectangle();
		r1.x = handPos.x + Globals.UIInt(4);
		r1.y = handPos.y;
		r1.width = Globals.UIInt(Card.CARD_WIDTH) + Globals.UIInt(30);
		r1.height = Globals.UIInt(Card.CARD_HEIGHT) + Globals.UIInt(26);
		*/

		var r1:Rectangle = new Rectangle();
		if (GameRegistry.hand != null)
		{
			r1 = GameRegistry.hand.getHighlightRect(0);
		}

		var r2:Rectangle = new Rectangle();
		r2.x = filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(4);
		r2.y = filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + Globals.UIInt(4);
		r2.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH);
		r2.height = FilmStrip.ELEMENT_HEIGHT;

		return [r1, seRect];
	}

	static public function promptMatchForPlot():Void
	{
		TutorialSteps.enableMatch();

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// spg.clearAllowedMatch();
			// spg.setMatchEnabled(true);
			spg.tutorialSetMatchGemType(3);
			spg.setGemWeight(3);
		}

		var msg:String = 'Match enough ORANGE gems to use this PLOT [GEM_PLOT] Cinebit and add it to your film strip!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false, 40);
	}

	static public function showFirstCard_s0():Void
	{
		TutorialSteps.setupFilmStrip(null, null, [TutorialManager.FIRST_LEVEL_START_PLOT,
												TutorialManager.FIRST_LEVEL_START_ACTOR,
												TutorialManager.FIRST_LEVEL_START_LOC]);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{

			spg.tutorialSetBoard([
				[2,3,1,2,3,4,1,1],
				[2,1,4,3,0,2,1,4],
				[3,0,1,2,1,0,2,3],
				[3,2,3,1,0,4,2,0],
				[1,3,4,1,4,0,1,2],
				[3,1,3,3,2,1,3,1]]
			);

			spg.setAllowedDraw(false);
			spg.tutorialLockCardInfo(true);
			// trace('LOCKED CARD INFO');
		}

		var p:IntPoint = GameRegistry.hand.getCardPosition(0);
		GameRegistry.popups.showArrowAt(p, 1);

		TutorialSteps.disableMatch();

		var msg:String = 'It’s time to create a movie! Let’s start by pressing this PLOT [GEM_PLOT] Cinebit here.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}

	static public function stageStart9():Void
	{
		// trace('SETTING UP STAGE 8');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);

	}

	static public function stageStart8():Void
	{
		// trace('SETTING UP STAGE 8');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart7():Void
	{
		// trace('SETTING UP STAGE 7');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart6():Void
	{
		// trace('SETTING UP STAGE 6');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);

	}

	static public function stageStart5():Void
	{
		// trace('SETTING UP STAGE 5');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart4():Void
	{
		// trace('SETTING UP STAGE 4');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart3():Void
	{
		// trace('SETTING UP STAGE 3');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart2():Void
	{
		// trace('SETTING UP STAGE 2');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart1():Void
	{
		// trace('SETTING UP STAGE 1');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	static public function stageStart0():Void
	{
		// trace('SETTING UP STAGE 0');
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);


	}
}

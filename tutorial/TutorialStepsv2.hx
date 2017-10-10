package com.jamwix.hs.tutorial;

import openfl.geom.Point;

import com.jamwix.hs.cards.Card;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.match.Gem;
import com.jamwix.hs.states.StatePlayGame;
import com.jamwix.hs.states.StateMapView;
import com.jamwix.hs.ui.popups.PopupDoc;
import com.jamwix.hs.ui.playgame.FilmStrip;
import com.jamwix.hs.tutorial.TutorialManager;
import com.jamwix.hs.tutorial.TutorialStepData;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.reviews.Critic;
import com.jamwix.hs.ui.popups.PopupArrow;
import com.jamwix.hs.ui.BankBar;

import com.jamwix.utils.IntPoint;
import com.jamwix.utils.JWUtils;

class TutorialSteps
{

	static public function debug():Void
	{
		trace('DEBUG DEBUG');
	}

	static public function showStore():Void
	{
		var p:IntPoint = new IntPoint(0,0);
		p.x = BankBar.BTN_STORE_X;
		p.y = BankBar.BTNS_Y;
		
		var pStart:IntPoint = new IntPoint(p.x, p.y);
		pStart.x -= Globals.UIInt(100);
		pStart.y += Globals.UIInt(100);

		// GameRegistry.popups.showArrowAt(p);
		GameRegistry.popups.animatePointer(pStart, p);			
	}

	static public function triggerRelease():Void
	{
		GameRegistry.popups.hideAll();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.showRelease(true, true);
		}		
	}

	static public function showImprovedRating():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var p:IntPoint = spg.getCinemeterPos();

			GameRegistry.popups.showArrowAt(p, 3); 
		}		

		var msg:String = 'Perfect! Using CineBits that work well together will lead to a better box office take.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function showSwapActors():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// TODO: disallow any film strip element other than the first
			spg.tutorialLockFilmstripSlot(0);
			disableMatch();
		}

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)), 
														Std.int(handPos.y + (Card.CARD_HEIGHT * 0.25)));
		
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + FilmStrip.ITEM_OFFSET_X),
										Std.int(filmPos.y + FilmStrip.ITEM_OFFSET_Y + (FilmStrip.ELEMENT_HEIGHT * 0.5)));
		GameRegistry.popups.animatePointer(start, end);			

	}

	static public function enableMatchHideInfo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();		
		if (spg != null)
		{
			spg.hideInfo();
			spg.setMatchEnabled(true);
			spg.tutorialLockCardInfo(false);
		}		
	}

	static public function showAltActorGenre():Void
	{
		// re-enable matching of all gems
		GameRegistry.resources.preventGemCredit(-1);


		// point at genre in card detail view
		var myX:Int = Globals.UIInt(1200);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
														Globals.UIInt(416)));
	}


	static public function showAltActor():Void
	{
		trace('SHOWING ALT ACTOR');
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialLockCardInfo(false);
			spg.hideInfo();
			spg.tutorialLockCardInfo(true);
		}		

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var p:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)), 
														Std.int(handPos.y + (Card.CARD_HEIGHT * 0.25)));
		
		GameRegistry.popups.showArrowAt(p);		
	}

	static public function showGenreMismatch():Void
	{

		// point at genre in filmstrip
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(filmPos.x + FilmStrip.ITEM_OFFSET_X + (FilmStrip.INTERIOR_WIDTH/2)),
													Globals.UIInt(94)));

		// point at genre in card detail view
		var myX:Int = Globals.UIInt(1220);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		

		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
															Globals.UIInt(712)));

		

		/*	
		var msg:String = 'Great Scott! Here’s the problem. You’re making a comedy, but this guy’s not so good at that.';
		GameRegistry.popups.addDocPopup(msg);
		*/
	}


	static public function showCardInfo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialLockCardInfo(true);
			spg.setMatchEnabled(false);			
		}	

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var p:IntPoint = new IntPoint(Std.int(filmPos.x + FilmStrip.ITEM_OFFSET_X + FilmStrip.INTERIOR_WIDTH * 0.2),
										Std.int(filmPos.y + FilmStrip.ITEM_OFFSET_Y + (FilmStrip.ELEMENT_HEIGHT * 0.5)));

		GameRegistry.popups.showArrowAt(p); 

		var msg:String = 'Let\'s get a better look at that card- press it for details';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}

	static public function showCinemeterDrop():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var p:IntPoint = spg.getCinemeterPos();

			GameRegistry.popups.showArrowAt(p, 3); 
		}		

		var msg:String = 'Oh no! The Cinemeter dropped! Let’s see what happened.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function dragFirstCard():Void
	{
		trace('DRAGGING FIRST CARD');
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 1.5)), 
														Std.int(handPos.y + (Card.CARD_HEIGHT * 0.25)));
		
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + FilmStrip.ITEM_OFFSET_X),
										Std.int(filmPos.y + FilmStrip.ITEM_OFFSET_Y + (FilmStrip.ELEMENT_HEIGHT * 2.5)));
		/*
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 7.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3.5)));
		*/
		GameRegistry.popups.animatePointer(start, end);			

		disableMatch();		
	}

	static public function pointAtPlot():Void
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 1.5)), 
														Std.int(handPos.y + (Card.CARD_HEIGHT * 0.25)));
		

		var end:IntPoint = new IntPoint(Std.int(start.x + (Card.CARD_WIDTH * 2.5)),
										start.y);
		/*
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 7.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3.5)));
		*/
		GameRegistry.popups.animatePointer(start, end);			

	}

	static public function startSecondLevel():Void
	{
		// add cards to the filmstrip
		// plot, character, 
		// leave: location, actor
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			// prevent any credit for stars while matching plot
			GameRegistry.resources.preventGemCredit(2);

			spg.tutorialSetBoard([
				[2,3,1,2,2,4,2,1],
				[0,1,4,3,1,1,2,4],
				[3,0,2,3,3,0,3,1],
				[3,2,3,1,2,4,2,0],
				[1,3,1,1,4,0,1,2],
				[4,1,2,3,3,1,3,0]]
			);

			spg.setMatchEnabled(true);


			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

			for (i in TutorialManager.LEVEL2_START_CARDS)
			{
				// cid = GameRegistry.cards.randCard(i);
				cd = GameRegistry.cards.getCardByID(i);
				trace('ADDING ' + cd.cardName + ' TO FILM');
				// _filmStrip.addItem(cd);
				spg.tutorialAddCardToFilmstrip(cd);

			}

			cd = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_ACTOR);
			spg.tutorialAddToHand(cd);

			cd = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_PLOT);
			spg.tutorialAddToHand(cd);

			spg.tutorialSetCinemeter(7);
		}

	}

	// stage 1, step 0
	static public function showStageButton():Void
	{
		// find the current location of the level 1 button

		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(0);
			GameRegistry.popups.showArrowAt(pos);
		}
	}	


	static public function showRelease():Void
	{
		
		GameRegistry.popups.hideAll();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.showRelease(true, true);
		}		

	}

	static public function matchLoc2():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);

			spg.setAllowedMatch([[2,0],[2,1]]);
		}

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 2.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 0.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 2.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 1.5)));

		GameRegistry.popups.animatePointer(start, end);			

	}


	static public function matchLoc1():Void
	{
		GameRegistry.resources.preventGemCredit(-1);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);

			spg.tutorialSetBoard([
				[2,3,1,2,2,4,2,1],
				[0,1,4,1,1,2,2,4],
				[3,0,2,3,3,0,3,0],
				[3,2,2,1,2,4,1,0],
				[1,3,1,1,4,0,1,2],
				[4,1,2,3,3,1,0,3]]
			);


			spg.setAllowedMatch([[5,5],[6,5]]);
		}

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 5.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 5.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 6.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 5.5)));

		GameRegistry.popups.animatePointer(start, end);			

	}

	static public function setDrawLocation():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();		
		if (spg != null)
		{			
			// spg.clearAllowedMatch();
			
			// set the three gems to match
			spg.tutorialSetGem(3, 1, 5);
			spg.tutorialSetGem(4, 0, 5);
			spg.tutorialSetGem(5, 1, 5);

			// prvent other matches from being possible
			spg.tutorialSetGem(2, 1, 5, true);
			spg.tutorialSetGem(6, 1, 5, true);
			spg.tutorialSetGem(3, 0, 5, true);
			spg.tutorialSetGem(5, 0, 5, true);
			spg.tutorialSetGem(4, 1, 5, true);


			spg.setAllowedMatch([[4,0],[4,1]]);
		
		}
		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.FIRST_LEVEL_LOCATION_ID);

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 0.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 1.5)));

		GameRegistry.popups.animatePointer(start, end);					
	}

	static public function showDragCard():Void
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)), 
														Std.int(handPos.y + (Card.CARD_HEIGHT * 0.25)));
		
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + FilmStrip.ITEM_OFFSET_X),
										Std.int(filmPos.y + FilmStrip.ITEM_OFFSET_Y + (FilmStrip.ELEMENT_HEIGHT * 2.5)));
		/*
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 7.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3.5)));
		*/
		GameRegistry.popups.animatePointer(start, end);			

		disableMatch();
	}

	static public function setStarMatch2():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);

			/* 
			set to star:
			7,2
			6,3
			7,4
			*/
			spg.tutorialSetGem(7, 2, 2);
			spg.tutorialSetGem(6, 3, 2);
			spg.tutorialSetGem(7, 4, 2);

			/*
			set to not star:
			6,1
			7,1
			6,2
			6,4
			6,5
			7,5
			7,3
			*/
			spg.tutorialSetGem(6, 1, 2, true);
			spg.tutorialSetGem(7, 1, 2, true);
			spg.tutorialSetGem(6, 2, 2, true);
			spg.tutorialSetGem(6, 4, 2, true);
			spg.tutorialSetGem(6, 5, 2, true);
			spg.tutorialSetGem(7, 5, 2, true);
			spg.tutorialSetGem(7, 3, 2, true);

			spg.setAllowedMatch([[6,3],[7,3]]);
		}

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 6.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 7.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3.5)));

		GameRegistry.popups.animatePointer(start, end);			
	}

	static public function setStarMatch1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);

			spg.setAllowedMatch([[0,5],[1,5]]);
		}

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 0.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 5.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 1.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 5.5)));

		GameRegistry.popups.animatePointer(start, end);			
	}

	static public function showMatchCinebox():Void
	{
		/*
			GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3))));
			GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 3)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3))));
		*/
		// _matchGame.setAllowedMatch([[3,3],[3,4]]);

		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.FIRST_LEVEL_ACTOR_ID);

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 1.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4.5)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 2.5)));

		GameRegistry.popups.animatePointer(start, end);	

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{		
			spg.setMatchEnabled(true);
		}

	}


	static public function setInitialMovie():Void
	{
		// add cards to the filmstrip
		// plot, character, 
		// leave: location, actor
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{		
			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

			for (i in TutorialManager.FIRST_LEVEL_START_CARDS)
			{
				cd = GameRegistry.cards.getCardByID(i);
				spg.tutorialAddCardToFilmstrip(cd);
			}

			// spg.setAllowedMatch(false);
			spg.setMatchEnabled(false);
		}

		// prevent any house matches from counting until they should
		GameRegistry.resources.preventGemCredit(1);

		var msg:String = 'This movie is off to a good start, but we need your help to finish it.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}


	static public function stageStart0():Void
	{
		// don't do anything
		trace('SETTING UP STAGE 0');
		// GameRegistry.game.setFilmGrade(0);
		GameRegistry.game.changeState(Globals.STATE_PLAY, true, true);
	}

	static public function disableMatch():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.setMatchEnabled(false);
		}		
	}

	static public function enableMatch():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.clearAllowedMatch();
			spg.setMatchEnabled(true);
		}		
	}

	static public function disableCardDraw():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.setAllowedDraw(false);
		}			
	}

	static public function enabledCardDraw():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.setAllowedDraw(true);
		}

	}

	// STUFF BELOW HERE WAS FOR TUTORIAL v1 //////////////////////////////////////////////////////////////////////

	static public function gotoMap():Void
	{
		GameRegistry.game.changeState(Globals.STATE_MAP);		
	}

	static public function stageStart2():Void
	{
		trace('STARTING STAGE 2');
		GameRegistry.game.changeState(Globals.STATE_MAP);		
	}

	static public function stageStart1():Void
	{
		// wait until the player is on the map
		trace('SETTING UP STAGE 1');
		GameRegistry.game.changeState(Globals.STATE_MAP);

	}

	static public function showLevelResults():Void
	{
		// [WIN] Doc: You did it! Wow! Great job! You’ve earned box office gold, a/some star(s) and a new CineBit for your collection! Let’s go there now...”
		// [LOSE] Doc: “Oh so very very close! But don’t worry, you grabbed tons more box office gold! Let’s give this stage another try, I know you’ll crush this cinematic dreck!”

		var msg:String;

		if (GameRegistry.game.lastGameWon)
		{
			msg = 'You did it! Wow! Great job! You’ve earned box office gold, ';
			msg += GameRegistry.game.lastGameStars + ' star';
			if (GameRegistry.game.lastGameStars > 1)
			{
				msg += 's';
			}
			msg += ' and a new CineBit for your collection! Let’s go there now...';
		}
		else
		{
			msg = 'Oh so very very close! But don’t worry, you grabbed tons more box office gold! Let’s give this stage another try, I know you’ll crush this cinematic dreck!';
		}

		var myX:Int = Std.int(1602/2);
		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(1602/2), 
													Std.int(96/2)));

		GameRegistry.popups.addDocPopup(msg);		

	}

	static public function showReleaseButton():Void
	{
		// 688 1024
		var myX:Int = Std.int(688/2);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
													Std.int(1024/2)));

		var msg:String = 'Time to release this movie and see what happens. Let’s hold our breath and see...';

		GameRegistry.popups.addDocPopup(msg);		
	}

	static public function showTurnsLeftFinal():Void
	{
		var turns:Int = GameRegistry.game.getTurnsRemaining();
		var msg:String = 'Only ';
		msg += turns;
		msg += ' turn';
		if (turns > 1)
		{
			msg += 's';
		}
		msg += ' left to create! Add any new CineBits you hope will make your movie better and pull out any that don’t work.';
	
		GameRegistry.popups.addDocPopup(msg);
	}

	static public function showTurnsLeftStage1():Void
	{
		var msg:String = 'You’ve got ';
		msg += GameRegistry.game.getTurnsRemaining();
		msg += ' turns left to keep collecting gems and adding CineBits. Experiment and see what happens. Don’t ever give up, you’ve got the power within you!';
	
		GameRegistry.popups.addDocPopup(msg);
	}

	static public function showFeedbackDetail():Void
	{
		var ratingIndex:Int = Critic.getTextRatingIndex();
		var genreStr:String = GameRegistry.game.posterDat.getGenreStr();

		var msg:String;

		// "average" or above
		if (ratingIndex >= 6)
		{
			msg = 'Great job! Keep adding more elements of ' + genreStr + ' to see your movie’s quality increase!';
		}
		else
		{
			msg = 'Try adding some more CineBits to see if they help. Otherwise you can always remove a CineBit that’s messing up your movie out just by pulling on it.';
		}

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function showFeedback():Void
	{

		var rating:String = Critic.getTextRating();

		var msg:String = 'According to the CineMeter, your movie is: ' + rating + ' so far';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);		

	}

	static public function showSynopsis():Void
	{
		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(1368/2), Std.int(1264/2)), PopupArrow.TOPRIGHT);

		var genreStr:String = GameRegistry.game.posterDat.getGenreStr();

		var msg:String = 'Okay now we have a movie started. It’s a ' + genreStr + ' movie and here’s the premise so far…';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function showTurnsRemaining():Void
	{
		var myX:Int = Std.int(1166/2);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
															Std.int(74/2)));

	}

	static public function showCinemeter():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var p:IntPoint = spg.getCinemeterPos();

			GameRegistry.popups.showArrowAt(p); 
		}			
		// var p:IntPoint = 

		/*
		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(1604/2), Std.int(1200/2)),
										PopupArrow.TOPRIGHT);
		*/


		// var msg:String = 'Add 3 more CineBits and let’s see how they change the movie! Watch the CineMeter as you add them to see what genre and how decent your movie is shaping up.';

		var msg:String = 'This will show you how well your movie is coming along. Use CineBits that work well together for a better movie';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function showGenre():Void
	{
		/*
		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(1480/2), 
															Std.int(1206/2)));
		*/

		var myX:Int = Std.int(1406/2);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
															Std.int(94/2)));

		// var msg:String = 'Add 3 more CineBits and let’s see how they change the movie! Watch the CineMeter as you add them to see what genre and how decent your movie is shaping up.';

		var msg:String = 'Watch the CineMeter as you add them to see what genre your movie is shaping up to be. Add 3 more CineBits and let’s see how they change the movie!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}

	static public function unlockDrag():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialLockCardInfo(false);
			spg.setMatchEnabled(true);
			spg.tutorialSetDrag(true);			
		}		
	}

	static public function showGenres():Void
	{
		var myX:Int = Std.int(1220/2);
		if (Globals.IS_WIDE) myX += Std.int(683/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
															Std.int(496/2)));

		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
															Std.int(752/2)));
	}

	static public function showCardType():Void
	{
		trace('SHOW CARD TYPE');
		
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			var cd:CardData = spg.tutorialGetCurrCardInfo();

			if (cd != null)
			{
				trace('DETAILS FOR ' + cd.cardName);
				var costs:Array<Int> = cd.getCosts();
				var cost:Int = 0;
				for (i in 0...costs.length)
				{
					if (costs[i] > cost)
					{
						cost = costs[i];
					}
				}

				var msg:String = 'This is a ';
				msg += CardData.TYPE_NAMES[cd.cardType];
				msg += ' type CineBit. It’ll add this ';
				msg += CardData.TYPE_NAMES_NOUN[cd.cardType];
				msg += ' to your story for just ';
				msg += cost;
				msg += ' gem';
				if (cost > 1)
				{
					msg += 's';
				}
				'.';
				trace(msg);
				GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT);
			}
		}		
	}

	static public function showDrawnCard():Void
	{
		var pos:IntPoint = new IntPoint(0, 0);
		pos.x = Std.int(170/2);
		if (Globals.IS_WIDE) pos.x += Std.int(683/2);
		pos.y = Std.int(1276/2);
		GameRegistry.popups.showArrowAt(pos);

		var msg:String = 'Tap that CineBit to see what the deal is with it.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT);

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.setMatchEnabled(false);
			/// make the card info display stay up
			spg.tutorialLockCardInfo(true);
			spg.tutorialSetDrag(false);
		}
	}

	static public function showPlayButton():Void
	{
		var pos:IntPoint = new IntPoint(0, 0);
		pos.x = Std.int(1260/2);
		if (Globals.IS_WIDE) pos.x += Std.int(683/2);
		pos.y = Std.int(1408/2);
		GameRegistry.popups.showArrowAt(pos);

		var msg:String = 'Let’s defeat this soul-sucking piece of bland moviemaking- press PLAY!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT);

	}

	// stage 1, step 2
	static public function showBadMovie():Void
	{
		var pos:IntPoint = new IntPoint(0, 0);
		pos.x = Std.int(610/2);
		if (Globals.IS_WIDE) pos.x += Std.int(683/2);
		pos.y = Std.int(704/2);
		GameRegistry.popups.showArrowAt(pos);

		var msg:String = 'This is the bad movie you must defeat at the box office to win the stage! Fortunately, it’s not expected to make much.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}

	// stage 1, step 1
	static public function showSlider():Void
	{
		var pos:IntPoint = new IntPoint(0, 0);
		pos.x = Std.int(1440/2);
		if (Globals.IS_WIDE) pos.x += Std.int(683/2);
		pos.y = Std.int(1178/2);
		GameRegistry.popups.showArrowAt(pos);

		var msg:String = 'That slider controls how much you want to spend on your film’s budget. The higher you go, the more powerful CineBits you’ll have when you play!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPRIGHT);
	}	





	static public function step_0_0_Pre():Void
	{
		/*
		trace('STARTING STAGE 0');
		GameRegistry.game.setFilmGrade(0);
		GameRegistry.game.changeState(Globals.STATE_PLAY);
		*/
	}	

	static public function showMatch():Void
	{


		trace('TutorialSteps::showMatch');
		var matchPos:Point = GameRegistry.ui.getMatchGamePos();

		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4)), 
													Std.int(matchPos.y + (Gem.GEM_SIZE * 3.7))));
		GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4)), 
													Std.int(matchPos.y + (Gem.GEM_SIZE * 4.7))));

	}

	static public function showGemCredit():Void
	{

		trace('SHOWING GEM CREDIT');
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			var pos:IntPoint = spg.getBankPos();
			GameRegistry.popups.showArrowAt(pos);

			spg.setMatchEnabled(false);

			trace('ADDED ARROW');			
		}

	}

	static public function showCardMatch():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.tutorialSetBoard([
				[2,3,1,2,5,4,2,1],
				[0,1,4,3,5,1,2,4],
				[1,0,2,5,2,0,3,1],
				[4,2,4,3,2,4,2,0],
				[1,3,1,1,4,0,1,2],
				[4,1,2,2,3,1,0,3]]
			);

			spg.setMatchEnabled(true);

			spg.setAllowedMatch([[3,2],[4,2]]);

			var matchPos:Point = GameRegistry.ui.getMatchGamePos();

			GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 4)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3))));
			GameRegistry.popups.showArrowAt(new IntPoint(Std.int(matchPos.x + (Gem.GEM_SIZE * 3)), 
														Std.int(matchPos.y + (Gem.GEM_SIZE * 3))));

		}		
	}

	static public function showTurnsLeft():Void
	{
		var msg:String = 'Keep playing! You’ve got ';
		msg += GameRegistry.game.getTurnsRemaining();
		msg += ' turns left till you have to release.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT);
	}

	static public function showMovieResult():Void
	{
		var msg:String = 'Great job! Your movie earned you ';
		// msg += GameRegistry.game.profit;
		msg += '$' + JWUtils.digitsToWords(GameRegistry.game.moneyMade, false);
		msg += ' in box office gold!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT);

	}



	static public function hideDoc():Void
	{
		GameRegistry.popups.hideDoc();
	}

	static public function clearAllowedMatch():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.clearAllowedMatch();
		}			
	}
}

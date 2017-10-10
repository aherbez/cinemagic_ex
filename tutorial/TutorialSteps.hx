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
import com.jamwix.hs.tutorial.TutorialManager;
import com.jamwix.hs.tutorial.TutorialStepData;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.reviews.Critic;
import com.jamwix.hs.ui.popups.PopupArrow;
import com.jamwix.hs.ui.BankBar;
import com.jamwix.hs.ui.popups.PopupStarSelect;
import com.jamwix.hs.ui.GreenButton;
import com.jamwix.hs.levels.Level;

import com.jamwix.utils.IntPoint;
import com.jamwix.utils.JWUtils;

/*

This file contains general functions used more than once in the tutorial, such as enabling / disabling matches, card draw, etc 

For individual tutorial steps, see TutorialVX.hx (X being number of current tutorial)

*/
class TutorialSteps
{

	static public function setupFilmStrip(?cards:Array<Int> = null, ?lockedCards:Array<Int> = null, ?cardsInHand:Array<Int> = null):Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			var cd:CardData;
			
			if (cards != null)
			{
				for (cid in cards)
				{
					cd = GameRegistry.cards.getCardByID(cid);

					if (cd != null)
					{
						spg.tutorialAddCardToFilmstrip(cd);
					}
				}
			}

			if (lockedCards != null)
			{
				for (cid in lockedCards)
				{
					cd = GameRegistry.cards.getCardByID(cid);

					if (cd != null)
					{
						trace('ADDING LOCKED CARD: ' + cd.cardName);
						spg.tutorialAddCardToFilmstrip(cd, true);
					}
				}
			}

			if (cardsInHand != null)
			{
				var cd:CardData;
				for (cid in cardsInHand)
				{
					cd = GameRegistry.cards.getCardByID(cid);
					spg.tutorialAddToHand(cd);
				}
			}
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
			spg.tutorialLockCardInfo(false);
		}		
	}		

	static public function cacheHighlight(rectFunc:Void->Array<Rectangle>):Void
	{
		if (rectFunc == null) return;
		var rects:Array<Rectangle> = rectFunc();
		GameRegistry.highlightMaker.loadHighlight(rects, function (highlight:Sprite) {
			if (highlight == null) return;
			var id:String = JWUtils.rectsId(rects);
			GameRegistry.popups.cacheHighlight(id, highlight);
		});
	}

	static public function hideCardInfo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();

		if (spg != null)
		{
			spg.tutorialLockCardInfo(false);
		}		
	}

	/*
	static public function setupMovieStage4():Void
	{
		trace('SETTING UP LEVEL 4');
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

//			for (i in TutorialManager.LEVEL5_START_CARDS)
//			{
//				cd = GameRegistry.cards.getCardByID(i);
//				spg.tutorialAddCardToFilmstrip(cd);
//			}
//
//			for (i in TutorialManager.LEVEL5_START_HAND)
//			{
//				// cid = GameRegistry.cards.randCard(i);
//				cd = GameRegistry.cards.getCardByID(i);
//				// spg.tutorialAddCardToFilmstrip(cd);
//				spg.tutorialAddToHand(cd);
//			}		

		}
	}

	static public function stageStart4():Void
	{
		GameRegistry.game.changeState(Globals.STATE_MAP);
	}

	static public function setupMovieStage3():Void
	{
		trace('SETTING UP LEVEL 3');
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

//			for (i in TutorialManager.LEVEL4_START_CARDS)
//			{
//				cd = GameRegistry.cards.getCardByID(i);
//				spg.tutorialAddCardToFilmstrip(cd);
//			}
//
//			for (i in TutorialManager.LEVEL4_START_HAND)
//			{
//				// cid = GameRegistry.cards.randCard(i);
//				cd = GameRegistry.cards.getCardByID(i);
//				// spg.tutorialAddCardToFilmstrip(cd);
//				spg.tutorialAddToHand(cd);
//			}			

		}
	}

	static public function stageStart3():Void
	{
		GameRegistry.game.changeState(Globals.STATE_MAP);
	}

	static public function setupMovieStage2():Void
	{
		trace('SETTING UP LEVEL 2');
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{		
			spg.tutorialSetBoard([
				[3,2,1,3,2,4,0,1],
				[0,1,4,2,0,3,1,4],
				[2,0,0,3,3,0,3,3],
				[2,3,2,1,0,4,0,0],
				[1,2,4,1,4,0,1,3],
				[2,1,2,2,0,1,2,0]]
			);

			spg.setMatchEnabled(true);

			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

//			for (i in TutorialManager.LEVEL3_START_CARDS)
//			{
//				cd = GameRegistry.cards.getCardByID(i);
//				spg.tutorialAddCardToFilmstrip(cd);
//			}
//
//			for (i in TutorialManager.LEVEL3_START_HAND)
//			{
//				// cid = GameRegistry.cards.randCard(i);
//				cd = GameRegistry.cards.getCardByID(i);
//				// spg.tutorialAddCardToFilmstrip(cd);
//				spg.tutorialAddToHand(cd);
//			}		
			
		}
	}

	static public function stageStart2():Void
	{
		trace('SETTING UP STAGE 1');
		GameRegistry.game.changeState(Globals.STATE_MAP);

	}

	static public function showReleaseLvl2():Void
	{		
		GameRegistry.popups.hideAll();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.showRelease(true, true);
		}		

		var msg:String = 'Let’s Release this movie!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}	


	static public function docTest():Void
	{
		var msg:String = 'FOOBAR';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);
	}

	static public function showImprovedRating():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{

			spg.tutorialSetCinemeter(10);

			var r:Rectangle = spg.getCinemeterPos();
			r.x -= (r.width * 0.1);
			r.y -= (r.height * 0.1);
			r.width = r.width * 1.2;
			r.height = r.height * 1.2;

			var p:IntPoint = new IntPoint(0, 0);
			p.x = Std.int(r.x + r.width * 0.2);
			p.y = Std.int(r.y + r.height * 0.5);

			if (Globals.IS_WIDE) p.x -= Std.int(Globals.WOFF/2);

			GameRegistry.popups.highlightRegions(ratingHighlightRects());
			GameRegistry.popups.showArrowAt(p, 3);

		}		

		var msg:String = 'Perfect! Your movie looks Great! Using cinebits that work well together will lead to bigger Box Office takes.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

	}

	static public function ratingHighlightRects():Array<Rectangle>
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

	static public function loadRatingHighlight():Void
	{
		cacheHighlight(ratingHighlightRects);
	}

	static private function cacheHighlight(rectFunc:Void->Array<Rectangle>):Void
	{
		if (rectFunc == null) return;
		var rects:Array<Rectangle> = rectFunc();
		GameRegistry.highlightMaker.loadHighlight(rects, function (highlight:Sprite) {
			if (highlight == null) return;
			var id:String = JWUtils.rectsId(rects);
			GameRegistry.popups.cacheHighlight(id, highlight);
		});
	}

	static public function showAddCharacter():Void
	{
		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_CHARACTER);
		var cd2:CardData = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_ACTOR);

		var msg:String = 'Now add the ' + cd.cardName + ' CHARACTER to ' + cd2.cardName + ' to make your movie even more action packed!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

	}

	static public function showMatchCharacter():Void
	{
		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_CHARACTER);

		var msg:String = 'Match purple to unlock the ' + cd.cardName + ' character!';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT);

		GameRegistry.resources.tutorialClearMana();

		enableMatch();

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// spg.tutorialSetMatchGemType(0);

			spg.tutorialSetBoard([
				[3,0,1,3,3,4,3,1],
				[0,1,4,2,1,1,3,4],
				[2,0,3,2,2,0,2,1],
				[2,3,2,1,3,4,0,0],
				[1,0,1,1,4,0,1,3],
				[0,1,0,2,2,1,2,0]]
			);			
		}
	}

	static public function showSwapActors():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			// TODO: disallow any film strip element other than the first
			spg.tutorialLockFilmstripSlot(1);
			disableMatch();

			spg.tutorialLockRating(-1, false);
		}

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Card.CARD_WIDTH * 0.5)), 
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));
		
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.5),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 1.5)));
		GameRegistry.popups.animatePointer(start, end);	

		GameRegistry.popups.highlightRegions(swapActorRects());

		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_ACTOR);

		var msg:String = 'Now drag ' + cd.cardName + ' onto Carry to replace him.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);


		loadRatingHighlight();
	}
	public static function loadSwapActorHighlight():Void
	{
		cacheHighlight(swapActorRects);
	}

	public static function swapActorRects():Array<Rectangle>
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var r1:Rectangle = new Rectangle();
		r1.x = handPos.x;
		r1.y = handPos.y;
		r1.width = Globals.UIInt(Card.CARD_WIDTH);
		r1.height = Globals.UIInt(Card.CARD_HEIGHT);

		var r2:Rectangle = new Rectangle();
		r2.x = filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X);
		r2.y = filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + FilmStrip.ELEMENT_HEIGHT + Globals.UIInt(8);
		r2.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH);
		r2.height = FilmStrip.ELEMENT_HEIGHT;

		return [r1, r2];
	}


	static public function enableMatchHideInfo():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();		
		if (spg != null)
		{
			// trace('ENABLING MATCHES');
			spg.tutorialLockCardInfo(false);
			spg.hideInfo();
			spg.setMatchEnabled(true);
			
		}		
	}

	static public function showAltActorGenre():Void
	{
		// re-enable matching of all gems
		GameRegistry.resources.preventGemCredit(-1);


		// point at genre in card detail view
		var myX:Int = Globals.UIInt(1180);
		if (Globals.IS_WIDE) myX += Std.int(Globals.WOFF/2);
		GameRegistry.popups.showArrowAt(new IntPoint(myX, 
														Globals.UIInt(416)));
	
		GameRegistry.popups.highlightRegions(altActorHighlightRects());

		loadSwapActorHighlight();
	}

	static public function altActorHighlightRects():Array<Rectangle>
	{
		var r:Rectangle = new Rectangle();
		r.x = Globals.UIInt(898);
		if (Globals.IS_WIDE) r.x += Std.int(Globals.WOFF/2);
		r.y = Globals.UIInt(346);
		r.width = Globals.UIInt(350);
		r.height = Globals.UIInt(114);

		return [r];
	}

	static public function loadAltActorHighlight():Void
	{
		cacheHighlight(altActorHighlightRects);
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

			spg.tutorialLimitInfo(TutorialManager.LEVEL2_DRAW_ACTOR);
		}		

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var p:IntPoint = new IntPoint(Std.int(handPos.x + (Globals.UIInt(Card.CARD_WIDTH) * 0.5)), 
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));
			
		GameRegistry.popups.highlightRegions(showAltActorRects());

		GameRegistry.popups.showArrowAt(p);	

		// make sure we use the name of the card as it appears to the player
		var cd:CardData = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_ACTOR);

		var msg:String = 'See if ' + cd.cardName + ' is any better. Touch and hold to see his details.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT, false);

		loadAltActorHighlight();
	}

	static public function showAltActorRects():Array<Rectangle>
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
			
		var r:Rectangle = new Rectangle();
		r.x = handPos.x;
		r.y = handPos.y;
		r.width = Globals.UIInt(Card.CARD_WIDTH);
		r.height = Globals.UIInt(Card.CARD_HEIGHT);

		return [r];
	}

	static public function loadShowAltActorHighlight():Void
	{
		cacheHighlight(showAltActorRects);
	}

	static public function showGenreMismatch():Void
	{
		// point at genre in filmstrip
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		
		// var r:Rectangle = new Rectangle();
		// r.x = filmPos.x + Globals.UIInt(50);
		// r.y = Globals.UIInt(14);
		// r.width = Globals.UIInt(608);
		// r.height = Globals.UIInt(106);

		// var r2:Rectangle = new Rectangle();
		// r2.x = Globals.UIInt(918);
		// if (Globals.IS_WIDE) r2.x += Std.int(Globals.WOFF/2);
		// r2.y = Globals.UIInt(648) + Globals.UIInt(196);
		// r2.width = Globals.UIInt(350);
		// r2.height = Globals.UIInt(114);

		// point at genre in card detail view
		var genreX:Int = Globals.UIInt(1200);
		if (Globals.IS_WIDE) genreX += Std.int(Globals.WOFF/2);

		GameRegistry.popups.highlightRegions(genreMistmatchRects());

		
		// GameRegistry.popups.showArrowAt(new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) + (Globals.UIInt(FilmStrip.INTERIOR_WIDTH)/2)),
		// 											Globals.UIInt(94)));
		

		// arrow at genre label
		var arrowX:Int = Std.int(filmPos.x + Globals.UIInt(FilmStrip.filmStripWidth)/2); 
		var arrowY:Int = Globals.HEIGHT - Std.int(Globals.UIInt(108) * 0.75);
		GameRegistry.popups.showArrowAt(new IntPoint(arrowX, arrowY), PopupArrow.BOTLEFT);

		// arrow at "action"
		GameRegistry.popups.showArrowAt(new IntPoint(genreX, Globals.UIInt(876)));

		var msg:String = 'Great Scott! Here’s the problem. You’re making an action movie, but this actor’s not so good at that.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

		loadShowAltActorHighlight();
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

	static public function loadMismatchHighlight():Void
	{
		cacheHighlight(genreMistmatchRects);
	}

	static public function showActor():Void
	{
		
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.tutorialLockCardInfo(true);
			spg.setMatchEnabled(false);		

			// limit info to McChillen
			spg.tutorialLimitInfo(TutorialManager.LEVEL2_START_CARDS[0]);	
		}	
		

		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();
		var p:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X)),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y)));

		GameRegistry.popups.highlightRegions(showActorRects());

		p.x = Std.int(p.x + Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.2);
		p.y = Std.int(p.y + FilmStrip.ELEMENT_HEIGHT * 1.5);
		GameRegistry.popups.showArrowAt(p, 2); 

		var msg:String = 'Touch and hold on this Actor to see his details';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT, false);
		
		loadMismatchHighlight();
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
		cacheHighlight(showActorRects);
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
				[3,2,1,3,3,4,3,1],
				[0,1,4,2,1,1,3,4],
				[2,0,3,2,2,0,2,1],
				[2,3,2,1,3,4,3,0],
				[1,2,1,1,4,0,1,3],
				[4,1,3,2,2,1,2,0]]
			);

			spg.setMatchEnabled(true);


			var typesToAdd:Array<Int> = [CardData.TYPE_PLOT, CardData.TYPE_CHARACTER];
			var cid:Int;
			var cd:CardData;

			for (i in TutorialManager.LEVEL2_START_CARDS)
			{
				// cid = GameRegistry.cards.randCard(i);
				cd = GameRegistry.cards.getCardByID(i);
				// _filmStrip.addItem(cd);
				spg.tutorialAddCardToFilmstrip(cd);

			}

			cd = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_ACTOR);
			spg.tutorialAddToHand(cd);

			cd = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_CHARACTER);
			spg.tutorialAddToHand(cd);
			
			
			// cd = GameRegistry.cards.getCardByID(TutorialManager.LEVEL2_DRAW_PLOT);
			// spg.tutorialAddToHand(cd);
			

			spg.tutorialSetCinemeter(3);

			spg.tutorialLockGenre(CardData.GENRE_ACTION, false);
			spg.tutorialLockRating(0.2, true);

			GameRegistry.popups.highlightRegions(startSecondRects());

		}

		var msg:String = 'Looks like this movie is in trouble. Let’s find out why.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

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

	static public function loadStartSecondHighlight():Void
	{
		cacheHighlight(startSecondRects);
	}

	static public function showToBeat():Void
	{
		GameRegistry.popups.highlightRegions(toBeatRects());

		var level:Level = GameRegistry.levels.currLevel();
		var toBeatMil:Int = level.beatScores[0];

		var msg:String = 'Now make a movie that earns more than $' + toBeatMil + ' Million.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_TOPLEFT);

		loadPlayHighlight();
	}

	static public function toBeatRects():Array<Rectangle>
	{
		var r:Rectangle = new Rectangle();
		r.x = Globals.UIInt(1116);
		if (Globals.IS_WIDE) 
		{
			r.x += Std.int(Globals.WOFF/2);
		}
		r.y = Globals.UIInt(1058);
		if (Globals.RETINA)
		{
			r.y += Globals.UIInt(50);
		}
		r.width = Globals.UIInt(539);
		r.height = Globals.UIInt(130);

		return [r];
	}

	static public function loadToBeatHighlight():Void
	{
		cacheHighlight(toBeatRects);
	}

	static public function showStartLevel():Void
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(1);
			GameRegistry.popups.highlightRegions(showStartRects());
			GameRegistry.popups.showArrowAt(pos);
		}

		var msg:String = 'Touch the marker to start a level!';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);		

		loadToBeatHighlight();
	}

	static public function showStartRects():Array<Rectangle>
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		if (smv != null)
		{
			var pos:IntPoint = smv.getLevelLoc(1);
			
			var r:Rectangle = new Rectangle();
			r.x = pos.x - Globals.UIInt(175);
			r.y = pos.y - Globals.UIInt(175);
			r.width = Globals.UIInt(350);
			r.height = Globals.UIInt(350);

			return [r];
		}

		return null;
	}

	static public function loadShowStartHighlight():Void
	{
		cacheHighlight(showStartRects);
	}

	static public function stageStart1():Void
	{
		trace('SETTING UP STAGE 1');
		GameRegistry.game.changeState(Globals.STATE_MAP);
	}

	static public function showDocResponse():Void
	{
		GameRegistry.popups.addDocPopup('The Fans love it! It’s a blockbuster hit!', PopupDoc.CORNER_BOTLEFT, false);
	}

	static public function showRelease():Void
	{		
		GameRegistry.popups.hideAll();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{
			spg.showRelease(true, true);
		}		

		GameRegistry.popups.addDocPopup('Great! Your movie is ready to release!', 
										 PopupDoc.CORNER_BOTRIGHT, false);
	}

	static public function showDragCardLoc():Void
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		GameRegistry.popups.highlightRegions(showDragRects());

		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Globals.UIInt(Card.CARD_WIDTH) * 0.5)), 
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));
		
		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X)),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 4.5)));
		end.x += Globals.UIInt(300);
		GameRegistry.popups.animatePointer(start, end);			

		disableMatch();

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			spg.tutorialLockFilmstripSlot(4);
			spg.tutorialSetMatchGemType(-1);
		}	


		GameRegistry.popups.addDocPopup('Perfect, now add the location to your movie.',
										PopupDoc.CORNER_TOPRIGHT, false);
	}	

	static public function showDragRects():Array<Rectangle>
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var startR:Rectangle = new Rectangle();
		startR.x = handPos.x;
		startR.y = handPos.y;
		startR.width = Globals.UIInt(Card.CARD_WIDTH);
		startR.height = Globals.UIInt(Card.CARD_HEIGHT);

		var endR:Rectangle = new Rectangle();
		endR.x = filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) - (Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.1);
		endR.y = filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 4.1);
		endR.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 1.2;
		endR.height = FilmStrip.ELEMENT_HEIGHT * 1.2;

		return [startR, endR];
	}

	static public function loadShowDragHighlight():Void
	{
		cacheHighlight(showDragRects);
	}

	static public function matchForLocation():Void
	{
		
		enableMatch();
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();		
		if (spg != null)
		{
			spg.tutorialSetMatchGemType(1);
			
			spg.tutorialSetBoard([[4,3,3,0,1,4,2,0],
									[2,3,1,1,5,4,3,4],
									[5,0,4,3,4,0,3,4],
									[2,1,3,0,2,3,1,1],
									[0,0,1,4,3,0,1,4],
									[4,1,3,0,2,1,5,3]]);
		}

		GameRegistry.resources.tutorialClearMana();

	}

	static public function readyLocationDraw():Void
	{
		disableCardDraw();
		// GameRegistry.resources.reset();
		GameRegistry.resources.tutorialClearMana();

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

			// prevent other matches from being possible
			spg.tutorialSetGem(2, 1, 5, true);
			spg.tutorialSetGem(6, 1, 5, true);
			spg.tutorialSetGem(3, 0, 5, true);
			spg.tutorialSetGem(5, 0, 5, true);
			spg.tutorialSetGem(4, 1, 5, true);


			spg.setAllowedMatch([[4,0],[4,1]], 5);
		
		}
		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.FIRST_LEVEL_LOCATION_ID);

		GameRegistry.popups.highlightRegions(drawLocationRects());

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 4.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 0.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 4.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 1.5)));

		// only allow houses to be matched
		// turn off lock preventing houses from being matched
		GameRegistry.resources.preventGemCredit(-1);

		GameRegistry.popups.animatePointer(start, end);	

		GameRegistry.popups.addDocPopup('Let’s see what’s in these cineboxes.',
										PopupDoc.CORNER_BOTRIGHT, false);				

		loadShowDragHighlight();
	}

	static public function drawLocationRects():Array<Rectangle>
	{
		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var r:Rectangle = new Rectangle();
		r.x = matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 2.9);
		r.y = matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * -0.1);
		r.width = Globals.UIInt(Gem.GEM_SIZE) * 3.2;
		r.height = Globals.UIInt(Gem.GEM_SIZE) * 2.2;

		return [r];
	}

	static public function loadDrawLocationHighlight():Void
	{
		cacheHighlight(drawLocationRects);
	}

	static public function showDragCard():Void
	{

		GameRegistry.popups.highlightRegions(showDragCardRects());

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{	
			spg.tutorialLockFilmstripSlot(3);
			spg.tutorialSetMatchGemType(-1);
		}	

		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var start:IntPoint = new IntPoint(Std.int(handPos.x + (Globals.UIInt(Card.CARD_WIDTH) * 0.5)), 
														Std.int(handPos.y + (Globals.UIInt(Card.CARD_HEIGHT) * 0.25)));
		
		var end:IntPoint = new IntPoint(Std.int(filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X)),
										Std.int(filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 3.5)));
		end.x += Globals.UIInt(300);
		GameRegistry.popups.animatePointer(start, end);			


		disableMatch();

		GameRegistry.popups.addDocPopup('Perfect, now drag her to the filmstrip to cast her in your movie.',
										PopupDoc.CORNER_BOTRIGHT, false);

		loadDrawLocationHighlight();
	}

	static public function showDragCardRects():Array<Rectangle>
	{
		var handPos:Point = GameRegistry.ui.getHandDisplayPos();
		var filmPos:Point = GameRegistry.ui.getFilmStripPosition();

		var startR:Rectangle = new Rectangle();
		startR.x = handPos.x;
		startR.y = handPos.y;
		startR.width = Globals.UIInt(Card.CARD_WIDTH);
		startR.height = Globals.UIInt(Card.CARD_HEIGHT);

		var endR:Rectangle = new Rectangle();
		endR.x = filmPos.x + Globals.UIInt(FilmStrip.ITEM_OFFSET_X) - (Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 0.1);
		endR.y = filmPos.y + Globals.UIInt(FilmStrip.ITEM_OFFSET_Y) + (FilmStrip.ELEMENT_HEIGHT * 3.1);
		endR.width = Globals.UIInt(FilmStrip.INTERIOR_WIDTH) * 1.2;
		endR.height = FilmStrip.ELEMENT_HEIGHT * 1.2;

		return [startR, endR];
	}

	static public function loadShowDragCardHighlight():Void
	{
		cacheHighlight(showDragCardRects);
	}

	static public function setStarMatch2():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);

			
			// set to star:
			// 7,2
			// 6,3
			// 7,4
			
			spg.tutorialSetGem(7, 2, 2);
			spg.tutorialSetGem(6, 3, 2);
			spg.tutorialSetGem(7, 4, 2);

			
			// set to not star:
			// 6,1
			// 7,1
			// 6,2
			// 6,4
			// 6,5
			// 7,5
			// 7,3
			
			spg.tutorialSetGem(6, 1, 2, true);
			spg.tutorialSetGem(7, 1, 2, true);
			spg.tutorialSetGem(6, 2, 2, true);
			spg.tutorialSetGem(6, 4, 2, true);
			spg.tutorialSetGem(6, 5, 2, true);
			spg.tutorialSetGem(7, 5, 2, true);
			spg.tutorialSetGem(7, 3, 2, true);

			spg.setAllowedMatch([[6,3],[7,3]], 2);
		}

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		GameRegistry.popups.highlightRegions(starMatch2Rects());

		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 6.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 3.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 7.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 3.5)));

		GameRegistry.popups.animatePointer(start, end);	

		GameRegistry.popups.addDocPopup('Great, you’re half way there!', PopupDoc.CORNER_BOTRIGHT, false);		
		loadShowDragCardHighlight();
	}

	static public function starMatch2Rects():Array<Rectangle>
	{
		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var r:Rectangle = new Rectangle();
		r.x = matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 5.9);
		r.y = matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 1.9);
		r.width = Globals.UIInt(Gem.GEM_SIZE) * 2.2;
		r.height = Globals.UIInt(Gem.GEM_SIZE) * 3.2;

		return [r];
	}

	static public function loadStarMatch2Highlight():Void
	{
		cacheHighlight(starMatch2Rects);
	}

	static public function setStarMatch1():Void
	{
		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{			
			spg.setMatchEnabled(true);
			spg.setAllowedMatch([[0,5],[1,5]], 2);
		}

		GameRegistry.popups.highlightRegions(starMatch1Rects());


		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 0.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 5.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 1.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 5.5)));

		GameRegistry.popups.animatePointer(start, end);	

		GameRegistry.popups.addDocPopup('Great! You have an actor, but you\'ll need 6 star gems to add her to your movie.',
										PopupDoc.CORNER_BOTRIGHT, false);		

		loadStarMatch2Highlight();
	}

	static public function starMatch1Rects():Array<Rectangle>
	{
		var matchPos:Point = GameRegistry.ui.getMatchGamePos();

		var r:Rectangle = new Rectangle();
		r.x = matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * -0.1);
		r.y = matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 2.9);
		r.width = Globals.UIInt(Gem.GEM_SIZE) * 2.2;
		r.height = Globals.UIInt(Gem.GEM_SIZE) * 3.2;

		return [r];
	}

	static public function loadStarMatch1Highlight():Void
	{
		cacheHighlight(starMatch1Rects);
	}

	static public function showCineboxMatch1():Void
	{
		GameRegistry.deck.tutorialSetNextDraw(TutorialManager.FIRST_LEVEL_ACTOR_ID);

		GameRegistry.popups.highlightRegions(match1HighlightRects());

		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var start:IntPoint = new IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 4.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 1.5)));
		var end:IntPoint = new 	IntPoint(Std.int(matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 4.5)), 
														Std.int(matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 2.5)));

		GameRegistry.popups.animatePointer(start, end);	

		var spg:StatePlayGame = GameRegistry.game.statePlayGame();
		if (spg != null)
		{		
			spg.setMatchEnabled(true);
		}

		var msg:String = 'Match the green cineboxes to see if you can find one.';
		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTRIGHT, false);

		loadStarMatch1Highlight();
	}

	static public function match1HighlightRects():Array<Rectangle>
	{
		var matchPos:Point = GameRegistry.ui.getMatchGamePos();
		var r:Rectangle = new Rectangle();
		r.x = matchPos.x + (Globals.UIInt(Gem.GEM_SIZE) * 1.9);
		r.y = matchPos.y + (Globals.UIInt(Gem.GEM_SIZE) * 0.9);
		r.width = Globals.UIInt(Gem.GEM_SIZE) * 3.2;
		r.height = Globals.UIInt(Gem.GEM_SIZE) * 2.2;

		return [r];
	}

	static public function loadMatch1Highlight():Void
	{
		cacheHighlight(match1HighlightRects);
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

			// we're in the first part of the tutorial, draw two cards
			GameRegistry.game.setFilmGrade(0);
			
			spg.tutorialSetBoard([
										[2,3,1,2,1,4,2,1],
										[0,1,4,3,5,1,3,4],
										[4,0,5,5,4,0,3,2],
										[2,1,3,4,2,3,2,1],
										[2,0,4,1,3,0,1,2],
										[1,2,3,4,2,1,2,3]]);
			

			spg.setAllowedMatch([[4,1],[4,2]], 5);

			// don't allow the player to have credit for houses, to prevent
			// rare tutorial bug caused by matching houses before the location is drawn
			GameRegistry.resources.preventGemCredit(1);

			spg.setMatchEnabled(false);
		}

		loadMatch1Highlight();

		// prevent any house matches from counting until they should
		GameRegistry.resources.preventGemCredit(1);

		var msg:String = 'This Movie is almost ready, but you need an Actor and Location.';

		GameRegistry.popups.addDocPopup(msg, PopupDoc.CORNER_BOTLEFT);

	}

	static public function highlightPlayButton():Void
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

		GameRegistry.popups.highlightRegions(playHighlightRects());
		GameRegistry.popups.showArrowAt(pos, 3);

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

	static public function loadPlayHighlight():Void
	{
		cacheHighlight(playHighlightRects);
	}

	static public function showLevelOne():Void
	{
		var smv:StateMapView = GameRegistry.game.stateMapView();

		var popup:PopupStarSelect = new PopupStarSelect();

		GameRegistry.popups.addUniquePopup(popup, true, true, false, false);
	}

	static public function stageStart0():Void
	{
		// don't do anything
		trace('SETTING UP STAGE 0');
		// GameRegistry.game.setFilmGrade(0);
		GameRegistry.game.changeState(Globals.STATE_MAP, Game.TRANS_LOADING, false);
	}

	

	*/
}

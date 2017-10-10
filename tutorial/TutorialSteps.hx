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

}

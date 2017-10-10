package com.jamwix.hs.tutorial;

import com.jamwix.hs.tutorial.TutorialManager;
import com.jamwix.hs.levels.Level;
import com.jamwix.hs.ui.popups.PopupDocPassive;

/*
*	This implements hints that are only loosly tied to a given tutorial step
*/

class PassiveHints
{

	static public var HINT_DRAG_BITS:Int 			= 0;
	static public var HINT_ADDED_GOOD_CINEBIT:Int 	= 1;
	static public var HINT_CINEBIT_ACTIVE:Int 		= 2;
	static public var HINT_BAD_CINEMETER:Int 		= 3;
	static public var HINT_USE_FX:Int 				= 4;
	static public var HINT_HURRY_UP:Int  			= 5;
	static public var HINT_GENRE_LEVEL:Int			= 6;
	static public var HINT_PUZZLE_LEVEL:Int			= 7;
	static public var HINT_MONSTER_LEVEL:Int		= 8;
	static public var HINT_BOMB_LEVEL:Int			= 9;

	static private var HINT_STRINGS:Array<String> = ['Drag cinebits to the filmstrip & build your movie!',
													'Great work!\nYour masterpiece is coming together now!',
													'Now you can add Cinebits to your movie!',
													'Your movie is in trouble, try adding or changing Cinebits!',
													'Time is running out, use your FX powers!',
													'Hurry up! Almost outta time!',
													'This is a Genre Scene! Your movie will only be judged as a [GENRE] film!',
													"It's a Puzzle Scene! You'll have to create a movie with the Cinebits in your hand!",
													"Lookout! It's a Monster Scene! Don't match the monsters or they'll infest your film!",
													"Lookout! It's a Bomb Scene!\n Match those bombs before they explode!"];


	static public var GEM_COUNTS:Array<Int> = [13, 19, 25, 31, 37, 43];

	static private var GEM_MESSAGES:Array<String> = ['WOW!',
													'FANTASTIC!',
													'OUTSTANDING!',
													'INCREDIBLE!',
													'AMAZING!!!',
													'ABSOLUTELY EPIC!!!'];

	private var _hintsShown:Map<Int, Bool>;

	public function new()
	{
		// _hintsShown = new Map<Int, Bool>();
		resetHints();
	}

	public function resetHints():Void
	{
		_hintsShown = new Map<Int, Bool>();
	}

	private function hintShown(hintID:Int):Bool
	{
		if (_hintsShown.exists(hintID) &&
			_hintsShown.get(hintID) == true)
		{
			return true;
		}
		return false;
	}

	public function showHint(hintID:Int, force:Bool = false):Void
	{
		if (!GameRegistry.tutorial.checkCapability(TutorialManager.CAP_SHOW_PASSIVE_HINTS))
		{
			return;
		}

		// don't show hints until the player has taken at least one turn
		if (!force && GameRegistry.game.getTurnsTaken() < 1) return;

		// default time-to-show
		var timeToShow:Float = PopupDocPassive.SHOW_TIME;

		if (hintID == HINT_GENRE_LEVEL ||
			hintID == HINT_BOMB_LEVEL ||
			hintID == HINT_PUZZLE_LEVEL ||
			hintID == HINT_MONSTER_LEVEL)
		{
			timeToShow = PopupDocPassive.SHOW_TIME_LONG;
		}

		if (force || !hintShown(hintID))
		{
			var hintTxt:String = HINT_STRINGS[hintID];
			if (hintID == HINT_GENRE_LEVEL)
			{
				var lvl:Level = GameRegistry.levels.currLevel();

				trace('SHOWING GENRE HINT FOR GENRE: ' + lvl.genre);

				if (lvl.genre == -1) return;


				var genre:String = new String(Globals.GENRE_NAMES[lvl.genre]);
				genre = genre.toUpperCase();

				hintTxt = new String(HINT_STRINGS[hintID]);
				var re = ~/\[GENRE\]/g;
				hintTxt = re.replace(hintTxt, genre);
			}

			trace("SHOWING PASSIVE: " + hintTxt);

			var onLeft:Bool = false;
			if (hintID == HINT_GENRE_LEVEL ||
				hintID == HINT_ADDED_GOOD_CINEBIT ||
				hintID == HINT_BAD_CINEMETER)
			{
				onLeft = true;
			}

			GameRegistry.popups.addPassiveDocPopup(hintTxt, timeToShow, onLeft);
			_hintsShown.set(hintID, true);
		}
	}

	public function showGemPopup(gemCount:Int):Void
	{
		var index:Int = -1;
		for (i in 0...GEM_COUNTS.length)
		{
			if (gemCount >= GEM_COUNTS[i])
			{
				index = i;
			}
		}

		if (index >= 0)
		{
			if (index >= GEM_MESSAGES.length) index = GEM_MESSAGES.length - 1;
			GameRegistry.popups.addPassiveDocPopup(GEM_MESSAGES[index]);
		}
	}
}

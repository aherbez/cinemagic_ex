package com.jamwix.hs.posters;

import haxe.Json;

import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.cards.PersonData;
import com.jamwix.hs.GameRegistry;
import com.jamwix.hs.cards.Attributes;
import com.jamwix.hs.levels.Level;
import com.jamwix.utils.JWUtils;

/**
 * ...
 * @author Adrian Herbez
 */
class PosterData
{
	static public var DEFAULT_SYNOP:String = 'ADD CINEBITS TO THE FILMSTRIP TO MAKE A MOVIE!';

	static public var NO_CARD:Int = -1;

	static private var TEXT_SYNOP:Int = 1;
	static private var TEXT_TAGLINE:Int = 2;

	// PLOT ACTOR LOCATION CHARACTER SPECIAL
	static public var MAX_CARDS:Array<Int> = [2, 2, 1, 2, 100];
	// static public var MAX_CARDS:Array<Int> = [20,20,20,20,0];

	static public var MAX_PEOPLE:Int = 2;

	// Card Type Genre Weights
	static public var CTG_WEIGHTS = [0.25, 0.25, 0.25, 0.25, 0];
	static public var GENRE_PICK_WEIGHTS = [0.25, 0.25, 0.25, 0.25, 0];
	static public var GENRE_THRESHOLD = 0.2;
	static public var GENRE_WEAK = 0.0;

	static public var GENRE_LEVEL_LOCK:Bool = true;

	// comedy horror adventure thriller action sci-fi musical drama romance
	// static public var GENRE_NAMES = ['comedy','horror', 'adventure', 'thriller', 'action', 'scifi', 'musical', 'drama', 'romance'];

	static private var FRENCH_TITLES = [
		"Les Bonnes Femmes",
		"Les Cousins Dangereux",
		"Tuer tous Les Robots",
		"C'est la vie",
		"Le Passage du Rhin",
		"Zazie dans le metro",
		"Le Chat Puant",
		"Il Gatto Puzzolente",
		"Die Stinkende Katze",
		"El Gato Apestoso"
	];
	public var cards:Array<Int>;

	public var cardsByType:Array<Array<Int>>;
	public var people:Array<PersonData>;

	public var actors:Array<Int>;
	public var characters:Array<Int>;
	public var specials:Array<Int>;
	public var plot:Int;
	public var location:Int;

	public var moneyMade:Int;
	public var moneySpent:Int;

	public var genreWeights:Array<Float>;

	public var currTitleCombo:String;
	public var currTitleCards:Array<Dynamic>;
	public var currTitleWords:Array<Dynamic>;
	public var currTitle:String;

	static private var ACTOR:Int = 1;
	static private var CHARACTER:Int = 2;
	private var _peopleStrings:Array<String>;
	private var _peopleState:Array<Int>;
	private var _peopleGenders:Array<Int>;

	private var _peopleDirty:Bool;

	// variables to ensure that title, tagline, and synopsis remain constant
	private var _synopsisRaw:String;
	private var _genresRaw:String;
	private var _title:String;
	private var _tagline:String;

	public function new()
	{
		cards = new Array<Int>();

		cardsByType = new Array<Array<Int>>();
		cardsByType[CardData.TYPE_ACTOR] = new Array<Int>();
		cardsByType[CardData.TYPE_CHARACTER] = new Array<Int>();
		cardsByType[CardData.TYPE_LOCATION] = new Array<Int>();
		cardsByType[CardData.TYPE_PLOT] = new Array<Int>();
		cardsByType[CardData.TYPE_SPECIAL] = new Array<Int>();

		people = new Array<PersonData>();

		_peopleStrings = new Array<String>();
		_peopleState = new Array<Int>();
		_peopleGenders = new Array<Int>();

		genreWeights = new Array<Float>();

	 	currTitleCombo = '';
	 	currTitleCards = new Array<Dynamic>();
	 	currTitleWords = new Array<Dynamic>();
	 	currTitle = '';

	 	_peopleDirty = true;

	 	_title = '';
	 	_tagline = '';
	 	_synopsisRaw = '';
	 	_genresRaw = '';
	}

	public function setTitle(newTitle:String)
	{
		_title = newTitle;
	}

	// TODO: maybe refactor this to avoid serializing / deserializing
	// benefit is that we only have that kind of thing happening in a single place
	public function copy():PosterData
	{
		var pd:PosterData = new PosterData();
		pd.initFromString(this.serialize());
		return pd;
	}

	// used by Critic.testCardAdd() to determine if a given card is worth adding
	public function getCardsByType(type:Int):Array<Int>
	{
		return cardsByType[type].copy();
	}

	// load up data from JSON string
	public function initFromString(json:String):Void
	{
		clear();
		var data:Dynamic = Json.parse(json);

		// trace('INIT TO: ');
		// trace(data);

		var cardsIn:Array<Int> = Json.parse(data.cards);
		for (i in 0...cardsIn.length)
		{
			addCard(Std.int(cardsIn[i]), -1, false);
		}

		// TODO: this feels clunky, could probably be rewritten to be cleaner
		if (data.people != null)
		{
			people = new Array<PersonData>();
			var peopleIn:Array<Array<Int>> = Json.parse(data.people);
			var person:PersonData;
			if (peopleIn != null && peopleIn.length > 0)
			{
				for (i in 0...peopleIn.length)
				{
					person = new PersonData();
					person.setActor(peopleIn[i][0]);
					person.setCharacter(peopleIn[i][1]);
					people.push(person);
				}
			}
		}

		/*
		// TODO: reenable this if/when caching is resolved for randomized genders
		// commenting this out for now
		if (data.genders != null)
		{
			// trace('setting genders from serialized data');
			var genders:Array<Int> = Json.parse(data.genders);
			if (genders != null)
			{
				_peopleGenders = new Array<Int>();
				for (i in 0...genders.length)
				{
					_peopleGenders[i] = genders[i];
				}
			}
		}
		*/

		moneyMade = data.moneyMade;
		_title = data.title;
		_tagline = data.tagline;
		_synopsisRaw = data.synopsis;
		_genresRaw = data.genre_str;
	}

	public function typeMaxed(cd:CardData):Bool
	{
		if (cd.cardType == CardData.TYPE_SPECIAL) return false;

		var max:Int; // = MAX_CARDS[cd.cardType];
		var cmp:Int; // = cardsByType[cd.cardType];

		if (cd.cardType == CardData.TYPE_CHARACTER || cd.cardType == CardData.TYPE_ACTOR)
		{
			max = MAX_CARDS[CardData.TYPE_CHARACTER];
			cmp = people.length;
		}
		else
		{
			max = MAX_CARDS[cd.cardType];
			cmp = cardsByType[cd.cardType].length;
		}

		if (cmp >= max)
		{
			return true;
		}
		return false;
	}

	public function cardCollides(cd:CardData):Bool
	{
		var max:Int = MAX_CARDS[cd.cardType];

		if (cardsByType[cd.cardType].length > max)
		{
			return true;
		}
		return false;
	}

	public function canUseCard(cd:CardData):Bool
	{
		if (cd == null) return false;
		if (cd.cardType == CardData.TYPE_SPECIAL) return true;

		var type:Int = cd.cardType;
		if (type == CardData.TYPE_ACTOR || type == CardData.TYPE_CHARACTER)
		{
			var numPoison:Int = 0;
			for (id in cardsByType[CardData.TYPE_ACTOR])
			{
				var cd:CardData = GameRegistry.cards.getCardByID(id);
				if (cd.poison) numPoison = numPoison + 1;
			}

			for (id in cardsByType[CardData.TYPE_CHARACTER])
			{
				var cd:CardData = GameRegistry.cards.getCardByID(id);
				if (cd.poison) numPoison = numPoison + 1;
			}

			return (numPoison < 2);
		}

		var numPoison:Int = 0;
		for (id in cardsByType[cd.cardType])
		{
			var cd:CardData = GameRegistry.cards.getCardByID(id);
			if (cd.poison) numPoison = numPoison + 1;
		}

		return (numPoison < MAX_CARDS[cd.cardType]);
	}

	// return an average of the current plot card
	// CardData is only used to provide a collection of genre weights
	public function getPlot():CardData
	{
		var plotData:CardData = new CardData();
		var cd:CardData;

		if (cardsByType[CardData.TYPE_PLOT].length < 1) return null;

		var leveledGenres:Array<Float>;

		for (i in 0...cardsByType[CardData.TYPE_PLOT].length)
		{
			cd = GameRegistry.cards.getCardByID(cardsByType[CardData.TYPE_PLOT][i]);

			leveledGenres = cd.getGenres();
			// for (j in 0...cd.genres.length)
			for (j in 0...leveledGenres.length)
			{
				plotData.genres[j] += leveledGenres[j];
			}
		}

		for (i in 0...plotData.genres.length)
		{
			plotData.genres[i] /= cardsByType[CardData.TYPE_PLOT].length;
		}

		return plotData;
	}

	public function getMainPlot():CardData
	{
		if (cardsByType[CardData.TYPE_PLOT].length < 1) return null;

		var cid:Int = cardsByType[CardData.TYPE_PLOT][0];

		return GameRegistry.cards.getCardByID(cid);
	}

	public function getPlotIds():Map<Int, Int>
	{
		var ids:Map<Int, Int> = new Map<Int, Int>();
		for (id in cardsByType[CardData.TYPE_PLOT])
		{
			ids.set(id, 1);
		}

		return ids;
	}

	public function getNumCards():Int
	{
		return (cards.length);
	}

	// number of non-special cards
	public function getNumCardsNoSpecials():Int
	{
		var numCards:Int = 0;
		for (i in 0...Globals.CARD_TYPES)
		{
			if (i != CardData.TYPE_SPECIAL)
			{
				numCards += cardsByType[i].length;
			}
		}

		return numCards;
	}

	public function getNumCardsByType():Array<Int>
	{
		var cardCounts:Array<Int> = new Array<Int>();

		for (i in 0...Globals.CARD_TYPES)
		{
			if (cardsByType[i] != null)
			{
				cardCounts.push(cardsByType[i].length);
			}
			else
			{
				cardCounts.push(0);
			}
		}

		return cardCounts;
	}

	public function findGenres():Array<Int>
	{
		var level:Level = GameRegistry.levels.currLevel();
		if (GENRE_LEVEL_LOCK && level != null && level.hasType(Level.TYPE_GENRE))
		{
			return [level.genre];
		}

		var genres:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0, 0];
		var cd:CardData;
		var cardGenres:Array<Float>;
		for (cid in cards) {
			cd = GameRegistry.cards.getCardByID(cid);
			cardGenres = cd.getGenres();

			for (i in 0...cardGenres.length) {
				genres[i] += cardGenres[i];
			}
		}

		var max:Float = -9999;
		var sec:Float = -9999;
		for (i in 0...genres.length) {
			var val = genres[i];
			if (val > max) {
				sec = max;
				max = val;
			} else if (val > sec) {
				sec = val;
			}
		}

		var maxIdx = genres.indexOf(max);
		var secIdx = max == sec ? genres.indexOf(sec, maxIdx + 1) : genres.indexOf(sec);

		var retGenres = [maxIdx];
		//console.log("GENRES: " + genres);
		//console.log(GENRE_NAMES[maxIdx] + ": " + max);
		if ((max - sec) < GENRE_THRESHOLD || max < GENRE_WEAK) {
			retGenres.push(secIdx);
			//console.log(GENRE_NAMES[secIdx] + ": " + sec);
		}

		return retGenres;
	}

	public function getGenreStr():String
	{
		var genres:Array<Int> = findGenres();

		var genresStr:String = 'NONE';
		if (genres.length > 0)
		{
			genresStr = '';
			if (genres.length == 1)
			{
				var genreName:String = Globals.GENRE_NAMES[genres[0]];
				genresStr += genreName;
			}
			else
			{
				var genreName:String =
					Globals.GENRE_NAMES[genres[0]] + ' ' +
					Globals.GENRE_NAMES[genres[1]];

				genresStr += genreName;
			}
		}

		genresStr = genresStr.toUpperCase();
		return genresStr;
	}

	// return JSON string containing poster data
	public function serialize():String
	{
		var data:Dynamic = {};

		data.location = PosterData.NO_CARD;
		if (cardsByType[CardData.TYPE_LOCATION].length > 0)
		{
			data.location = cardsByType[CardData.TYPE_LOCATION][0];
		}

		data.plot = Json.stringify(cardsByType[CardData.TYPE_PLOT]);
		data.actors = Json.stringify(cardsByType[CardData.TYPE_ACTOR]);
		data.characters = Json.stringify(cardsByType[CardData.TYPE_CHARACTER]);
				
		// TODO: reenabled the below for randomized genders
		// data.genders = Json.stringify(_peopleGenders);

		data.cards = Json.stringify(cards);

		var peopleData:Array<Array<Int>> = new Array<Array<Int>>();
		for (i in 0...people.length)
		{
			peopleData.push(people[i].asArray());
		}
		data.people = Json.stringify(peopleData);

		if (_synopsisRaw == '' || _genresRaw == '')
		{
			generateSynopsis();
		}

		data.title = getTitle();
		data.tagline = getTagline();

		data.synopsis = _synopsisRaw;
		data.genre_str = _genresRaw;

		data.moneyMade = moneyMade;
		data.moneySpent = 0;

		var s:String = Json.stringify(data);
		// trace('POSTER DATA SERIALIZEED TO: ');
		// trace(s);

		return s;
	}

	// will return a multiplier based on specials played
	// TODO: deal with having more varied special cards
	public function getSpecialsBonus():Float
	{

		// start at 1 so that we're not reducing things as they stack
		var bonus:Float = 1.0;

		var currGenres:Array<Int> = this.findGenres();

		for (i in 0...this.cardsByType[CardData.TYPE_SPECIAL].length)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cardsByType[CardData.TYPE_SPECIAL][i]);

			bonus *= (1 + cd.getSpecialsBonus(currGenres));

			/*
			var fx:Dynamic = Json.parse(cd.effects);

			var effectsAr:Array<Dynamic> = fx.playfx;

			if (effectsAr != null && effectsAr.length > 0)
			{
				// trace('fx.playfx[0]: ' + fx.playfx[0]);
				// trace('fx.playfx[0].bon: ' + fx.playfx[0].bon);
				// var bonus:Float = Std.parseFloat(Std.string(fx.playfx[0].bon));
				var cardBonus:Float = fx.playfx[0].bon;
				bonus += cardBonus;
			}
			*/
		}

		// trace('TOTAL BONUS: ' + mult);

		// subtract the initial 1 to provide the total percent increase
		return (bonus - 1);
	}

	public function clear():Void
	{
		cards = [];

		for (i in 0...cardsByType.length)
		{
			cardsByType[i] = [];
		}
	}

	// returns true if the card was removed, false if it wasn't found
	public function removeCard(cd:CardData):Bool
	{
		// trace('REMOVING CARD: ' + cd.cardName);

		var foundInCards:Bool = false;

		for (i in 0...cards.length)
		{
			if (cards[i] == cd.ID)
			{
				// trace('removed: ' + cards.splice(i, 1));
				cards.splice(i, 1);
				foundInCards = true;
				break;
			}
		}

		var foundInSubarray:Bool = false;

		// TODO: remove card entry from specific sub-array
		var searchArray:Array<Int> = cardsByType[cd.cardType];
		for (i in 0...searchArray.length)
		{
			if (searchArray[i] == cd.ID)
			{
				// remove the card
				searchArray.splice(i, 1);
				foundInSubarray = true;
			}
		}

		var foundAsActor:Bool = false;
		var foundAsCharacter:Bool = false;

		if (cd.cardType == CardData.TYPE_ACTOR || cd.cardType == CardData.TYPE_CHARACTER)
		{
			for (i in 0...people.length)
			{
				// if (people[i] != null) people[i].debugPrint();
				if (people[i] != null && people[i].actorID == cd.ID)
				{
					people[i].setActor(-1);
					foundAsActor = true;
				}
				if (people[i] != null && people[i].characterID == cd.ID)
				{
					people[i].setCharacter(-1);
					foundAsCharacter = true;
				}

				if (people[i] != null &&
					people[i].actorID == -1 &&
					people[i].characterID == -1)
				{
					people.splice(i,1);
				}
			}


		}

		// trace(cd.cardName + ' inCards: ' + foundInCards + ' inSub: ' + foundInSubarray + ' actor: ' + foundAsActor + ' char: ' + foundAsCharacter);

		// this should never happen
		/*
		if (foundInCards != foundInSubarray)
		{
			trace('ERROR: card ' + cd.cardName + ' in cards but not subarray or vice-versa');
		}
		*/

		_peopleDirty = true;
		updatePeople();

		// debugPrintContents();
		generateSynopsis(true, true, true);
		generateTitle(true);
		generateTagline(true);

		return (foundInCards && foundInSubarray);
	}

	public function getAttList():Map<Int, Int>
	{
		var atts:Map<Int, Int> = new Map<Int, Int>();

		var cd:CardData;

		for (c in cards)
		{
			cd = GameRegistry.cards.getCardByID(c);

			if (cd.attributes == null || cd.attributes.length < 1) continue;

			for (a in cd.attributes)
			{
				if (atts.exists(a))
				{
					atts.set(a, atts.get(a) + 1);
				}
				else
				{
					atts.set(a, 1);
				}
			}
		}

		return atts;
	}

	public function removeCardById(cardId:Int):Void
	{
		for (i in 0...cards.length)
		{
			if (cards[i] == cardId)
			{
				cards.splice(i, 1);
				// trace('REMOVED: ' + cardId + ' FROM cards');
			}
		}


		for (j in 0...cardsByType.length)
		{
			for (i in 0...cardsByType[j].length)
			{
				if (cardsByType[j][i] == cardId)
				{
					cardsByType[j].splice(i, 1);
					// trace('REMOVED ' + cardId + ' FROM sub-array ' + j);
				}
			}
		}

		// just in case
		_peopleDirty = true;
	}

	public function removeRandomNonLocation():Int
	{
		var nonLocCards:Array<Int> = [];
		var cd:CardData;

		for (i in 0...cards.length)
		{
			cd = GameRegistry.cards.getCardByID(cards[i]);
			// trace(cd.cardName);

			if (cd.cardType != CardData.TYPE_LOCATION)
			{
				nonLocCards.push(cards[i]);
			}
		}

		var rmPos:Int = Std.random(nonLocCards.length);
		var rmId:Int = nonLocCards[rmPos];
		// removeCardById(rmId);

		cd = GameRegistry.cards.getCardByID(rmId);
		removeCard(cd);

		return rmId;
	}

	public function removeRandomCard():Int
	{
		if (cards.length == 0) {
			return PosterData.NO_CARD;
		}

		var rmPos:Int = Std.random(cards.length);
		var rmId:Int = cards[rmPos];
		// removeCardById(rmId);

		var cd:CardData = GameRegistry.cards.getCardByID(rmId);
		removeCard(cd);

		return rmId;
	}

	// add a special only if it wasn't previously added
	public function addSpecial(cid:Int):Bool
	{
		var found:Bool = false;
		for (i in 0...cardsByType[CardData.TYPE_SPECIAL].length)
		{
			if (cardsByType[CardData.TYPE_SPECIAL][i] == cid)
			{
				found = true;
			}
		}

		if (!found)
		{
			addCard(cid);
		}
		return !found;
	}

	public function addCard(cid:Int, ?index:Int = -1, ?generateText:Bool = true):Void
	{
		var cd:CardData = GameRegistry.cards.getCardByID(cid);
		// trace('ADDING ' + cd.cardName);

		if (cd.cardType == CardData.TYPE_ACTOR || cd.cardType == CardData.TYPE_CHARACTER)
		{
			var p:PersonData = new PersonData();
			p.add(cd);
			people.push(p);
			_peopleDirty = true;
		}

		cardsByType[cd.cardType].push(cd.ID);
		cards.push(cid);
		getSpecialsBonus();

		if (generateText)
		{
			generateTagline(true);
			generateSynopsis(true, true, true);
			generateTitle(true);
		}

		// debugPrintContents();
		// trace(_synopsisRaw);
	}

	public function addPerson(cardsToAdd:Array<Int>):Void
	{
		// if (actorID == -1 && characterID == -1) return;
		if (cardsToAdd.length < 1) return;

		var p:PersonData = new PersonData();
		var cd:CardData;

		for (i in 0...cardsToAdd.length)
		{
			cd = GameRegistry.cards.getCardByID(cardsToAdd[i]);
			cards.push(cardsToAdd[i]);
			cardsByType[cd.cardType].push(cardsToAdd[i]);
			p.add(cd);
		}

		people.push(p);
		_peopleDirty = true;
	}


	// used by the critic tool to combine actors and characters
	public function debugAddPerson(cd:CardData):Void
	{
		var added:Bool = false;

		cardsByType[cd.cardType].push(cd.ID);
		cards.push(cd.ID);

		if (people.length < 1)
		{
			var p:PersonData = new PersonData();
			p.add(cd);
			people.push(p);

			_peopleDirty = true;
			return;
		}

		for (i in 0...people.length)
		{
			if (cd.cardType == CardData.TYPE_ACTOR &&
				people[i] != null &&
				people[i].actorID == -1)
			{
				people[i].add(cd);
				added = true;
			}
			else if (cd.cardType == CardData.TYPE_CHARACTER &&
					 people[i] != null &&
					 people[i].characterID == -1)
			{
				people[i].add(cd);
				added = true;
			}

			if (added)
			{
				_peopleDirty = true;
				return;
			}
		}

		var p:PersonData = new PersonData();
		p.add(cd);
		people.push(p);

		_peopleDirty = true;
		return;
	}

	public function addToPerson(oldID:Int, newID:Int):Void
	{
		for (i in 0...people.length)
		{
			if (people[i] != null && people[i].hasCard(oldID))
			{
				var removeID:Int = people[i].addById(newID);

				if (removeID != -1 )
				{
					removeCardById(removeID);
				}
				_peopleDirty = true;
			}
		}
	}

	public function addOrReplaceByID(oldCID:Int, newCID:Int):Void
	{
		var oldCD:CardData = GameRegistry.cards.getCardByID(oldCID);
		var newCD:CardData = GameRegistry.cards.getCardByID(newCID);

		addOrReplace(oldCD, newCD);
	}

	public function addOrReplace(oldCD:CardData, newCD:CardData):Void
	{
		// trace('ADD OR REPLACE: ' + newCD.cardName);

		if (newCD.cardType == CardData.TYPE_ACTOR || newCD.cardType == CardData.TYPE_CHARACTER)
		{

			// TODO: addOrReplace needs cleaned up
			addToPerson(oldCD.ID, newCD.ID);
			cardsByType[newCD.cardType].push(newCD.ID);
			cards.push(newCD.ID);

		}
		else
		{
			removeCardById(oldCD.ID);
			addCard(newCD.ID);
		}

		_peopleDirty = true;
		generateSynopsis(true, true, true);
		generateTagline();
		generateTitle();
	}

	// combines cards, currently just actor/characters
	public function combineCard(cidA:Int, cidB:Int):Void
	{

	}

	private function isVowel(c:String):Bool
	{
		if (c == 'a') return true;
		if (c == 'e') return true;
		if (c == 'i') return true;
		if (c == 'o') return true;
		if (c == 'u') return true;
		return false;
	}

	private function updatePeople():Void
	{
		// trace('UPDATE PEOPLE');
		var actor:CardData = null;
		var character:CardData = null;

		var peopleCount:Int = 0;

		// clear out people
		for (i in 0...2)
		{
			_peopleGenders[i] = CardData.GENDER_NULL;
			_peopleState[i] = 0;
			_peopleStrings[i] = null;
		}

		for (i in 0...people.length)
		{
			actor = null;
			character = null;

			if (people[i] != null && people[i].characterID != -1)
			{
				character = GameRegistry.cards.getCardByID(people[i].characterID);

				var gender:Int = character.getGender();

				if (gender != CardData.GENDER_NULL)
				{
					_peopleGenders[i] = gender;
				}
				else
				{
					_peopleGenders[i] = CardData.GENDER_MALE;
				}
			}

			if (people[i] != null && people[i].actorID != -1)
			{
				actor = GameRegistry.cards.getCardByID(people[i].actorID);
				if (actor.hasAttribute(Attributes.ATT_MALE)) _peopleGenders[i] = CardData.GENDER_MALE;
				if (actor.hasAttribute(Attributes.ATT_FEMALE)) _peopleGenders[i] = CardData.GENDER_FEMALE;
			}

			if (character == null && actor == null)
			{
				_peopleStrings[i] = null;
				_peopleState[i] = 0;
			}

			if (character == null && actor != null)
			{
				_peopleStrings[i] = actor.cardName;
				_peopleState[i] = ACTOR;
			}

			if (character != null && actor == null)
			{
				_peopleStrings[i] = character.cardName.toLowerCase();
				_peopleState[i] = CHARACTER;
			}

			if (character != null && actor != null)
			{
				_peopleStrings[i] = character.cardName.toLowerCase() + ' (' + actor.cardName + ')';
				_peopleState[i] = ACTOR | CHARACTER;
			}

			if (_peopleStrings[i] != null)
			{
				peopleCount++;
			}
		}

		// trace(_peopleGenders);
		// trace('UPDATING PEOPLE');
		// debugPrintContents();
		_peopleDirty = false;
	}

	// process a single replaceable clause
	private function parseClause(input:String, ?type:Int = 1):String
	{
		// trace('PARSE CLAUSE ' + input);
		var parts:Array<String> = input.split('|');

		var s:String = '';

		if (parts.length <= 0) return s;

		switch (parts[0])
		{

			case 'pA':
			{
				if (_peopleStrings[0] != null)
				{
					if (_peopleState[0] == ACTOR)
					{
						// actor only, use default character
						if (parts[1] != null)
						{
							s = parts[1] + ' (' + _peopleStrings[0] + ')';
						}
						else
						{
							s = _peopleStrings[0];
						}
					}
					else // character added, so replace everything
					{
						s = _peopleStrings[0];
					}
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}
			}
			case 'pB':
			{
				if (_peopleStrings[1] != null)
				{
					if (_peopleState[1] == ACTOR)
					{
						// actor only, use default character
						if (parts[1] != null)
						{
							s = parts[1] + ' (' + _peopleStrings[1] + ')';
						}
						else
						{
							s = _peopleStrings[1];
						}
					}
					else // character added, so replace everything
					{
						s = _peopleStrings[1];
					}
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}
			}
			case 'gA':
			{
				if (_peopleGenders[0] == CardData.GENDER_FEMALE)
				{
					if (parts[2] != null) s = parts[2];
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}
			}
			case 'gB':
			{
				if (_peopleGenders[1] == CardData.GENDER_FEMALE)
				{
					if (parts[2] != null) s = parts[2];
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}

			}
			case 'nA':
			{
				// last name of actor A, if given
				if (people[0] != null && people[0].actorID != -1)
				{
					var cd:CardData = GameRegistry.cards.getCardByID(people[0].actorID);
					s = cd.getLastName();
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}
			}
			case 'nB':
			{
				// last name of actor B, if given
				if (people[1] != null && people[1].actorID != -1)
				{
					var cd:CardData = GameRegistry.cards.getCardByID(people[1].actorID);
					s = cd.getLastName();
				}
				else
				{
					if (parts[1] != null) s = parts[1];
				}
			}
			case 'L':
			{
				if (cardsByType[CardData.TYPE_LOCATION].length > 0)
				{
					var cd:CardData = GameRegistry.cards.getCardByID(cardsByType[CardData.TYPE_LOCATION][0]);
					s = cd.cardName.toLowerCase();
				}
				else
				{
					if (parts[1] != null) s = parts[1].toLowerCase();
				}

			}
		}
		// trace(s);
		return s;
	}

	// process an entire string with multiple, possibly nested clauses
	// default to processing text as a plot synopsis
	private function processClauseString(s:String, ?type:Int = 1):String
	{
		if (s == '' || s.length < 1)
		{
			return '';
		}

		var parts:Array<String> = [];
		var index:Int = 0;
		var c:String = '';

		for (i in 0...s.length)
		{
			c = s.charAt(i);

			if (c == '[')
			{
				index++;
			}
			else if (c == ']')
			{
				if (parts[index-1] == null) parts[index-1] = '';
				parts[index-1] += parseClause(parts[index], type);
				parts[index] = '';
				index--;
			}
			else
			{
				if (parts[index] == null)
				{
					parts[index] = c;
				}
				else
				{
					parts[index] += c;
				}
			}
		}

		return parts[0];
	}

	public function getTagline():String
	{
		if (_tagline == '')
		{
			generateTagline();
		}
		return _tagline;
	}

	public function generateTagline(?force:Bool = false):String
	{
		if (_tagline != '' && !force)
		{
			return _tagline;
		}

		if (_peopleDirty)
		{
			updatePeople();
		}

		var plotDat:CardData;
		var tagstring:String = '';
		var fx:Dynamic;

		if (cardsByType[CardData.TYPE_PLOT].length > 0)
		{
			plotDat = GameRegistry.cards.getCardByID(cardsByType[CardData.TYPE_PLOT][0]);

			fx = Json.parse(plotDat.effects);
			if (fx.tagline != null && fx.tagline != '')
			{
				tagstring = fx.tagline;
			}
		}

		_tagline = processClauseString(tagstring, PosterData.TEXT_TAGLINE);

		return _tagline;
	}

	public function getSynopsisPlainText():String
	{
		// if we don't yet have a synopsis, make one
		if (_synopsisRaw == '' || _genresRaw == '' || _peopleDirty)
		{
			generateSynopsis();
		}

		var synop:String = _synopsisRaw;
		synop = StringTools.replace(synop, '@@', _genresRaw);
		synop += ' film.';
		return synop;
	}

	public function getSynopsis(?color:String = 'cf6d09'):String
	{
		// if we don't yet have a synopsis, make one
		if (_synopsisRaw == '' || _genresRaw == '' || _peopleDirty)
		{
			generateSynopsis();
		}

		var synop:String = _synopsisRaw;
		var genreText:String = '<font color="#' + color + '">' + _genresRaw + '</font>';

		synop = StringTools.replace(synop, '@@', genreText);
		synop += ' film.';
		return synop;
	}

	public function generateSynopsis(?colorText:Bool = false,
									 ?upperCase:Bool = false,
									 ?force:Bool = false):String
	{

		// if we already have a synopsis, return that
		/*
		if (_synopsisRaw != '' && _genresRaw != '' && !force && !_peopleDirty)
		{
			return getSynopsis();
		}
		*/
		// trace('GENERATING SYNOPSIS');
		var plotString:String = '';
		var plotDat:CardData;
		var synopsis:String = '';

		var fx:Dynamic;

		var actor:CardData = null;
		var character:CardData = null;

		if (_peopleDirty)
		{
			updatePeople();
		}

		if (getNumCardsNoSpecials() < 2)
		{
			return DEFAULT_SYNOP;
		}


		// debugPrintContents();
		var ploti:Int = 0;
		for (i in 0...cardsByType[CardData.TYPE_PLOT].length)
		{
			plotDat = GameRegistry.cards.getCardByID(cardsByType[CardData.TYPE_PLOT][i]);

			fx = Json.parse(plotDat.effects);

			if (ploti < 1)
			{
				if (fx.syn != null && fx.syn != '')
				{
					plotString += fx.syn;
					ploti++;
				}
			}
			else
			{
				if (fx.synb != null && fx.synb != '')
				{
					plotString += ' ' + fx.synb;
				}
			}
		}

		if (plotString == '')
		{
			// no plot, add *something
			if (this.people.length < 2)
			{
				// only one person
				if (_peopleState[0] == ACTOR)
				{
					// synopsis = 'A movie starring ' + _peopleStrings[0] + ' [L]';
					plotString = 'A movie starring [pA]';

					if (cardsByType[CardData.TYPE_LOCATION].length > 0)
					{
						plotString += ' set in [L]';
					}

				}
				else
				{
					// synopsis = 'A movie about ' + _peopleStrings[0];
					plotString = 'A movie about [pA]';

					if (cardsByType[CardData.TYPE_LOCATION].length > 0)
					{
						plotString += ' set in [L]';
					}
				}
			}
			else
			{
				plotString = 'A movie starring [pA] and [pB]';

				if (cardsByType[CardData.TYPE_LOCATION].length > 0)
				{
					plotString += ' set in [L]';
				}
			}

		}

		synopsis = this.processClauseString(plotString);

		// capitialize the summary
		var firstChar:String = synopsis.substr(0,1);
		synopsis = synopsis.substr(1);
		synopsis = firstChar + synopsis;

		// TODO: need to move away from hard-coded text
		synopsis += ' in this ';
		var genres:Array<Int> = findGenres();

		// if (upperCase) synopsis = synopsis.toUpperCase();

		var genresStr:String = '';
		if (colorText)
		{
			genresStr += '<font color="#cf6d09">';
		}

		_genresRaw = '';

		if (genres.length > 0)
		{
			if (genres.length == 1)
			{
				var genreName:String = Globals.GENRE_NAMES[genres[0]];
				if (upperCase) genreName = genreName.toUpperCase();
				genresStr += genreName;
				_genresRaw += genreName;
			}
			else
			{
				var genreName:String =
					Globals.GENRE_NAMES[genres[0]].toUpperCase() + '-' +
					Globals.GENRE_NAMES[genres[1]].toUpperCase();

				if (upperCase) genreName = genreName.toUpperCase();
				genresStr += genreName;
				_genresRaw += genreName;
			}
		}
		if (colorText)
		{
			genresStr += '</font>';
		}
		_synopsisRaw = synopsis + '@@';

		synopsis = synopsis + genresStr + " FILM.";
		// trace(synopsis);
		return synopsis;
	}

	public function getTitle():String
	{
		if (_title == '')
		{
			generateTitle();
		}

		return _title;
	}

	public function generateTitle(?force:Bool = false):String
	{
		if (_title != '' && !force)
		{
			return _title;
		}

		var combos:Array<String> = [
			'@living_things@ @objects@',
			'@objects@ @living_things@',
			'@actevents@ @living_things@',
			'The @living_things@ @actevents@',
			'@living_things@ of the @locations@',
			'@feelings@ @locations@',
			'@feelings@ @living_things@',
			'@feelings@ @objects@',
			'The @feelings@ of @attributes@',
			'@living_things@ @attributes@',
			'@objects@ @attributes@',
		];
		JWUtils.randomizeArray(combos);
		combos.push('@objects@ @objects@'); //TODO: This one is last...

	 	currTitleCombo = '';
	 	currTitleCards = new Array<Dynamic>();
	 	currTitleWords = new Array<Dynamic>();
	 	currTitle = '';

		var cardWords:Array<Dynamic> = new Array<Dynamic>();
		for (cardId in cards)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cardId);
			var titleWords:Dynamic = cd.titleWords;
			titleWords.ID = cd.ID;
			titleWords.name = cd.cardName;
			cardWords.push(cd.titleWords);
		}

		var title = '';
		for (combo in combos)
		{
			var newTitle = titleFromCombo(combo, cardWords);
			if (newTitle != null)
			{
				title = newTitle;
				currTitleCombo = combo;
				break;
			}
		}

		currTitle = title;

		if (title == '')
		{
			currTitle = FRENCH_TITLES[Std.random(FRENCH_TITLES.length)];
			return currTitle;
		}

		_title = JWUtils.capitalizeWords(title);

		return _title;
	}

	private function requirementsFromCombo(combo:String):Map<String, Int>
	{
		var reqReg:EReg = ~/@(living_things|attributes|feelings|objects|actevents|locations)@/g;
		var requirements:Map<String, Int> = new Map<String, Int>();

		// what are the word requirements for this combo?
		var comboCopy:String = new String(combo);
		while (reqReg.match(comboCopy))
		{
			var type:String = reqReg.matched(1);
			if (requirements.exists(type))
			{
				requirements.set(type, requirements.get(type) + 1);
			}
			else
			{
				requirements.set(type, 1);
			}
			var newPos:Int = reqReg.matchedPos().pos +
							 reqReg.matchedPos().len + 1;
			if (newPos < comboCopy.length)
			{
				comboCopy = comboCopy.substr(newPos);
			}
			else
			{
				comboCopy = '';
			}
		}

		return requirements;
	}

	private function getReqWordLocs(requirements:Map<String, Int>,
									cardWords:Array<Dynamic>):Map<String, Array<Int>>
	{
		var wordLocs:Map<String, Array<Int>> = new Map<String, Array<Int>>();
		for (type in requirements.keys())
		{
			var typeLocs:Array<Int> = new Array<Int>();
			for (i in 0...cardWords.length)
			{

				var titleWords:Dynamic = cardWords[i];
				var typeWords:Array<String> = Reflect.field(titleWords, type);
				if (typeWords != null && typeWords.length > 0 &&
					typeWords[0] != "")
				{
					typeLocs.push(i);
				}
			}

			// if we don't have enough of the given word type, fail with null
			if (typeLocs.length < requirements.get(type))
			{
				return null;
			}

			wordLocs.set(type, typeLocs);
		}

		return wordLocs;
	}

	private function getReqOrder(requirements:Map<String, Int>,
								 wordLocs:Map<String, Array<Int>>):Array<String>
	{
		var reqTypes:Array<String> = new Array<String>();
		for (type in requirements.keys())
		{
			reqTypes.push(type);
		}

		// sort requirements by the needed / have ratio
		reqTypes.sort(function (aType:String, bType:String):Int
		{
			var numNeededA:Int = requirements.get(aType);
			var numNeededB:Int = requirements.get(bType);

			var numHaveA:Int = wordLocs.get(aType).length;
			var numHaveB:Int = wordLocs.get(bType).length;

			var aRatio:Float = numHaveA / numNeededA;
			var bRatio:Float = numHaveB / numNeededB;

			if (aRatio < bRatio) return -1;
			if (aRatio > bRatio) return 1;
			return 0;
		});

		return reqTypes;
	}

	private function placeWordsInCombo(combo:String,
									   requirements:Map<String, Int>,
									   reqOrder:Array<String>,
									   cardWords:Array<Dynamic>,
									   wordLocs:Map<String, Array<Int>>):String
	{

		currTitleCards = new Array<Dynamic>();
		currTitleWords = new Array<String>();

		// need to track cards used
		var usedLocs:Array<Bool> = new Array<Bool>();
		for (i in 0...cardWords.length)
		{
			usedLocs[i] = false;
		}

		var title:String = new String(combo);

		// start substituting!
		for (type in reqOrder)
		{
			var oldLocations:Array<Int> = wordLocs.get(type);
			var locations:Array<Int> = new Array<Int>();

			// filter out already used cards
			for (loc in oldLocations)
			{
				if (!usedLocs[loc])
				{
					locations.push(loc);
				}
			};

			// if we don't have enough words for the requirement, return null
			var numReq:Int = requirements.get(type);
			if (numReq > locations.length) {
				currTitleCards = new Array<Dynamic>();
				currTitleWords = new Array<String>();
				return null;
			}

			for (i in 0...numReq)
			{
				var randLoc:Int = Std.random(locations.length);
				var loc:Int = locations.splice(randLoc, 1)[0];
				usedLocs[loc] = true;

				var titleWords:Dynamic = cardWords[loc];
				var typeWords:Array<String> = Reflect.field(titleWords, type);
				var randWord:String = typeWords[Std.random(typeWords.length)];

				var replaceReg:EReg = new EReg('@' + type + '@', '');
				title = replaceReg.replace(title, randWord);

				currTitleCards.push({"_id": titleWords.ID,
									  "name": titleWords.name});
				currTitleWords.push({"wtype": type, "word": randWord});
			}
		}
		return title;
	}

	private function titleFromCombo(combo:String,
								    cardWords:Array<Dynamic>):String
	{
		var requirements:Map<String, Int> = requirementsFromCombo(combo);

		var wordLocs:Map<String, Array<Int>> = getReqWordLocs(requirements, cardWords);
		if (wordLocs == null) return null;

		var reqOrder:Array<String> = getReqOrder(requirements, wordLocs);

		var title:String = placeWordsInCombo(combo,
											 requirements,
											 reqOrder,
											 cardWords,
											 wordLocs);
		return title;
	}

	public function nonPlotCards():Array<CardData>
	{
		var retCards:Array<CardData> = new Array<CardData>();
		for (i in 0...cardsByType.length)
		{
			if (i == CardData.TYPE_PLOT) continue;

			for (j in 0...cardsByType[i].length)
			{
				var cd:CardData =
					GameRegistry.cards.getCardByID(cardsByType[i][j]);
				if (cd != null) retCards.push(cd);
			}
		}

		return retCards;
	}

	public function attrCombos():Map<Int, Int>
	{
		var attrs:Map<Int, Int> = new Map<Int, Int>();

		var hypeReg:EReg = ~/hype/;
		for (cid in cards)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cid);
			if (cd == null) continue;
			if (cd.attributes == null) continue;
			if (cd.cardType == CardData.TYPE_SPECIAL) continue;

			for (aid in cd.attributes)
			{
				// don't count male or female attributes
				if (aid == Attributes.ATT_MALE) continue;
				if (aid == Attributes.ATT_FEMALE) continue;

				if (attrs.exists(aid))
				{
					var amount:Int = attrs.get(aid);
					amount = amount + 1;
					attrs.set(aid, amount);
				}
				else
				{
					var count:Int = 1;

					// Hype attributes are an automatic combo
					var attr:String = Attributes.getAtt(aid);
					attr = attr.toLowerCase();
					if (hypeReg.match(attr)) count = 2;

					attrs.set(aid, count);
				}
			}
		}


		for (aid in attrs.keys())
		{
			if (attrs.get(aid) < 2) attrs.remove(aid);
		}

		return attrs;
	}

	public function starAvg():Float
	{
		if (cards.length < 1) return 0;

		var starTotal:Int = 0;
		for (cid in cards)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cid);
			if (cd == null) continue;

			starTotal = starTotal + cd.grade;
		}

		var avg:Float = starTotal / cards.length;
		return avg;
	}

	public function debugPrintContents():Void
	{
		trace('CARDS: ');
		for (cid in cards)
		{
			var cd:CardData = GameRegistry.cards.getCardByID(cid);
			if (cd == null) continue;

			trace('    ' + cd.ID + ': ' + cd.cardName);
		}

		if (people.length > 0)
		{
			trace('    PEOPLE');
		}

		for (i in 0...people.length)
		{
			people[i].debugPrint();
		}

	}

	public static function sameGenres(pd1:PosterData, pd2:PosterData)
	{
		var genres1:Array<Int> = pd1.findGenres();
		var genres2:Array<Int> = pd2.findGenres();

		genres1.sort(function (a:Int, b:Int) {
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});

		genres2.sort(function (a:Int, b:Int) {
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});

		if (genres1.length != genres2.length) return false;

		for (i in 0...genres1.length)
		{
			if (genres1[i] != genres2[i]) return false;
		}

		return true;
	}

	public static function similarGenres(pd1:PosterData, pd2:PosterData):Bool
	{
		var genres1:Array<Int> = pd1.findGenres();
		var genres2:Array<Int> = pd2.findGenres();

		for (i in 0...genres1.length)
		{
			for (j in 0...genres2.length)
			{
				if (genres1[i] == genres2[j]) return true;
			}
		}

		return false;
	}

	public function getCards():Array<CardData>
	{
		var cds:Array<CardData> = new Array<CardData>();
		if (cardsByType == null) return cds;
		for (i in 0...cardsByType.length)
		{
			for (j in 0...cardsByType[i].length)
			{
				var cd:CardData = GameRegistry.cards.getCardByID(cardsByType[i][j]);
				if (cd != null) cds.push(cd);
			}
		}

		return cds;
	}
}

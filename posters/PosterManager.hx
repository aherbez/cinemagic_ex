package com.jamwix.hs.posters;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import com.jamwix.hs.cards.Card;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.GameRegistry;
import com.jamwix.hs.posters.Poster;
import com.jamwix.hs.posters.PosterData;
import com.jamwix.utils.JWUtils;

/**
 * ...
 * @author Adrian Herbez
 */
 
class PosterManager extends Sprite
{
	private var _cardList:TextField;
	public var currPosterBMD:BitmapData;
	
	public function new () 
	{
		super();
		
		_cardList = new TextField();
		_cardList.mouseEnabled = false;
		_cardList.text = 'CARDS';
		_cardList.width = 400;
		_cardList.height = 300;
		addChild(_cardList);
	}		

	public function addCard(c:Card):Void
	{
		trace('ADDING CARD');
		_cardList.text = _cardList.text + "\n" + c.cd.cardName;
		GameRegistry.poster.addCard(c.cd);
	}
	
	public function reset():Void
	{
		_cardList.text = '';
	}

	public function renderCurrPoster(?pd:PosterData = null):Bitmap
	{
		var poster:Poster = new Poster();
		if (pd != null)
		{
			poster.createFromPosterData(pd);
		}
		else
		{
			poster.createFromPosterData(GameRegistry.game.posterDat);
		}

		currPosterBMD = JWUtils.sprToBMD(poster);
		return new Bitmap (currPosterBMD, true);
	}

	public function renderPosterAsync(pd:PosterData, cb:BitmapData->Void):Void
	{
		GameRegistry.posterMaker.renderPoster(pd, function (poster:BitmapData):Void {
			currPosterBMD = poster;
			cb(poster);
		});
	}
}

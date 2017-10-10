package com.jamwix.hs.posters;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.BlendMode;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Rectangle;
import openfl.geom.Point;

import com.jamwix.hs.cards.Attributes;

import haxe.Json;

import com.jamwix.utils.ImgSprite;
import com.jamwix.utils.JamSprite;
import com.jamwix.utils.JWUtils;
import com.jamwix.hs.cards.CardData;

/**
 * ...
 * @author Adrian Herbez
 */
class CharacterSprite extends JamSprite
{

	static private var ASSET_BASE:String = 'assets/graphics/cards/characters/';
	static private var ACTOR_BASE:String = 'assets/graphics/cards/actors/';

	static private var SUFFIX_MALE:String = '_m';
	static private var SUFFIX_FEMALE:String = '_f';

	// art and position data for the default male/female bodies
	static private var DEFAULT_MALE_FX:String = '{"skin_c":"#efc2ba","regis": [336,94],"pos_h":[-23,-57],"pos_h":[-23,-57],"pos_h":[-23,-57],"skin":1,"pos_cloth":[-169,51],"pos_skin":[-103,3]}';
	static private var DEFAULT_FEMALE_FX:String = '{"skin_c":"#efc4ba","regis": [339,105],"pos_h":[-24,-55],"pos_h":[-24,-55],"pos_h":[-24,-55],"skin":1,"pos_cloth":[-111,54],"pos_skin":[-96,-2]}';

	static private var DEFAULT_ACTOR_PREFIX:String = 'stock';

	static private var DEFAULT_FX:String = '{"uni":0,"artdat":[' + DEFAULT_MALE_FX + ',' + DEFAULT_FEMALE_FX + ']}';

	static private var DEFAULT_DATA:Dynamic = null;

	private var _clothing:ImgSprite;
	private var _accessories:ImgSprite;
	private var _skin:Sprite;
	private var _skinBM:Bitmap;
	private var _shadowsBM:Bitmap;
	private var _highlightsBM:Bitmap;
	private var _shading:ImgSprite;
	private var _head:Sprite;
	private var _headImg:ImgSprite;
	private var _hairImg:ImgSprite;
	private var _hatImg:ImgSprite;

	private var _headPos:Array<Int>;
	private var _skinTone:Int;
	private var _showSkin:Bool;
	private var _hasAccessories:Bool;

	private var _bmd:BitmapData;
	private var _skinBmd:BitmapData;
	private var _default:Bool;	// if true, this character sprite is just a default wrapper around an actor

	private var _artData:Dynamic;
	private var _charName:String;
	private var _gender:Int;

	private var _hasHat:Bool;
	private var _hasHair:Bool;

	private var _debug:Sprite;

	private var _doOffset:Bool = false;
	public var coffset:Point;

	// public function new(char_prefix:String, actor:String, skin:Int)
	public function new(?cd:CardData, ?charNum:Int = 0, ?doOffset:Bool = false, ?isFemale:Bool = false, ?bmdMap:Map<String, BitmapData>)
	{
		super();

		_doOffset = doOffset;
		_default = true;
		_hasHat = false;

		var dataStr:String;

		_gender = 0;

		dataStr = DEFAULT_FX;
		if (DEFAULT_DATA == null)
		{
			DEFAULT_DATA = Json.parse(dataStr);
		}

		_charName = DEFAULT_ACTOR_PREFIX;
		_default = true;

		if (cd != null)
		{

			dataStr = cd.effects;
			_default = false;
			_charName = cd.imgSrc;

			var dat:Dynamic = Json.parse(dataStr);
			// trace(dat);
			if (dat.uni != null && dat.uni == 0)
			{
				if (dat.defgen != null)
				{
					_gender = dat.defgen;
				}

				// TODO: would be cool to have gender randomized, but it needs to be consistent across display for any given card
				/*
				// commenting this out for now
				if (cd.cardType == CardData.TYPE_CHARACTER)
				{
					_gender = GameRegistry.cards.getGender(cd.ID);
				}
				*/
			}

			if (dat.hat != null && dat.hat == 1)
			{
				_hasHat = true;
			}
		}
		/*
		else
		{
			dataStr = DEFAULT_FX;
			_charName = 'default';
		}
		*/

		_artData = Json.parse(dataStr);

		if (isFemale) _gender = 1;
		coffset = new Point(0, 0);
		setupArt(bmdMap);

		// FIXME: remove this, as it's a hacky, quick way to position characters (should really come from plot cards)

		/*
		if (charNum == 0)
		{
			// position character so that the head is towards the left
			this.x = -_head.x + 50;
		}
		else
		{
			// position character so that the head is towards the right
			this.x = Poster.POSTER_WIDTH + _head.x - 50;
			this.scaleX = -1;
		}
		*/
	}

	private function setupArt(bmdMap:Map<String, BitmapData> = null):Void
	{
		while (this.numChildren > 0)
		{
			this.removeChildAt(0);
		}

		// var data:Dynamic = Json.parse(dataStr);
		var data:Dynamic;
		var defaultData = DEFAULT_DATA.artdat[_gender];
		var name:String;

		if (_artData.artdat != null)
		{
			data = _artData.artdat[_gender];
		}
		else
		{
			data = _artData;
		}

		name = _charName;
		var defName:String = DEFAULT_ACTOR_PREFIX;

		if (_gender == 0)
		{
			name += SUFFIX_MALE;
			defName += SUFFIX_MALE;
		}
		else
		{
			name += SUFFIX_FEMALE;
			defName += SUFFIX_FEMALE;
		}

		if (_artData.uni == null || _artData.uni == 1)
		{
			name = _charName;
		}

		_head = new Sprite();
		if (data.pos_h != null)
		{
			_head.x = data.pos_h[0];
			_head.y = data.pos_h[1];
		}
		else
		{
			_head.x = defaultData.pos_h[0];
			_head.y = defaultData.pos_h[1];
		}

		if (_head.x < coffset.x) coffset.x = _head.x;
		if (_head.y < coffset.y) coffset.y = _head.y;

		var headPath:String = ASSET_BASE + 'chr_head_' + name + '.png';
		var defHeadPath:String = ASSET_BASE + 'chr_head_' + defName + '.png';
		// trace("OPENING HEAD: " + headPath);
		if (bmdMap != null && bmdMap.exists(headPath))
		{
			_headImg = new ImgSprite(headPath, defHeadPath, false, bmdMap.get(headPath));
		}
		else
		{
			_headImg = new ImgSprite(headPath, defHeadPath);
		}
		_head.addChild(_headImg);
/*
		_headPos = new Array<Int>();
		_headPos[0] = data.pos_h[0];
		_headPos[1] = data.pos_h[1];
*/
		_skin = new Sprite();
		addChild(_skin);

		_showSkin = false;
		if (data.skin == 1) _showSkin = true;

		if (_showSkin)
		{
			_skinTone = Std.parseInt('0x' + data.skin_c.substr(1,6));

			var skinPath:String = ASSET_BASE + 'chr_skin_' + name + '.jpg';
			var defSkinPath:String =
				ASSET_BASE + 'chr_skin_' + defName + '.jpg';
			// trace("OPENING SKIN: " + skinPath);
			if (bmdMap != null && bmdMap.exists(skinPath))
			{
				_bmd = bmdMap.get(skinPath);
			}
			else
			{
				_bmd = JWUtils.getBitmapData(skinPath, true);
			}

			if (_bmd == null)
			{
				trace("No skin file " + skinPath);
				if (bmdMap != null && bmdMap.exists(defSkinPath))
				{
					_bmd = bmdMap.get(defSkinPath);
				}
				else
				{
					_bmd = JWUtils.getBitmapData(defSkinPath, true);
				}
			}

			setSkinTone();

			if (data.pos_skin != null)
			{
				_skin.x = data.pos_skin[0];
				_skin.y = data.pos_skin[1];
			}
			else
			{
				_skin.x = defaultData.pos_skin[0];
				_skin.y = defaultData.pos_skin[1];
			}

			if (_skin.x < coffset.x) coffset.x = _skin.x;
			if (_skin.y < coffset.y) coffset.y = _skin.y;

			/*
			if (data.pos_skin != null)
			{
				_shadowsBM.x = data.pos_skin[0];
				_shadowsBM.y = data.pos_skin[1];
			}
			else
			{
				_shadowsBM.x = defaultData.pos_skin[0];
				_shadowsBM.y = defaultData.pos_skin[1];
			}


			if (data.pos_skin != null)
			{
				_highlightsBM.x = data.pos_skin[0];
				_highlightsBM.y = data.pos_skin[1];
			}
			else
			{
				_highlightsBM.x = defaultData.pos_skin[0];
				_highlightsBM.y = defaultData.pos_skin[1];
			}
			*/
			// addChild(_highlightsBM);
		}

		var clothPath:String = ASSET_BASE + 'chr_cloth_' + name + '.png';
		var defClothPath:String = ASSET_BASE + 'chr_cloth_' + defName + '.png';
		// trace("OPENING CLOTH: " + clothPath);
		if (bmdMap != null && bmdMap.exists(clothPath))
		{
			_clothing = new ImgSprite(clothPath, defClothPath, false, bmdMap.get(clothPath));
		}
		else
		{
			_clothing = new ImgSprite(clothPath, defClothPath);
		}

		if (data.pos_cloth != null)
		{
			_clothing.x = data.pos_cloth[0];
			_clothing.y = data.pos_cloth[1];

		}
		else
		{
			_clothing.x = defaultData.pos_cloth[0];
			_clothing.y = defaultData.pos_cloth[1];
		}

		if (_clothing.x < coffset.x) coffset.x = _clothing.x;
		if (_clothing.y < coffset.y) coffset.y = _clothing.y;

		addChild(_clothing);
		addChild(_head);

		_hasAccessories = false;
		if (data.accessories == 1) _hasAccessories = true;

		if (_hasAccessories)
		{
			var accPath:String = ASSET_BASE + 'chr_access_' + name + '.png';
			var defAccPath:String =
				ASSET_BASE + 'chr_access_' + defName + '.png';
			// trace("OPENING ACCESSORIES: " + accPath);

			if (bmdMap != null && bmdMap.exists(accPath))
			{
				_accessories = new ImgSprite(accPath, null, false, bmdMap.get(accPath));
			}
			else
			{
				_accessories = new ImgSprite(accPath);
			}

			if (data.pos_acces != null)
			{
				_accessories.x = data.pos_acces[0];
				_accessories.y = data.pos_acces[1];
			}
			else
			{
				_accessories.x = defaultData.pos_acces[0];
				_accessories.y = defaultData.pos_acces[1];
			}

			if (_accessories.x < coffset.x) coffset.x = _accessories.x;
			if (_accessories.y < coffset.y) coffset.y = _accessories.y;

			addChild(_accessories);
		}

		if (data.hat != null && data.hat == 1)
		{
			_hasHat = true;

			var hatPath:String = ASSET_BASE + 'chr_hat_' + name + '.png';
			if (bmdMap != null && bmdMap.exists(hatPath))
			{
				_hatImg = new ImgSprite(hatPath, null, false, bmdMap.get(hatPath));
			}
			else
			{
				_hatImg = new ImgSprite(hatPath);
			}

			if (data.hat_pos != null && data.hat_pos[0] != null && data.hat_pos[1] != null)
			{
				_hatImg.x = Std.parseInt(data.hat_pos[0]);
				_hatImg.y = Std.parseInt(data.hat_pos[1]);
			}

			if (_hatImg.x < coffset.x) coffset.x = _hatImg.x;
			if (_hatImg.y < coffset.y) coffset.y = _hatImg.y;

			addChild(_hatImg);
		}


		if (_doOffset)
		{
			if (_head != null) _head.x += coffset.x * -1;
			if (_head != null) _head.y += coffset.y * -1;
			if (_skin != null) _skin.x += coffset.x * -1;
			if (_skin != null) _skin.y += coffset.y * -1;
			if (_clothing != null) _clothing.x += coffset.x * -1;
			if (_clothing != null) _clothing.y += coffset.y * -1;
			if (_accessories != null) _accessories.x += coffset.x * -1;
			if (_accessories != null) _accessories.y += coffset.y * -1;
			if (_hatImg != null) _hatImg.x += coffset.x * -1;
			if (_hatImg != null) _hatImg.y += coffset.y * -1;
		}

		/*
		_debug = new Sprite();
		_debug.graphics.beginFill(0xff0000, 1);
		_debug.graphics.drawCircle(0, 0, 10);
		addChild(_debug);
		*/
	}

	public function setActor(cd:CardData, bmdMap:Map<String, BitmapData> = null):Void
	{
		// if actor gender != current gender && unisex == 0
		if (_artData.uni != null && _artData.uni == 0)
		{
			// var isFemale:Bool = cd.hasAttribute(CardData.ATT_FEMALE);
			var newGender:Int = cd.hasAttribute(Attributes.ATT_FEMALE) ? 1 : 0;

			if (_gender != newGender)
			{
				// swap out all the art
				_gender = newGender;
				setupArt();
			}
		}

		var data:Dynamic = Json.parse(cd.effects);
		// trace(cd.cardName + ': DATA: ');
		// trace(data);
		if (_showSkin)
		{
			if (data.skin != null)
			{
				_skinTone = Std.parseInt('0x' + data.skin.substr(1,6));
			}
			if (data.skin_c != null)
			{
				_skinTone = Std.parseInt('0x' + data.skin_c.substr(1,6));
			}
			setSkinTone();
		}

		// set up the head
		_head.removeChild(_headImg);
		var headPath:String = ACTOR_BASE + 'act_' + cd.imgSrc + '.png';
		if (bmdMap != null && bmdMap.exists(headPath))
		{
			_headImg = new ImgSprite(headPath, null, false, bmdMap.get(headPath));
		}
		else
		{
			_headImg = new ImgSprite(headPath);
		}

		_headImg.x = 0;
		_headImg.y = 0;

		if (data.pos_h != null)
		{
			_head.x = data.pos_h[0];
			_head.y = data.pos_h[1];
		}
		_head.addChild(_headImg);

		if (data.hair != null && data.hair == 1)
		{
			// add hair, unless the character has a hat
			if (_hasHat == false)
			{
				if (_hairImg != null)
				{
					_head.removeChild(_hairImg);
				}

				var hairPath:String = ACTOR_BASE + 'act_' + cd.imgSrc + '_hair.png';
				if (bmdMap != null && bmdMap.exists(hairPath))
				{
					_hairImg = new ImgSprite(hairPath, null, false, bmdMap.get(hairPath));
				}
				else
				{
					_hairImg = new ImgSprite(hairPath);
				}
				_hairImg.x = Std.parseInt(data.pos_hair[0]) - _head.x;
				_hairImg.y = Std.parseInt(data.pos_hair[1]) - _head.y;
				_head.addChild(_hairImg);

			}
		}

		var defaultData = DEFAULT_DATA.artdat[_gender];
		var oldY:Float = defaultData.pos_h[1];
		var hairY:Float = _hairImg != null ? _hairImg.y : 0;
		var yOff:Float = _head.y - oldY + hairY;
		coffset.y += yOff;

		if (_doOffset)
		{
			if (_head != null) _head.x += coffset.x * -1;
			if (_head != null) _head.y += coffset.y * -1;

			if (_skin != null) _skin.y -= yOff;
			if (_clothing != null) _clothing.y -= yOff;
			if (_accessories != null) _accessories.y -= yOff;
			if (_hatImg != null) _hatImg.y -= yOff;
		}

	}

	private function setSkinTone():Void
	{
		if (_skin.numChildren > 0)
		{
			_skin.removeChildAt(0);
		}

		if (_bmd == null) return;

		_skinBmd = new BitmapData(_bmd.width, _bmd.height, true);

		// change the skin tone to match the actor
		#if neko
		_skinBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), {a:0xFF, rgb:_skinTone} );
		#else
		_skinBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), _skinTone );
		#end
		_skinBmd.copyChannel(_bmd, new Rectangle(0, 0, _bmd.width, _bmd.height), new Point(0,0), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);

		_skinBM = new Bitmap(_skinBmd);
		_skin.addChild(_skinBM);

		setSkinShading();
	}

	private function setSkinShading()
	{
		if (_shadowsBM != null)
		{
			_skin.removeChild(_shadowsBM);
		}
		if (_highlightsBM != null)
		{
			_skin.removeChild(_highlightsBM);
		}

		/*
		123456

		r = floor(123456 / 3456)
		g = 123456 - (r * 12) // 3456
		g = floor(3456 / 56)
		b = 123456 % 56
		*/

		// make colors from _skinTone
		// highlights: lighter

		var red:Int = (_skinTone >> 16) & 0xFF;
		var green:Int = (_skinTone >> 8) & 0xFF;
		var blue:Int = _skinTone & 0xFF;

		var shadowColor = (Std.int(red * 0.5) << 16) + (Std.int(green * 0.5) << 8) + (Std.int(blue * 0.5));

		red = Std.int(Math.min(Std.int(red * 1.5), 255));
		green = Std.int(Math.min(Std.int(green * 1.5), 255));
		blue = Std.int(Math.min(Std.int(blue * 1.5), 255));

		var highlightColor = (red << 16) + (green << 8) + blue;
		// highlightColor = 0xFFFFFF;
		// shadows: darker

		var shadingBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, true);
		#if neko
		shadingBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), {a: 0xFF, rgb: shadowColor});
		#else
		shadingBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), shadowColor);
		#end
		shadingBmd.copyChannel(_bmd, new Rectangle(0, 0, _bmd.width, _bmd.height), new Point(0,0), BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);

		_shadowsBM = new Bitmap(shadingBmd);
		_shadowsBM.blendMode = BlendMode.MULTIPLY;
		_shadowsBM.alpha = 0.7;


		var highlightBmd:BitmapData = new BitmapData(_bmd.width, _bmd.height, true);
		#if neko
		highlightBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), {a: 0xFF, rgb: highlightColor});
		#else
		highlightBmd.fillRect(new Rectangle(0, 0, _bmd.width, _bmd.height), highlightColor);
		#end
		highlightBmd.copyChannel(_bmd, new Rectangle(0, 0, _bmd.width, _bmd.height), new Point(0,0), BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);

		_highlightsBM = new Bitmap(highlightBmd);
		_highlightsBM.blendMode = BlendMode.LIGHTEN;
		_highlightsBM.alpha = 0.7;

		_skin.addChild(_shadowsBM);
		_skin.addChild(_highlightsBM);
	}

	public override function dispose():Void
	{
		if (_head != null)
		{
			_head.removeChild(_headImg);
			_head.removeChild(_hairImg);
		}

		if (_skin != null)
		{
			_skin.removeChild(_skinBM);
			_skin.removeChild(_shadowsBM);
			_skin.removeChild(_highlightsBM);
		}

		removeChild(_skin);
		removeChild(_clothing);
		removeChild(_head);
		removeChild(_accessories);
		removeChild(_hatImg);

		if (_clothing != null) _clothing.dispose();
		if (_accessories != null) _accessories.dispose();
		if (_shading != null) _shading.dispose();
		if (_headImg != null) _headImg.dispose();
		if (_hairImg != null) _hairImg.dispose();
		if (_hatImg != null) _hatImg.dispose();
		if (_skinBM != null)
		{
			//_skinBM.bitmapData.dispose();
			_skinBM.bitmapData = null;
		}

		if (_shadowsBM != null)
		{
			//_shadowsBM.bitmapData.dispose();
			_shadowsBM.bitmapData = null;
		}

		if (_highlightsBM != null)
		{
			//_highlightsBM.bitmapData.dispose();
			_highlightsBM.bitmapData = null;
		}

		//if (_bmd != null) _bmd.dispose();
		if (_skinBmd != null) _skinBmd.dispose();

		_headImg = null;
		_hairImg = null;
		_head = null;
		_skinBM = null;
		_shadowsBM = null;
		_highlightsBM = null;
		_skin = null;
		_clothing = null;
		_accessories = null;
		_hatImg = null;
		_shading = null;
		_bmd = null;
		_skinBmd = null;
		_artData = null;
		_charName = null;
		_headPos = null;
		_debug = null;
	}

}

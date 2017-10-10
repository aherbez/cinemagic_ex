package com.jamwix.hs.posters;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.Font;
import openfl.Assets;
import openfl.filters.GlowFilter;
import openfl.filters.DropShadowFilter;
import openfl.filters.BlurFilter;
import openfl.display.GradientType;
import openfl.geom.Matrix;
import haxe.Json;
import openfl.geom.Rectangle;
import openfl.geom.Point;

import com.jamwix.hs.ui.FontManager;
import com.jamwix.utils.ImgSprite;
import com.jamwix.utils.JWUtils;
import com.jamwix.hs.cards.CardData;
import com.jamwix.hs.cards.PersonData;
import com.jamwix.hs.posters.CharacterSprite;
import com.jamwix.hs.GameRegistry;
import com.jamwix.utils.JamSprite;


/**
 * ...
 * @author Adrian Herbez
 */

// struct to hold rasterized text and an accurate height 
class PosterTextSprite extends Sprite
{	
	public var textHeight:Float;

	public function new()
	{
		super();
	}
}

 
class Poster extends JamSprite
{
	static private var DEFAULT_BACK_SRC:String = 'assets/graphics/ret/default_poster_back.jpg';
	static private var OVERLAY_SRC:String = 'assets/graphics/ret/poster_overlay.png';
	static private var CARD_ART_LOC:String = 'assets/graphics/cards/';

	// Default positioning for characters. This can be overriden by some plots.
	static private var POSTER_TEMPLATE_STRINGS:Array<String> = [
	'{"tagline": {"y": 13, "x": 61, "w": 634, "h": 100}, "numactors": 1, "actors": [{"x": 180, "scale": 1.76, "flip": 1, "y": 179}, 0], "actnames": [{"y": 920, "x": 35, "w": 266, "h": 60}, 0], "title": {"y": 600, "x": 96, "w": 544, "h": 270}}',
'{"tagline": {"y": 13, "x": 61, "w": 634, "h": 100}, "numactors": 2, "actors": [{"x": 153, "scale": 1.144, "flip": 1, "y": 397}, {"x": 612, "scale": 1.147, "flip": 0, "y": 397}], "actnames": [{"y": 920, "x": 35, "w": 266, "h": 60}, {"y": 920, "x": 445, "w": 266, "h": 60}], "title": {"y": 600, "x": 96, "w": 544, "h": 270}}'];
		
	static private var TAGLINE_X:Int = 61;
	static private var TAGLINE_Y:Int = 13;
	static private var TAGLINE_W:Int = 634;
	static private var TAGLINE_H:Int = 100;

	static private var _posterTemplates:Array<Dynamic>;
	
	private var _template:Dynamic;
	private var _taglinePos:Dynamic;
	private var _titlePos:Dynamic;
	private var _actorNamePos:Array<Dynamic>;
	private var _actorPos:Array<Dynamic>;
	
	// note: using 338x500 for art for now (for size)
	static public var POSTER_WIDTH:Int = 750;
	static public var POSTER_HEIGHT:Int = 1000;
	
	static private var CHARACTER_POS:Array<Array<Int>> = [ [150, 200], [600, 200] ];

	private var _frame:ImgSprite;
	
	private var _posterMain:Sprite;
	
	// layers, in order from bottom to top
	private var _backImg:ImgSprite;
	private var _background:Sprite;		// background gradient / color (set by plot?)
	private var _plotBack:Sprite;		// additions from the plot (back)
	private var _location:ImgSprite;	// location goes here
	private var _actors:Sprite;			// faces go here	
	private var _characters:Sprite;		// bodies go here
	private var _charactersMask:Bitmap;
	// private var _charactersMaskBMD:BitmapData;	// optional masks for characters
	private var _characterMaskSrc:BitmapData;	//
	private var _characterMaskSprite:Sprite; 
	private var _extras:Sprite;			// extra stuff
	private var _titles:Sprite; 		// title
	private var _plotFront:Sprite;		// stuff that goes on top
	
	private var _characterSprites:Array<JamSprite>;
	private var _titleSprites:Array<TextField>;
	private var _tf:TextFormat;
	private var _tagline:TextField;
	
	private var _pd:PosterData;

	private var _overlay:ImgSprite;

	private var _mainGenre:Int;
	
	private var headToPlace:Int;
	
	private var _plotAdded:Bool;

	
	private static var TITLE_GLOW_ALPHA:Float = 0.8;
	
	public function new() 
	{
		super();	
		
		if (_posterTemplates == null)
		{
			_posterTemplates = new Array<Dynamic>();
			
			for (i in 0...2)
			{
				_posterTemplates[i] = Json.parse(POSTER_TEMPLATE_STRINGS[i]);
			}
		}
		
		_template = _posterTemplates[0];
		_actorNamePos = new Array<Dynamic>();
		_actorPos = new Array<Dynamic>();
		
		_characterSprites = new Array<JamSprite>();
		_titleSprites = new Array<TextField>();

		_backImg = new ImgSprite(DEFAULT_BACK_SRC);
		addChild(_backImg);

		scrollRect = new Rectangle(0, 0, Poster.POSTER_WIDTH, Poster.POSTER_HEIGHT);
			
		_posterMain = new Sprite();
		addChild(_posterMain);
		
		var font:Font = Assets.getFont('assets/futura2.ttf');
		_tf = new TextFormat(font.fontName, 80, 0x000000);
		_tf.align = TextFormatAlign.CENTER;
				
		reset();
		
		headToPlace = 0;		
	}		
	
	public function createFromStats(data:Dynamic):Void
	{	
		reset();	
		var d:Array<Dynamic> = Json.parse(data.cards);
		
		for (i in 0...d.length)
		{
			addCardById(Std.int(d[i]));
		}			
	}
	
	public function createFromPosterData(pd:PosterData):Void
	{
		reset();
		
		_pd = pd;

		var templateIndex:Int = (pd.people.length > 1) ? 1 : 0;
		
		_titlePos = _posterTemplates[templateIndex].title;
		_taglinePos = _posterTemplates[templateIndex].tagline;
		for (i in 0...2)
		{
			_actorNamePos[i] = _posterTemplates[templateIndex].actnames[i];
			_actorPos[i] = _posterTemplates[templateIndex].actors[i];
		}
		
		var cd:CardData = pd.getMainPlot();
		if (cd != null)
		{
			var templateData:Dynamic = Json.parse(cd.effects);
			
			if (templateData.people != null)
			{
				if (pd.people.length > 1)
				{	
					if (templateData.people.a2 != null &&
						templateData.people.b2 != null)	
					{
						_actorPos[0] = templateData.people.a2;
						_actorPos[1] = templateData.people.b2;

						if (_actorPos[0].x != null && _actorPos[1].x != null)
						{
							// if the second actor is to the left of the first
							if (_actorPos[0].x > _actorPos[1].x)
							{
								// swap the name positions
								var temp:Dynamic = _actorNamePos[0];
								_actorNamePos[0] = _actorNamePos[1];
								_actorNamePos[1] = temp;
							}
						}
					}					
				}
				else
				{
					if (templateData.people.a1 != null)	
					{
						_actorPos[0] = templateData.people.a1;
					}
				}
			}
		}
		
		
		_mainGenre = -1;
		var genres:Array<Int> = pd.findGenres();
		if (genres.length > 0)
		{
			_mainGenre = genres[0];
		}
		
		// Add plots and locations
		for (i in 0...pd.cardsByType.length)
		{
			if (i != CardData.TYPE_ACTOR && i != CardData.TYPE_CHARACTER)
			{
				for (j in 0...pd.cardsByType[i].length)
				{
					addCardById(pd.cardsByType[i][j]);
				}
			}
		}

		// Add actor/character combos
		if (pd.people.length == 1)
		{
			addPerson(pd.people[0], 0, 0);
		}
		else if (pd.people.length == 2)
		{
			addPerson(pd.people[1], 1, 1);
			addPerson(pd.people[0], 0, -1);
		}
		else
		{
			// we never actually allowed more than 2 people, but we might have eventually
			for (i in 0...pd.people.length)
			{
				addPerson(pd.people[i], i);
			}
		}
		
		setTitle(pd.getTitle());
		setTagline(pd.getTagline());

		if (_overlay == null)
		{
			_overlay = new ImgSprite(OVERLAY_SRC);
		}	
		else
		{
			removeChild(_overlay);
		}
		
		_overlay.alpha = 0.75;
		_extras.addChild(_overlay);
	}
	
	public function addCards(cards:Array<Int>):Void
	{
		reset();
	
		for (i in 0...cards.length)
		{
			addCardById(cards[i]);
		}
	
	}
	
	public function addCardById(cid:Int):Void
	{
		addCard(GameRegistry.cards.getCardByID(cid));
	}
	
	
	private function addPerson(pd:PersonData, ?num:Int = 0, ?justify:Int = -2):Void
	{
		if (num > 1) return;

		_characters.mask = null;
		_characters.removeChild(_characterMaskSprite);

		var characterCd:CardData = null;
		var actorCd:CardData = null;
		var cd:CardData = null;
		if (pd.characterID != -1)
		{
			characterCd = GameRegistry.cards.getCardByID(pd.characterID);
			cd = characterCd;
		}

		if (pd.actorID != -1)
			actorCd = GameRegistry.cards.getCardByID(pd.actorID);
		
		// try to get the art from our cache, if we can
		var js:JamSprite = null;
		if (characterCd != null && actorCd != null)
		{
			var combinedId:Int = CardData.combinedId(characterCd, actorCd);
			var artData:Dynamic = GameRegistry.cards.getCachedArt(combinedId);
			if (artData != null) js = artData.spr;
		}
		else if (characterCd != null)
		{
			js = GameRegistry.cards.getCachedArtSprite(characterCd.ID);
		}
		else
		{
			js = GameRegistry.cards.getCachedArtSprite(actorCd.ID);
		}

		if (js == null)
		{
			var cs:CharacterSprite = new CharacterSprite(cd, _characterSprites.length);
			if (pd.actorID != -1) cs.setActor(actorCd);

			js = cs;
		}
		
		if (actorCd != null)
		{
			var nameParts:Array<String> = actorCd.cardName.split(' ');
			var lastName:String = actorCd.getLastName();
			
			try {
				if (lastName != null && lastName != '')
				{
					var nameSpr:PosterTextSprite = 
						titleFromGenre(lastName.toUpperCase(), 
									   40, _actorNamePos[num].w, 60);
					nameSpr.x = _actorNamePos[num].x;
					nameSpr.y = _actorNamePos[num].y;
					
					_titles.addChild(nameSpr);
					if (justify == 0)
						nameSpr.x = (POSTER_WIDTH - nameSpr.width) / 2;
				}
			}
			catch (err:Dynamic)
			{
				trace('ERROR: missing name tempalte info');
			}
		}

		try {
			
			js.scaleX = _actorPos[num].scale;
			js.scaleY = _actorPos[num].scale;
			js.x = _actorPos[num].x;
			js.y = _actorPos[num].y;

			// add a mask, if information for it exists
			if (_actorPos[num].mask != null && _actorPos[num].mask == 1)
			{
				if (this._characterMaskSrc == null)
				{
					if (_pd != null)
					{
						var plotData:CardData = _pd.getMainPlot();
						_characterMaskSrc = JWUtils.getBitmapData(CARD_ART_LOC + 'plot/' + plotData.imgSrc + '_masks.png');
					}
				}

				var characterMaskBMD:BitmapData;
				var characterMask:Bitmap;

				#if neko		
						characterMaskBMD = new BitmapData(750, 1000, true, {rgb: 0x000000, a: 0});
				#else
						characterMaskBMD = new BitmapData(750, 1000, true, 0x00000000);
				#end					
				var characterMaskSprite:Sprite = new Sprite();

				var r:Rectangle = new Rectangle(_actorPos[num].mcx, 0, _actorPos[num].mw, _actorPos[num].mh);
				var p:Point = new Point(_actorPos[num].mx, _actorPos[num].my);

				characterMaskBMD.copyPixels(_characterMaskSrc, r, p, _characterMaskSrc);
				characterMask = new Bitmap(characterMaskBMD);

				_characterMaskSprite.addChild(characterMask);
			}	
			
		}
		catch (error:Dynamic)
		{
			trace('ERROR: missing template information');
		}
				
		if (_actorPos[num].flip != 0)
		{
			js.scaleX = _actorPos[num].scale * -1;
		}
		
		_characters.addChild(js);
		_characterSprites.push(js);

		var tempBMD:BitmapData; // = new BitmapData(750, 1000, true);
		
		#if neko		
				tempBMD = new BitmapData(750, 1000, true, {rgb: 0x000000, a: 0});
		#else
				tempBMD = new BitmapData(750, 1000, true, 0x00000000);
		#end

		tempBMD.draw(_characterMaskSprite);
		var tempBM:Bitmap = new Bitmap(tempBMD);
		_characters.addChild(tempBM);
		_characters.mask = tempBM;
		
	}
	
	public function addCard(cd:CardData):Void
	{		
		var bmd:BitmapData = GameRegistry.cards.getCachedArtBmd(cd.ID);

		if (cd.cardType == CardData.TYPE_LOCATION)
		{
			if (_background.numChildren > 0)
			{
				_background.removeChildAt(0);
			}
			_location = new ImgSprite(CARD_ART_LOC + 'locs/loc_' + cd.imgSrc + '.jpg', null, true, bmd);
			_location.width = POSTER_WIDTH;
			_location.height = POSTER_HEIGHT;
			_background.addChild(_location);
		}
		else if (cd.cardType == CardData.TYPE_CHARACTER || 
			cd.cardType == CardType.TYPE_ACTOR)
		{
			// characters and actors are special, and are handled elsewhere
			return;
		}
		else if (cd.cardType == CardData.TYPE_PLOT)
		{
			// add the front and back images, if they exist
			var data:Dynamic = Json.parse(cd.effects);
			
			// only add layers for the A plot
			if (_plotAdded)
			{
				return;
			}
			
			var layers:Int = Std.parseInt(data.lyr);
			
			if (layers & 2 != 0)
			{				
				// front layer
				var img:ImgSprite = new ImgSprite(CARD_ART_LOC + 'plot/' + cd.imgSrc + '_front.png');
				_plotFront.addChild(img);
			
			}
			if (layers & 4 != 0)
			{
				var img:ImgSprite = new ImgSprite(CARD_ART_LOC + 'plot/' + cd.imgSrc + '_back.png');
				_plotBack.addChild(img);	
			}
			
			_plotAdded = true;
		}
		else
		{
			trace('NON-IMPLEMENTED TYPE FOR: ' + cd.cardName);
		}
	}
	
	private function addMainTitle():Void
	{
		return;
		
		var title:TextField = new TextField();
		title.mouseEnabled = false;
		title.defaultTextFormat = _tf;
		title.multiline = true;
		title.wordWrap = true;
		
		// add some white around the edge for readibility
		title.filters = [new GlowFilter(0xFFFFFF, TITLE_GLOW_ALPHA, 5, 5, 10)];
		
		_titleSprites.push(title);
		_titles.addChild(title);
		
	}

	public function setTitle(newTitle:String):Void
	{
		var titleSpr:PosterTextSprite = titleFromGenre(newTitle.toUpperCase(), 100, _titlePos.w, 350);
	
		titleSpr.x = _titlePos.x;
		titleSpr.y = (_titlePos.y + _titlePos.h) - titleSpr.textHeight;
		
		_titles.addChild(titleSpr);
	}

	private function tfBounds(tf:TextField):Array<Rectangle>
	{
		var txtBMD:BitmapData = JWUtils.sprToBMD(tf);
#if neko
		var txtBounds:Rectangle = txtBMD.getColorBoundsRect(
			{rgb: 0xFFFFFF, a: 1}, {rgb: 0x0000FF, a: 1}
		);
#else
		var txtBounds:Rectangle = txtBMD.getColorBoundsRect(
			0xFFFFFF, 0x0000FF
		);
#end
		var lineHeight:Int = 
			Std.int(txtBounds.height / tf.numLines);
		var lineOffset:Int = Std.int(txtBounds.y);
		var bounds:Array<Rectangle> = new Array<Rectangle>();
		for (line in 0...tf.numLines)
		{
			var lineBMD:BitmapData = 
				JWUtils.newBMData(Std.int(tf.width), lineHeight);
			var lineBounds:Rectangle = 
				new Rectangle(0, (line * lineHeight) + lineOffset,
							  tf.width, lineHeight);
			lineBMD.copyPixels(txtBMD, lineBounds, new Point(0, 0));
#if neko
			var cropBounds:Rectangle = 
				lineBMD.getColorBoundsRect({rgb: 0xFFFFFF, a: 1}, 
										   {rgb: 0x0000FF, a: 1});
#else
			var cropBounds:Rectangle = 
				lineBMD.getColorBoundsRect(0xFFFFFF, 0x0000FF);
#end
			cropBounds.y = cropBounds.y + (line * lineHeight) + lineOffset;
			bounds.push(cropBounds);
		}

		return bounds;
	}

	private function createActionTitle(newTitle:String, fs:Int, w:Int, h:Int):PosterTextSprite
	{
		var titleTxt:TextField = new TextField();
		titleTxt.mouseEnabled = false;
		titleTxt.multiline = true;
		titleTxt.wordWrap = true;

		var gradSpr = new Sprite();
		titleTxt.defaultTextFormat = 
			FontManager.getTextFormatByGenre(_mainGenre, fs, 0x0000FF);
		
		titleTxt.width = w;
		titleTxt.height = h;
		titleTxt.text = newTitle;
		JWUtils.autoSizeFont(titleTxt);

		// Determine line bounding boxes
		titleTxt.textColor = 0x0000FF;
		var lineBounds:Array<Rectangle> = tfBounds(titleTxt);
		var gradColors:Array<Int> = [0xD9A001, 0x4197D4];
		var maxY:Float = 0;

		// if we're multilined
		if (titleTxt.numLines > 1 && lineBounds != null) 
		{
			for (i in 0...lineBounds.length)
			{
				var bounds:Rectangle = lineBounds[i];
				
				// make the first line a different gradient
				var gradColor:Int = gradColors[1];
				if (i == 0) gradColor = gradColors[0];

				var lineSpr:Sprite = JWUtils.createGradient(
					titleTxt.width, bounds.height, 0xFFFFFF, gradColor
				);
				lineSpr.y = bounds.y;
				gradSpr.addChild(lineSpr);

				maxY = bounds.y + bounds.height;
			}
		}
		// if we're just one line
		else if (lineBounds != null && lineBounds[0] != null)
		{
			var bounds:Rectangle = lineBounds[0];
			var gradColor:Int = gradColors[1];

			// make a background line gradient
			var lineSpr:Sprite = JWUtils.createGradient(
				titleTxt.width, bounds.height, 0xFFFFFF, gradColor
			);
			lineSpr.y = bounds.y;
			gradSpr.addChild(lineSpr);

			maxY = bounds.y + bounds.height;

			titleTxt.textColor = 0x000000;
			var words:Array<String> = newTitle.split(' ');
			titleTxt.htmlText = 
				'<font color="#0000FF">' + words.pop() + '</font>' + 
				'<font color="#000000">' + ' ' + words.join(' ') + '</font>';
			var wordBounds:Array<Rectangle> = tfBounds(titleTxt);

			// and a different gradient for the first word
			if (wordBounds != null && wordBounds[0] != null)
			{
				gradColor = gradColors[0];

				var wordSpr = JWUtils.createGradient(
					wordBounds[0].width, wordBounds[0].height,
					0xFFFFFF, gradColor
				);
				
				wordSpr.x = wordBounds[0].x;
				wordSpr.y = wordBounds[0].y;
				gradSpr.addChild(wordSpr);
			}

			titleTxt.text = newTitle;
			titleTxt.textColor = 0x0000FF;
		}

		gradSpr.height = maxY;

		// use the blue text as a mask via copyChannel to alpha
		var gradBMD:BitmapData = JWUtils.sprToBMD(gradSpr);
		var txtBMD:BitmapData = JWUtils.sprToBMD(titleTxt);
		gradBMD.copyChannel(
			txtBMD, 
			txtBMD.rect, 
			new Point(0, 0), 
			BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
				
		var posterTextSprite:PosterTextSprite = new PosterTextSprite();
		posterTextSprite.addChild(new Bitmap(gradBMD));
		posterTextSprite.filters = [new DropShadowFilter()];
		posterTextSprite.textHeight = titleTxt.textHeight;
				
		return posterTextSprite;
	}

	private function createAdventureTitle(
		newTitle:String, fs:Int, w:Int, h:Int):PosterTextSprite
	{
		var titleTxt:TextField = new TextField();
		titleTxt.mouseEnabled = false;
		titleTxt.multiline = true;
		titleTxt.wordWrap = true;

		var gradSpr = new Sprite();
		titleTxt.defaultTextFormat = 
			FontManager.getTextFormatByGenre(_mainGenre, fs, 0x0000FF);
		
		titleTxt.width = w;
		titleTxt.height = h;
		titleTxt.text = newTitle;
		JWUtils.autoSizeFont(titleTxt);

		// Determine line bounding boxes
		titleTxt.textColor = 0x0000FF;
		var lineBounds:Array<Rectangle> = tfBounds(titleTxt);
		var maxY:Float = 0;
		
		for (i in 0...lineBounds.length)
		{
			var bounds:Rectangle = lineBounds[i];
			
			var lineSpr:Sprite = JWUtils.createGradient(
				titleTxt.width, bounds.height, 0xFFFC00, 0xFF9B00
			);
			lineSpr.y = bounds.y;
			gradSpr.addChild(lineSpr);

			maxY = bounds.y + bounds.height;
		}
		
		gradSpr.height = maxY;

		// use the blue text as a mask via copyChannel to alpha
		var gradBMD:BitmapData = JWUtils.sprToBMD(gradSpr);
		var txtBMD:BitmapData = JWUtils.sprToBMD(titleTxt);
		gradBMD.copyChannel(
			txtBMD, 
			txtBMD.rect, 
			new Point(0, 0), 
			BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
				
		var posterTextSpr:PosterTextSprite = new PosterTextSprite();
		posterTextSpr.addChild(new Bitmap(gradBMD));
		posterTextSpr.filters = [new GlowFilter(0x000000, TITLE_GLOW_ALPHA, 2, 2, 10)];
		posterTextSpr.textHeight = titleTxt.textHeight;
		
		return posterTextSpr;
	}

	private function createRomanceTitle(
		newTitle:String, fs:Int, w:Int, h:Int):PosterTextSprite
	{
		var titleTxt:TextField = new TextField();
		titleTxt.mouseEnabled = false;
		titleTxt.multiline = true;
		titleTxt.wordWrap = true;

		titleTxt.defaultTextFormat = 
			FontManager.getTextFormatByGenre(_mainGenre, fs, 0x0000FF);
		
		titleTxt.width = w;
		titleTxt.height = h;
		titleTxt.text = newTitle;
		JWUtils.autoSizeFont(titleTxt);

		titleTxt.textColor = 0x0000FF;
		var colors = [0xFFC000, 0xF554FF];
		
		var posterTxtSpr:PosterTextSprite = new PosterTextSprite();

		// if we're multilined
		if (titleTxt.numLines > 1) 
		{
			var gradSpr = new Sprite();
			var lineBounds:Array<Rectangle> = tfBounds(titleTxt);
			var maxY:Float = 0;

			for (i in 0...lineBounds.length)
			{
				var bounds:Rectangle = lineBounds[i];
				
				// make the first line a different gradient
				var color:Int = colors[1];
				if (i == 0) color = colors[0];

				var lineSpr:Sprite = new Sprite();
				lineSpr.graphics.beginFill(color, 1);
				lineSpr.graphics.drawRect(0, 0, titleTxt.width, bounds.height);
				lineSpr.y = bounds.y;
				gradSpr.addChild(lineSpr);

				maxY = bounds.y + bounds.height;
			}

			gradSpr.height = maxY;

			// use the blue text as a mask via copyChannel to alpha
			var gradBMD:BitmapData = JWUtils.sprToBMD(gradSpr);
			var txtBMD:BitmapData = JWUtils.sprToBMD(titleTxt);
			gradBMD.copyChannel(
				txtBMD, 
				txtBMD.rect, 
				new Point(0, 0), 
				BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA);
			
			posterTxtSpr.addChild(new Bitmap(gradBMD));
		}
		// if we're just one line
		else
		{
			titleTxt.textColor = 0x000000;
			var words:Array<String> = newTitle.split(' ');

			var lastWord:String = words.pop();

			titleTxt.htmlText = 
				'<font color="#F554FF">' + ' ' + words.join(' ') + '</font>' + ' ' +
				'<font color="#FFC000">' + lastWord + '</font>';

			posterTxtSpr.addChild(titleTxt);
		}

		posterTxtSpr.filters = [new DropShadowFilter()];
		posterTxtSpr.textHeight = titleTxt.textHeight;
		return posterTxtSpr;
	}

	// We render text differently depending on the genre of movie
	private function titleFromGenre(newTitle:String, fs:Int, w:Int, h:Int):PosterTextSprite
	{
		var posterTextSpr:PosterTextSprite;

		if (_mainGenre == CardData.GENRE_ACTION || 
			_mainGenre == CardData.GENRE_ADVENTURE ||
			_mainGenre == CardData.GENRE_ROMANCE ||
			_mainGenre == CardData.GENRE_MUSICAL)
		{			
			if (_mainGenre == CardData.GENRE_ACTION)
			{
				// change to posterTextSprite
				posterTextSpr = createActionTitle(newTitle, fs, w, h);
			}
			else if (_mainGenre == CardData.GENRE_ADVENTURE)
			{
				// change to posterTextSprite
				posterTextSpr = createAdventureTitle(newTitle, fs, w, h);
			}
			else	// musical or romance
			{
				posterTextSpr = createRomanceTitle(newTitle, fs, w, h);
			}		
		}
		else
		{
			posterTextSpr = new PosterTextSprite();

			var titleTxt:TextField = new TextField();
			titleTxt.mouseEnabled = false;
			titleTxt.multiline = true;
			titleTxt.wordWrap = true;
		
			switch (_mainGenre)
			{
				case CardData.GENRE_COMEDY:
				{
					titleTxt.defaultTextFormat = 
						FontManager.getTextFormatByGenre(_mainGenre, fs, 0xFF0000);
					titleTxt.filters = [
						new GlowFilter(0xFFFFFF, TITLE_GLOW_ALPHA, 6, 6, 10)];
				}
				case CardData.GENRE_DRAMA:
				{
					titleTxt.defaultTextFormat = 
						FontManager.getTextFormatByGenre(_mainGenre, fs, 0xFFFFFF);
					titleTxt.filters = [new DropShadowFilter()];
				}
				case CardData.GENRE_HORROR:
				{
					// HORROR font needs to be slightly bigger
					titleTxt.defaultTextFormat = FontManager.getTextFormatByGenre(
						_mainGenre, fs, 0xD20000);
					titleTxt.filters = [
						new GlowFilter(0x000000, TITLE_GLOW_ALPHA, 4, 4, 10)];
				}

				case CardData.GENRE_SCIFI:
				{
					titleTxt.defaultTextFormat = 
						FontManager.getTextFormatByGenre(_mainGenre, fs, 0xFFFFFF);
					titleTxt.filters = [
						new GlowFilter(0x0F133A, TITLE_GLOW_ALPHA, 2, 2, 10)];
				}
				case CardData.GENRE_THRILLER:
				{
					titleTxt.defaultTextFormat = 
						FontManager.getTextFormatByGenre(_mainGenre, fs, 0x000000);
					titleTxt.filters = [
						new GlowFilter(0xD34A00, TITLE_GLOW_ALPHA, 4, 4, 10)];
				}
				default:
				{
					titleTxt.defaultTextFormat = 
						FontManager.getTextFormat(FontManager.FUTURA, fs, 0x000000);
					titleTxt.filters = [
						new GlowFilter(0xFFFFFF, TITLE_GLOW_ALPHA, 1, 1, 10)];
				}
			}
			
			titleTxt.width = w;
			titleTxt.height = h;
			titleTxt.text = newTitle;
			JWUtils.autoSizeFont(titleTxt);
			posterTextSpr.addChild(titleTxt);
			posterTextSpr.textHeight = titleTxt.textHeight;
		}

		return posterTextSpr;
	}
	
	public function setTagline(s:String):Void
	{
		var tagline:PosterTextSprite = titleFromGenre(s.toUpperCase(), 30, _taglinePos.w, 400);
		tagline.x = _taglinePos.x; // _template.tagline.x;
		tagline.y = _taglinePos.y; // _template.tagline.y;
		_titles.addChild(tagline);
	}

	public function reset():Void
	{
		_plotAdded = false;
		_characterSprites = new Array<JamSprite>();
		_titleSprites 	= new Array<TextField>();
		_background 	= new Sprite();
		_plotBack 		= new Sprite();
		_characters 	= new Sprite();
		_characterMaskSprite = new Sprite();
		_extras 		= new Sprite();
		_titles 		= new Sprite();
		_plotFront		= new Sprite();
		
		addChild(_background);
		addChild(_plotBack);
		addChild(_characters);
		addChild(_plotFront);
		addChild(_extras); 
		addChild(_titles);

		_characters.addChild(_characterMaskSprite);
		
		addMainTitle();
		
	}
	
	override public function dispose():Void
	{
		if (_frame != null) 
		{
			_frame.dispose();
			_frame = null;
		}

		if (_location != null) 
		{
			_location.dispose();
			_location = null;
		}

		if (_overlay != null) 
		{
			_overlay.dispose();
			_overlay = null;
		}

		if (_backImg != null)
		{
			_backImg.dispose();
		}

		if (_characterSprites != null) 
		{
			for (i in 0..._characterSprites.length)
			{
				if (_characterSprites[i] != null)
				{
					_characterSprites[i].dispose();
					_characterSprites[i] = null;
				}
			}
		}

		_posterMain = null;
		_background = null;		// background gradient / color (set by plot?)
		_plotBack = null;		// additions from the plot (back)
		_actors = null;			// faces go here	
		_characters = null;		// bodies go here
		_extras = null;			// extra stuff
		_titles = null; 		// title
		_plotFront = null;		// stuff that goes on top
		_characterMaskSprite = null; 
		_charactersMask = null;
		_characterMaskSrc = null;	//
		_titleSprites = null;
		_tf = null;
		_tagline = null;
		_pd = null;
	
	}

}

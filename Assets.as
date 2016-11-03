package {
	import flash.display.Bitmap;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets {
		public static var gameBg:Class;
		public static var machineBg:Class;
		public static var slot_icons_bg:Class;
		//footer
		public static var footerSheet:Class;
		public static var footerSheetXml:Class;
		public static var doubleSheet:Class;
		public static var doubleSheetXml:Class;
		//header
		public static var headerSheet:Class;
		public static var headerSheetXml:Class;
		
		//header
		public static var logo:Class;
		public static var logoXml:Class;
		
				
		//lightFrame
		public static var lightFrame:Class;
		public static var lightFrameXml:Class;
		//cards
		public static var cardsSheet:Class;
		public static var cardsSheetXml:Class;
		//line
		public static var lineButtons:Class;
		public static var lineButtonsXml:Class;
		public static var lines:Class;
		public static var linesXml:Class;
		
		public static var iconFrames:Class;
		public static var iconFramesXml:Class;
		
		//4 way jackpot
		public static var fourJackpotSheet:Class;
		public static var fourJackpotSheetXml:Class;
		
		//bonus statuses
		public static var bonusStatusSheet:Class;
		public static var bonusStatusSheetXml:Class;
		
		//----fonts
		//avit next bold
		//avir next bold
		//public static var avirBlackBitmap_bitmapFont:Class;
		//public static var avirBlackBitmap_bitmapFontXml:Class;
		
		//perpetua
		//public static var PerpetuaFont:Class;
		//public static var PerpetuaFontXml:Class;
		//perpetua Bold
		public static var PerpetuaBold:Class;
		public static var PerpetuaBoldXml:Class;
		//Playbill
		//public static var Playbill:Class;
		//public static var PlaybillXml:Class;
		//Playbill
		public static var bebas:Class;
		public static var bebasXml:Class;
		//IRON
		//public static var IRON:Class;
		//public static var IRONXml:Class;
		//bpg gel
		//public static var BpgGel:Class;
		//public static var BpgGelXml:Class;
		//dejavu sans
		public static var dejavuSans:Class;
		public static var dejavuSansXml:Class;
		//nuevaStd
		//public static var nuevaStd:Class;
		//public static var nuevaStdXml:Class;
		//exrounded
		public static var exRounded:Class;
		public static var exRoundedXml:Class;
		
		//public static var notifiLoseBonusGame:Class;
		//public static var notifiLoseBonusGameXml:Class;
		
		public static var bpgGELDejaVuSerifCaps_bitmapFont:Class;
		public static var bpgGELDejaVuSerifCaps_bitmapFontXml:Class;
		
		//---------paytable
		//backgrounds
		public static var payTableLoaded:Boolean = false;
		public static var paytableBg1:Class;
		public static var paytableBg2:Class;
		public static var paytableBg3:Class;
		public static var paytableBg4:Class;
		public static var paytableBg5:Class;
		public static var paytableBg6:Class;
		//buttons
		public static var paytableAssetsImg:Class;
		public static var paytableAssetsXml:Class;
		
		
		//error box
		//error
		public static var errorSheet:Class;
		public static var errorSheetXml:Class;
		
		
		//-----------jackpot WIn--------------
		public static var JackpotWinLoaded:Boolean = false;
		//buttons
		public static var jackpotWinAssetsImg:Class;
		public static var jackpotWinAssetsXml:Class;
		
		//loader
		public static var loaderSheet:Class;
		public static var loaderSheetXml:Class;
		
		
		public static var freeSpinsStatusSheet:Class;
		public static var freeSpinsStatusSheetXml:Class;
		
		
		
		
		
		
		//scatter win Bg
		public static var scatterWinBg:Class;
		
		
		//-----bonus------
		public static var bonusBg:Class;
		public static var daxli:Class;
		public static var bonusAssetsImg:Class;
		public static var bonusAssetsXml:Class;
		public static var sazamtroSheet:Class;
		public static var sazamtroSheetXml:Class;
		public static var BonusLoaded:Boolean = false;
		
		//begemoti animation
		public static var begemotianimation:Class;
		public static var begemotianimationXml:Class;
		
		
		public static var leaderboardSheet:Class;
		public static var leaderboardSheetXml:Class;
		/*public static var leader_me_bg:Class;
		public static var leader_me_bgXml:Class;*/
		
		/*//wild selector
		public static var wildSelectorSheet:Class;
		public static var wildSelectorSheetXml:Class;*/
		
		//wins pop
		public static var winsPopAsset:Class;
		public static var winsPopAssetXml:Class;
		
		
		//big win
		public static var bigWin:Class;
		public static var starEffectSheet:Class;
		public static var starEffectSheetXml:Class;
		
		
		//start info
		public static var startJacpotInfoSheet:Class;
		public static var startJacpotInfoSheetXml:Class;
		
		//transfer btn
		public static var transferSheet:Class;
		public static var transferSheetXml:Class;
		
		//icons
		public static var allIconsImg:Class;
		public static var allIconsXml:Class;
		public static var allWildSheet:Class;
		public static var allWildSheetXml:Class;
		public static var iconsAnimationImg:Class;
		public static var iconsAnimationXml:Class;
		public static var icon1Img:Class;
		public static var icon1Xml:Class;
		public static var staticAnim:Class;
		public static var staticAnimXml:Class;
		
		
		//leaderboard fonts
		//static public var bpg_arial_v1:Class;
		//static public var bpg_arial_v1Xml:Class;
		//static public var myriad_pro_bold_v1:Class;
		//static public var myriad_pro_bold_v1Xml:Class;
		//static public var bpg_arial_caps_12:Class;
		//static public var bpg_arial_caps_12Xml:Class;
		static public var bpg_gel_dejavu_serif_22:Class;
		static public var bpg_gel_dejavu_serif_22Xml:Class;
		static public var roboto_slab_bold_23:Class;
		static public var roboto_slab_bold_23Xml:Class;
		static public var roboto_slab_bold_timer_22:Class;
		static public var roboto_slab_bold_timer_22Xml:Class;
		static public var roboto_slab_bold_prizes:Class;
		static public var roboto_slab_bold_prizesXml:Class;
		static public var bpg_gel_dejavu_serif_white:Class;
		static public var bpg_gel_dejavu_serif_whiteXml:Class;
		static public var roboto_slab_bold_top:Class;
		static public var roboto_slab_bold_topXml:Class;
		static public var bpg_gel_dejavu_serif_black:Class;
		static public var bpg_gel_dejavu_serif_blackXml:Class;
		static public var roboto_slab_bold_top_black:Class;
		static public var roboto_slab_bold_top_blackXml:Class;
		static public var bpg_gel_dejavu_serif_22_yellow:Class;
		static public var bpg_gel_dejavu_serif_22_yellowXml:Class;
		
		//footer fonts
		public static var SPIN_FONT:Class;
		public static var SPIN_FONTXml:Class;
		public static var auto_spin_font:Class;
		public static var auto_spin_fontXml:Class;
		public static var balance_bfont:Class;
		public static var balance_bfontXml:Class;
		public static var win_bfont:Class;
		public static var win_bfontXml:Class;
		
		//machine fonts
		public static var line_buttons_font:Class;
		public static var line_buttons_fontXml:Class;
		public static var line_off_btn_bfont:Class;
		public static var line_off_btn_bfontXml:Class;
		public static var line_on_btn_bfont:Class;
		public static var line_on_btn_bfontXml:Class;
		
		//double fonts
		public static var double_roboto_bold:Class;
		public static var double_roboto_boldXml:Class;
		public static var double_roboto_bold_nums:Class;
		public static var double_roboto_bold_numsXml:Class;
		
		//cashier fonts
		public static var transfer_Font:Class;
		public static var transfer_FontXml:Class;
		
		
		
		
		
		public static var mainSlot:Class;
		public static var mainSlotXml:Class;
		
		
		
		
		
		
		
		private static var gameTexturesDic:Dictionary = new Dictionary();
		private static var gameTextureAtlassDic:Dictionary = new Dictionary();
		private static var gameFontsAtlassDic:Dictionary = new Dictionary();
		
		public static function getFont(fontName:String):BitmapFont {
			if (gameFontsAtlassDic[fontName] == null) {
				var imgClass:Class = Assets[fontName];
				var xmlClass:Class = Assets[fontName + "Xml"];
				//var imgClass:Class = getDefinitionByName('Assets_' + fontName) as Class;
				//var xmlClass:Class = getDefinitionByName('Assets_' + fontName + "Xml") as Class;
				
				var fontTexture:Texture = Texture.fromBitmap(new imgClass());
				var fontXML:XML = XML(new xmlClass());
				
				gameFontsAtlassDic[fontName] = new BitmapFont(fontTexture, fontXML);
				TextField.registerCompositor(gameFontsAtlassDic[fontName],gameFontsAtlassDic[fontName].name);
			}
			
			return gameFontsAtlassDic[fontName];
		}
		
		public static function getAtlas(imgStr:String, imgXmlStr:String):TextureAtlas {
			if (gameTextureAtlassDic[imgStr] == null) {
				//var ClassReference:Class = getDefinitionByName('ItemsLib_' + imgXmlStr) as Class;
				var ClassReference:Class = Assets[imgXmlStr];
				var texture:Texture = getTexture(imgStr);
				var xml:XML = XML(new ClassReference);
				//Tracer._log(xml);
				gameTextureAtlassDic[imgStr] = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlassDic[imgStr];
		}
		
		public static function getTexture(name:String, deleteTexture:Boolean = false):Texture {
			if (gameTexturesDic[name] == undefined) {
				var bitmap:Bitmap = new Assets[name]();
				
				gameTexturesDic[name] = Texture.fromBitmap(bitmap);
			}
			return gameTexturesDic[name];
		}
		
		public static function disposeAtlasItem(str:String):void {
			if (gameTextureAtlassDic[str] != null) {
				gameTextureAtlassDic[str].dispose();
				gameTextureAtlassDic[str] = null;
				delete gameTextureAtlassDic[str];
			}
		}
		
		public static function disposeTextureItem(str:String):void {
			if (gameTexturesDic[str] != null) {
				gameTexturesDic[str].dispose();
				gameTexturesDic[str] = null
				delete gameTexturesDic[str];
			}
		}
	}
}
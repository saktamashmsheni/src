package {
	
	import bonus.BonusIntroHolder;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import Main;
	import game.GameHolder;
	
	import starling.core.Starling
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	
	public class IniClass extends MovieClip {
		
		Security.allowDomain("*");
		Security.allowInsecureDomain("*");
		
		
		private var myStarling:Starling;
		private var bonusIntro:BonusIntroHolder;
		public var socketAnaliser:SocketAnaliser;
		public static var cont:IniClass;
		
		public var swfLoaded:Boolean = false;
		
		public var assLoadMan:AssetsLoaderManager;
		
		public function IniClass() {
			addEventListener(Event.ADDED_TO_STAGE, added);
			
			assLoadMan = new AssetsLoaderManager();
			assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allAssetsLoaded);
			assLoadMan.addEventListener(AssetsLoaderEvents.CUR_ASSET_LOADED, currAssetLoaded);
			assLoadMan.addEventListener(AssetsLoaderEvents.CUR_ASSET_PROGRESS_INFO, currAssetProgressInfo);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			cont = this;
			
			if (myStarling != null) {
				assLoadMan.unLoadAllLoaders();
				return;
			}
			myStarling = new Starling(Main, stage);
			//Starling.handleLostContext = true;  //shapebs ro vkargavdi
			myStarling.antiAliasing = 1;
			myStarling.start();
			myStarling.skipUnchangedFrames = true;
			myStarling.showStats = Root.TESTING;
			
			if (!swfLoaded)
				Preloader._cont._loadingProgressCue(-1, -1, null, 'Initializing...');
			
			socketAnaliser = new SocketAnaliser();
			socketAnaliser.init();
			//socketAnaliser.addEventListener(GameEvents.CONNECTED, whenConnected);
			
			
			
			if (Root.TESTING == false)
			{
				Root.ip = this.parent.loaderInfo.parameters['Ip'];
				Root.port = this.parent.loaderInfo.parameters['Port'];
				Root.userRoomId = this.parent.loaderInfo.parameters['UserId'];
				Root.lang = this.parent.loaderInfo.parameters['Lang'];
				if (Root.lang == "ka") {Root.lang = "ge"};
				Root.userRoomSession = this.parent.loaderInfo.parameters['SessionId'];
				
				GameSettings.GAME_NAME = getGameName(Root.port);
				GameSettings.PATH = "/" + this.parent.loaderInfo.parameters['AssetPath'] + GameSettings.GAME_NAME + "/";
				
				/*ExternalInterface.call("console.log", Root.ip);
				ExternalInterface.call("console.log", Root.port);
				ExternalInterface.call("console.log", Root.userRoomId);
				ExternalInterface.call("console.log", Root.lang);
				ExternalInterface.call("console.log", Root.userRoomSession);*/
			}else{
				
				GameSettings.GAME_NAME = getGameName(Root.port);
				GameSettings.PATH = GameSettings.GAME_NAME + "/";
				
				//var statsClass:Class = getDefinitionByName("net.hires.debug.Stats") as Class;
				//this.addChild(new statsClass);
				
				/*if (this.parent.loaderInfo.parameters['UserId'])
				{
					Root.userRoomId = this.parent.loaderInfo.parameters['UserId'];
				}*/
			}
			
			
			
			Root.connectToServer();
			
		}
		
		public function startLoadAssets():void 
		{
			/*if (Root.TESTING == true){}
			else { GameSettings.PATH = this.parent.loaderInfo.parameters['AssetPath'] }*/
			
			
			assLoadMan.setLoadAssets(GameSettings.PATH + "config.json", AssetsLoaderManager.CONFIGURATION, AssetsLoaderManager.JsonType);
			assLoadMan.setLoadAssets(GameSettings.PATH + "ItemsLibrary.swf", AssetsLoaderManager.ITEMS_LIBRARY, AssetsLoaderManager.SWFType);
			assLoadMan.setLoadAssets(GameSettings.PATH + "FontsLibrary.swf", AssetsLoaderManager.FONTS_LIBRARY, AssetsLoaderManager.SWFType);
			assLoadMan.setLoadAssets(GameSettings.PATH + "SoundLibrary.swf", AssetsLoaderManager.SOUND_LIBRARY, AssetsLoaderManager.SWFType);
			assLoadMan.setLoadAssets(GameSettings.PATH + "IconsLibrary.swf", AssetsLoaderManager.ICONS_LIBRARY, AssetsLoaderManager.SWFType);
			assLoadMan.setLoadAssets(GameSettings.PATH + "xml/" + Root.lang + ".xml", AssetsLoaderManager.XML_MUI_PACK, AssetsLoaderManager.XMLType);
			assLoadMan.startLoadAssets();
		}
		
		
		private function getGameName(port:Number):String 
		{
			for (var i:int = 0; i < GameSettings.GAMES_AND_PORTS.length; i++) 
			{
				if (GameSettings.GAMES_AND_PORTS[i][1] == port)
				{
					return GameSettings.GAMES_AND_PORTS[i][0];
				}
			}
			
			throw new Error("COULDNT FIND GAME NAME");
			return "";
		}
		
		public function currAssetLoaded(e:AssetsLoaderEvents):void {
			var i:int;
			
			var $o:Object;
			if (e.params.valTxt == AssetsLoaderManager.ITEMS_LIBRARY) {
				$o = e.params.content.applicationDomain;
				
				/*var definitions:*;
				   if ($o.hasOwnProperty("getQualifiedDefinitionNames")) {
				   definitions = $o["getQualifiedDefinitionNames"]();
				   for (var i:int = 0; i < definitions.length; i++) {
				   Tracer._log(definitions[i] + "\n")
				   }
				   }*/
				
				Assets.gameBg = $o.getDefinition("ItemsLib_gameBg") as Class;
				Assets.slot_icons_bg = $o.getDefinition("ItemsLib_slot_icons_bg") as Class;
				Assets.scatterWinBg = $o.getDefinition("ItemsLib_scatterWinBg") as Class;
				Assets.machineBg = $o.getDefinition("ItemsLib_machineBg") as Class;
				Assets.footerSheet = $o.getDefinition("ItemsLib_footerSheet") as Class;
				Assets.footerSheetXml = $o.getDefinition("ItemsLib_footerSheetXml") as Class;
				Assets.doubleSheet = $o.getDefinition("ItemsLib_doubleSheet") as Class;
				Assets.doubleSheetXml = $o.getDefinition("ItemsLib_doubleSheetXml") as Class;
				Assets.headerSheet = $o.getDefinition("ItemsLib_headerSheet") as Class;
				Assets.headerSheetXml = $o.getDefinition("ItemsLib_headerSheetXml") as Class;
				Assets.logo = $o.getDefinition("ItemsLib_logo") as Class;
				Assets.logoXml = $o.getDefinition("ItemsLib_logoXml") as Class;
				Assets.lightFrame = $o.getDefinition("ItemsLib_lightFrame") as Class;
				Assets.lightFrameXml = $o.getDefinition("ItemsLib_lightFrameXml") as Class;
				Assets.cardsSheet = $o.getDefinition("ItemsLib_cardsSheet") as Class;
				Assets.cardsSheetXml = $o.getDefinition("ItemsLib_cardsSheetXml") as Class;
				//Assets.lineButtons = $o.getDefinition("ItemsLib_lineButtons") as Class;
				//Assets.lineButtonsXml = $o.getDefinition("ItemsLib_lineButtonsXml") as Class;
				Assets.lines = $o.getDefinition("ItemsLib_lines") as Class;
				Assets.linesXml = $o.getDefinition("ItemsLib_linesXml") as Class;
				
				Assets.fourJackpotSheet = $o.getDefinition("ItemsLib_fourJackpotSheet") as Class;
				Assets.fourJackpotSheetXml = $o.getDefinition("ItemsLib_fourJackpotSheetXml") as Class;
				Assets.bonusStatusSheet = $o.getDefinition("ItemsLib_bonusStatusSheet") as Class;
				Assets.bonusStatusSheetXml = $o.getDefinition("ItemsLib_bonusStatusSheetXml") as Class;
				Assets.iconFrames = $o.getDefinition("ItemsLib_iconFrames") as Class;
				Assets.iconFramesXml = $o.getDefinition("ItemsLib_iconFramesXml") as Class;
				
				
				Assets.bigWin = $o.getDefinition("ItemsLib_bigWin") as Class;
				Assets.starEffectSheet = $o.getDefinition("ItemsLib_starEffectSheet") as Class;
				Assets.starEffectSheetXml = $o.getDefinition("ItemsLib_starEffectSheetXml") as Class;
				
				Assets.transferSheet = $o.getDefinition("ItemsLib_transferSheet") as Class;
				Assets.transferSheetXml = $o.getDefinition("ItemsLib_transferSheetXml") as Class;
				
				Assets.startJacpotInfoSheet = $o.getDefinition("ItemsLib_startJacpotInfoSheet") as Class;
				Assets.startJacpotInfoSheetXml = $o.getDefinition("ItemsLib_startJacpotInfoSheetXml") as Class;
				
				Assets.errorSheet = $o.getDefinition("ItemsLib_errorSheet") as Class;
				Assets.errorSheetXml = $o.getDefinition("ItemsLib_errorSheetXml") as Class;
				
				
				if (GameSettings.MULTIPLE_WINS)
				{
					Assets.xWinsSheet = $o.getDefinition("ItemsLib_xWinsSheet") as Class;
					Assets.xWinsSheetXml = $o.getDefinition("ItemsLib_xWinsSheetXml") as Class;
				}
				
				if (GameSettings.SIDE_ANIM > 0)
				{
					for (var j:int = 0; j < GameSettings.SIDE_ANIM; j++) 
					{
						Assets["sideAnim" + String(j+1)] = $o.getDefinition("ItemsLib_sideAnim" + String(j+1)) as Class;
						Assets["sideAnim" + String(j+1) + "Xml"] = $o.getDefinition("ItemsLib_sideAnim" + String(j+1) + "Xml") as Class;
					}
				}
				
				//loader
				Assets.loaderSheet = $o.getDefinition("ItemsLib_loaderSheet") as Class;
				Assets.loaderSheetXml = $o.getDefinition("ItemsLib_loaderSheetXml") as Class;
				
				//Assets.freeSpinsStatusSheet = $o.getDefinition("ItemsLib_freeSpinsStatusSheet") as Class;
				//Assets.freeSpinsStatusSheetXml = $o.getDefinition("ItemsLib_freeSpinsStatusSheetXml") as Class;
				
				
				//leader board
				Assets.leaderboardSheet = $o.getDefinition("ItemsLib_leaderboardSheet") as Class;
				Assets.leaderboardSheetXml = $o.getDefinition("ItemsLib_leaderboardSheetXml") as Class;
				/*Assets.leader_me_bg = $o.getDefinition("ItemsLib_leader_me_bg") as Class;
				Assets.leader_me_bgXml = $o.getDefinition("ItemsLib_leader_me_bgXml") as Class;*/
				
				/*//leader board
				Assets.wildSelectorSheet = $o.getDefinition("ItemsLib_wildSelectorSheet") as Class;
				Assets.wildSelectorSheetXml = $o.getDefinition("ItemsLib_wildSelectorSheetXml") as Class;*/
				
				
				
			} else if (e.params.valTxt == AssetsLoaderManager.ICONS_LIBRARY) {
				
				$o = e.params.content.applicationDomain;
				Assets.allIconsImg = $o.getDefinition("IconsLib_allIconsImg") as Class;
				Assets.allIconsXml = $o.getDefinition("IconsLib_allIconsXml") as Class;
				//Assets.allWildSheet = $o.getDefinition("IconsLib_allWildSheet") as Class;
				//Assets.allWildSheetXml = $o.getDefinition("IconsLib_allWildSheetXml") as Class;
				
				if(GameSettings.HOVER_ANIM_ENABLED == true)
				{
					Assets.iconsAnimationImg = $o.getDefinition("IconsLib_iconsAnimationImg") as Class;
					Assets.iconsAnimationXml = $o.getDefinition("IconsLib_iconsAnimationXml") as Class;
				}
				
				
				for (i = 0; i < GameSettings.TOTAL_ICONS; i++) 
				{
					Assets["icon"+ i + "Img"] = $o.getDefinition("IconsLib_icon"+i+"Img") as Class;
					Assets["icon"+ i + "Xml"] = $o.getDefinition("IconsLib_icon"+i+"Xml") as Class;
				}
				
				

				if (GameSettings.STATIC_ANIM_ENABLED)
				{
					Assets.staticAnim = $o.getDefinition("IconsLib_staticAnim") as Class;
					Assets.staticAnimXml = $o.getDefinition("IconsLib_staticAnimXml") as Class;
				}
				
				
			} else if (e.params.valTxt == AssetsLoaderManager.FONTS_LIBRARY) {
				$o = e.params.content.applicationDomain
				
				//Assets.PerpetuaFont = $o.getDefinition("FontsLib_PerpetuaFont") as Class;
				//Assets.PerpetuaFontXml = $o.getDefinition("FontsLib_PerpetuaFontXml") as Class;
				Assets.PerpetuaBold = $o.getDefinition("FontsLib_PerpetuaBold") as Class;
				Assets.PerpetuaBoldXml = $o.getDefinition("FontsLib_PerpetuaBoldXml") as Class;
				//Assets.Playbill = $o.getDefinition("FontsLib_Playbill") as Class;
				//Assets.PlaybillXml = $o.getDefinition("FontsLib_PlaybillXml") as Class;
				Assets.bebas = $o.getDefinition("FontsLib_bebas") as Class;
				Assets.bebasXml = $o.getDefinition("FontsLib_bebasXml") as Class;
				//Assets.IRON = $o.getDefinition("FontsLib_IRON") as Class;
				//Assets.IRONXml = $o.getDefinition("FontsLib_IRONXml") as Class;
				//Assets.BpgGel = $o.getDefinition("FontsLib_BpgGel") as Class;
				//Assets.BpgGelXml = $o.getDefinition("FontsLib_BpgGelXml") as Class;
				Assets.dejavuSans = $o.getDefinition("FontsLib_dejavuSans") as Class;
				Assets.dejavuSansXml = $o.getDefinition("FontsLib_dejavuSansXml") as Class;
				//Assets.nuevaStd = $o.getDefinition("FontsLib_nuevaStd") as Class;
				//Assets.nuevaStdXml = $o.getDefinition("FontsLib_nuevaStdXml") as Class;
				Assets.exRounded = $o.getDefinition("FontsLib_exRounded") as Class;
				Assets.exRoundedXml = $o.getDefinition("FontsLib_exRoundedXml") as Class;
				//Assets.notifiLoseBonusGame = $o.getDefinition("FontsLib_notifiLoseBonusGame") as Class;
				//Assets.notifiLoseBonusGameXml = $o.getDefinition("FontsLib_notifiLoseBonusGameXml") as Class;
				
				Assets.bpgGELDejaVuSerifCaps_bitmapFont = $o.getDefinition("FontsLib_bpgGELDejaVuSerifCaps_bitmapFont") as Class;
				Assets.bpgGELDejaVuSerifCaps_bitmapFontXml = $o.getDefinition("FontsLib_bpgGELDejaVuSerifCaps_bitmapFontXml") as Class;
				//Assets.avirBlackBitmap_bitmapFont = $o.getDefinition("FontsLib_avirBlackBitmap_bitmapFont") as Class;
				//Assets.avirBlackBitmap_bitmapFontXml = $o.getDefinition("FontsLib_avirBlackBitmap_bitmapFontXml") as Class;
				
				//Font.registerFont($o.getDefinition("FontsLib__robotoBlack"));
				//Font.registerFont($o.getDefinition("FontsLib__bpgGELDejaVuSerifCaps"));
				//Font.registerFont($o.getDefinition("FontsLib__artBrush"));
				//Font.registerFont($o.getDefinition("FontsLib__bpgMrgvlovaniCaps"));
				Font.registerFont($o.getDefinition("FontsLib__myriadProBold"));
				Font.registerFont($o.getDefinition("FontsLib__FuturaLTCon")); // es unda waishalos 
				Font.registerFont($o.getDefinition("FontsLib__AvenirNextBold"));
				//Font.registerFont($o.getDefinition("FontsLib__AvenirNextBoldItalic"));
				//Font.registerFont($o.getDefinition("FontsLib__bpgArialCaps"));
				Font.registerFont($o.getDefinition("FontsLib__BebasNeue"));
				
				
				//-------------------leaderboardFonts
				
				//Assets.bpg_arial_v1 = $o.getDefinition("FontsLib_bpg_arial_v1") as Class;
				//Assets.bpg_arial_v1Xml = $o.getDefinition("FontsLib_bpg_arial_v1_Xml") as Class;
				
				//Assets.myriad_pro_bold_v1 = $o.getDefinition("FontsLib_myriad_pro_bold_v1") as Class;
				//Assets.myriad_pro_bold_v1Xml = $o.getDefinition("FontsLib_myriad_pro_bold_v1Xml") as Class;
				
				//Assets.bpg_arial_caps_12 = $o.getDefinition("FontsLib_bpg_arial_caps_12") as Class;
				//Assets.bpg_arial_caps_12Xml = $o.getDefinition("FontsLib_bpg_arial_caps_12Xml") as Class;
				
				Assets.bpg_gel_dejavu_serif_22 = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_22") as Class;
				Assets.bpg_gel_dejavu_serif_22Xml = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_22Xml") as Class;
				
				Assets.roboto_slab_bold_23 = $o.getDefinition("FontsLib_roboto_slab_bold_23") as Class;
				Assets.roboto_slab_bold_23Xml = $o.getDefinition("FontsLib_roboto_slab_bold_23Xml") as Class;
				
				Assets.roboto_slab_bold_timer_22 = $o.getDefinition("FontsLib_roboto_slab_bold_timer_22") as Class;
				Assets.roboto_slab_bold_timer_22Xml = $o.getDefinition("FontsLib_roboto_slab_bold_timer_22Xml") as Class;
				
				Assets.roboto_slab_bold_prizes = $o.getDefinition("FontsLib_roboto_slab_bold_prizes") as Class;
				Assets.roboto_slab_bold_prizesXml = $o.getDefinition("FontsLib_roboto_slab_bold_prizesXml") as Class;
				
				Assets.bpg_gel_dejavu_serif_white = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_white") as Class;
				Assets.bpg_gel_dejavu_serif_whiteXml = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_whiteXml") as Class;
				
				Assets.roboto_slab_bold_top = $o.getDefinition("FontsLib_roboto_slab_bold_top") as Class;
				Assets.roboto_slab_bold_topXml = $o.getDefinition("FontsLib_roboto_slab_bold_topXml") as Class;
				
				Assets.bpg_gel_dejavu_serif_black = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_black") as Class;
				Assets.bpg_gel_dejavu_serif_blackXml = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_blackXml") as Class;
				
				Assets.roboto_slab_bold_top_black = $o.getDefinition("FontsLib_roboto_slab_bold_top_black") as Class;
				Assets.roboto_slab_bold_top_blackXml = $o.getDefinition("FontsLib_roboto_slab_bold_top_blackXml") as Class;
				
				Assets.bpg_gel_dejavu_serif_22_yellow = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_22_yellow") as Class;
				Assets.bpg_gel_dejavu_serif_22_yellowXml = $o.getDefinition("FontsLib_bpg_gel_dejavu_serif_22_yellowXml") as Class;
				
				//footer fonts
				Assets.SPIN_FONT = $o.getDefinition("FontsLib_SPIN_FONT") as Class;
				Assets.SPIN_FONTXml = $o.getDefinition("FontsLib_SPIN_FONTXml") as Class;
				Assets.auto_spin_font = $o.getDefinition("FontsLib_auto_spin_font") as Class;
				Assets.auto_spin_fontXml = $o.getDefinition("FontsLib_auto_spin_fontXml") as Class;
				Assets.balance_bfont = $o.getDefinition("FontsLib_balance_bfont") as Class;
				Assets.balance_bfontXml = $o.getDefinition("FontsLib_balance_bfontXml") as Class;
				Assets.win_bfont = $o.getDefinition("FontsLib_win_bfont") as Class;
				Assets.win_bfontXml = $o.getDefinition("FontsLib_win_bfontXml") as Class
				
				//machine fonts
				Assets.line_buttons_font = $o.getDefinition("FontsLib_line_buttons_font") as Class;
				Assets.line_buttons_fontXml = $o.getDefinition("FontsLib_line_buttons_fontXml") as Class;
				Assets.line_off_btn_bfont = $o.getDefinition("FontsLib_line_off_btn_bfont") as Class;
				Assets.line_off_btn_bfontXml = $o.getDefinition("FontsLib_line_off_btn_bfontXml") as Class;
				Assets.line_on_btn_bfont = $o.getDefinition("FontsLib_line_on_btn_bfont") as Class;
				Assets.line_on_btn_bfontXml = $o.getDefinition("FontsLib_line_on_btn_bfontXml") as Class;
				
				//double fonts
				Assets.double_roboto_bold = $o.getDefinition("FontsLib_double_roboto_bold") as Class;
				Assets.double_roboto_boldXml = $o.getDefinition("FontsLib_double_roboto_boldXml") as Class;
				Assets.double_roboto_bold_nums = $o.getDefinition("FontsLib_double_roboto_bold_nums") as Class;
				Assets.double_roboto_bold_numsXml = $o.getDefinition("FontsLib_double_roboto_bold_numsXml") as Class;
				
				//cashier fonts
				Assets.transfer_Font = $o.getDefinition("FontsLib_transfer_Font") as Class;
				Assets.transfer_FontXml = $o.getDefinition("FontsLib_transfer_FontXml") as Class;
				
				
				
			} else if (e.params.valTxt == AssetsLoaderManager.SOUND_LIBRARY) {
				Root.soundLibrary = e.params.content;
			} else if (e.params.valTxt == AssetsLoaderManager.XML_MUI_PACK) {
				GameSettings.GAME_XML = e.params.content as XML;
			} else if (e.params.valTxt == AssetsLoaderManager.PAYTABLE_LIBRARY) {
				$o = e.params.content.applicationDomain;
				
				
				for (i = 0; i < GameSettings.PAYTABLE_TOTAL_PAGES; i++) 
				{
					Assets["paytableBg"+ (i + 1)] = $o.getDefinition("PaytableLib_paytableBg"+(i+1)) as Class;
				}
				
				Assets.paytableAssetsImg = $o.getDefinition("PaytableLib_paytableAssetsImg") as Class;
				Assets.paytableAssetsXml = $o.getDefinition("PaytableLib_paytableAssetsXml") as Class;
				Assets.payTableLoaded = true;
			}
			
			else if (e.params.valTxt == AssetsLoaderManager.BONUS_LIBRARY) {
				$o = e.params.content.applicationDomain;
				
				Assets.bonusBg = 				$o.getDefinition("BonusLib_bonusBg") as Class;
				Assets.daxli = 					$o.getDefinition("BonusLib_daxli") as Class;
				Assets.bonusAssetsImg = 		$o.getDefinition("BonusLib_bonusAssetsImg") as Class;
				Assets.bonusAssetsXml = 		$o.getDefinition("BonusLib_bonusAssetsXml") as Class;
				Assets.sazamtroSheet = 			$o.getDefinition("BonusLib_sazamtroSheet") as Class;
				Assets.sazamtroSheetXml = 		$o.getDefinition("BonusLib_sazamtroSheetXml") as Class;
				Assets.begemotianimation = 		$o.getDefinition("BonusLib_begemotianimation") as Class;
				Assets.begemotianimationXml = 	$o.getDefinition("BonusLib_begemotianimationXml") as Class;
				
				Assets.BonusLoaded = true;
			}
			
			else if (e.params.valTxt == AssetsLoaderManager.JACKPOT_LIBRARY) {
				$o = e.params.content.applicationDomain;
				
				Assets.jackpotWinAssetsImg = $o.getDefinition("JackpotWinLib_jackpotWinAssetsImg") as Class;
				Assets.jackpotWinAssetsXml = $o.getDefinition("JackpotWinLib_jackpotWinAssetsXml") as Class;
				Assets.JackpotWinLoaded = true;
			}
			else if (e.params.valTxt == AssetsLoaderManager.CONFIGURATION){
				GameSettings.CONFIG_JSON = e.params.content as Object;
				GameSettings.PREFERENCES = GameSettings.CONFIG_JSON.preferences;
				updateGameSettings();
				
			}else if (e.params.valTxt == AssetsLoaderManager.WINS_POP_LIBRARY) {
				$o = e.params.content.applicationDomain;
				
				Assets.winsPopAsset = 	$o.getDefinition("WinsPopLib_winsAssetsImg") as Class;
				Assets.winsPopAssetXml = 	$o.getDefinition("WinsPopLib_winsAssetsXml") as Class;
				
				Assets.winsPop_bfont = $o.getDefinition("WinsPopLib_winspop_bitmapFont") as Class;   
				Assets.winsPop_bfontXml = $o.getDefinition("WinsPopLib_winspop_bitmapFontXml") as Class;   
			}
			
			//assLoadMan.updateLoad();
		}
		
		public function currAssetProgressInfo(e:AssetsLoaderEvents):void {
			if (!swfLoaded)
				Preloader._cont._loadingProgressCue(e.params.total, e.params.loaded, null, e.params.valTxt);
		}
		
		public function hidePreloaderIfThereis():void {
			Preloader._cont._removeThis();
		}
		
		private function allAssetsLoaded(e:AssetsLoaderEvents):void {
			
			/*if (myStarling != null) {
				assLoadMan.unLoadAllLoaders();
				return;
			}
			myStarling = new Starling(Main, stage);
			//Starling.handleLostContext = true;  //shapebs ro vkargavdi
			myStarling.antiAliasing = 1;
			myStarling.start();
			myStarling.skipUnchangedFrames = true;
			myStarling.showStats = Root.TESTING;
			
			if (!swfLoaded)
				Preloader._cont._loadingProgressCue(-1, -1, null, 'Initializing...');
			
			socketAnaliser = new SocketAnaliser();
			socketAnaliser.init();
			//socketAnaliser.addEventListener(GameEvents.CONNECTED, whenConnected);
			Root.connectToServer();*/
			
			assLoadMan.unLoadAllLoaders();
			
			//updateGameSettings();
			
			if (!swfLoaded) {
				swfLoaded = true
			}else {
				return;	
			}
			
			Main.cont.startMain();
			IniClass.cont.hidePreloaderIfThereis();
			Main.cont.showGame();
			
			
			
			GameHolder.cont.initialiseWholeMachine(SocketAnaliser.AUTH_OBJECT);
					
			if (SocketAnaliser.AUTH_OBJECT.Reconnect == true)
			{
			   GameHolder.cont.reconnectFunc(SocketAnaliser.AUTH_OBJECT)
			}
			if (SocketAnaliser.AUTH_OBJECT.Chips == 0 && Root.TESTING == false)
			{
				GameHolder.cont.addCashier();
			}
			
			socketAnaliser.activateOldMessages();
			
		}
		
		
		
		private function updateGameSettings():void 
		{
			var obj:Object = GameSettings.CONFIG_JSON;
			
			//icon animations
			GameSettings.MULTIPLE_WINS = obj.game.MULTIPLE_WINS;
			GameSettings.WINNER_LINE_START_AND_DELAY = obj.game.WINNER_LINE_START_AND_DELAY;
			GameSettings.ANIMATE_LINE_DELAY = obj.game.ANIMATE_LINE_DELAY;
			GameSettings.SCALE_ICONS = obj.game.SCALE_ICONS;
			
			if (obj.game.CHECK_FOR_WIN_LINE_LEN != null)
				GameSettings.CHECK_FOR_WIN_LINE_LEN = obj.game.CHECK_FOR_WIN_LINE_LEN;
				
			if (obj.game.SIDE_ANIM != null)
				GameSettings.SIDE_ANIM = obj.game.SIDE_ANIM;
			
			GameSettings.TOTAL_ICONS = obj.game.TOTAL_ICONS;
			GameSettings.ICONS_OFF_Y = obj.game.ICONS_OFF_Y;
			GameSettings.ICONS_OFF_X = obj.game.ICONS_OFF_X;
			GameSettings.ICON_ANIM_ENABLED = obj.iconAnimation.ICON_ANIM_ENABLED;
			GameSettings.ICON_ANIM_LOOP = obj.iconAnimation.ICON_ANIM_LOOP;
			GameSettings.ICON_ANIM_DELAY = obj.iconAnimation.ICON_ANIM_DELAY;
			GameSettings.ICON_ANIM_FAST_REMOVE = obj.iconAnimation.ICON_ANIM_FAST_REMOVE;
			GameSettings.HOVER_ANIM_ENABLED = obj.iconAnimation.HOVER_ANIM_ENABLED;
			GameSettings.HOVER_ANIM_LOOP = obj.iconAnimation.HOVER_ANIM_LOOP;
			GameSettings.HOVER_FAST_REMOVE = obj.iconAnimation.HOVER_FAST_REMOVE;
			GameSettings.STATIC_ANIM_ENABLED = obj.iconAnimation.STATIC_ANIM_ENABLED;
			GameSettings.STATIC_ANIM_LOOP = obj.iconAnimation.STATIC_ANIM_LOOP;
			GameSettings.STATIC_FAST_REMOVE = obj.iconAnimation.STATIC_FAST_REMOVE;
			GameSettings.HIDE_ICON = obj.iconAnimation.HIDE_ICON;
			GameSettings.WILD_ANIM_ENABLED = obj.iconAnimation.WILD_ANIM_ENABLED;
			GameSettings.WILD_ANIM_LOOP = obj.iconAnimation.WILD_ANIM_LOOP;
			GameSettings.WILD_HOVER_ENABLED = obj.iconAnimation.WILD_HOVER_ENABLED;
			GameSettings.WILD_HOVER_LOOP = obj.iconAnimation.WILD_HOVER_LOOP;
			
			GameSettings.ALL_ICONS_OFFSET_X = obj.preferences.machine.icons.ALL_OFFSET_X;
			GameSettings.ALL_ICONS_OFFSET_Y = obj.preferences.machine.icons.ALL_OFFSET_Y;
			GameSettings.FRAMES_OFFSET_X = obj.preferences.machine.framesHolder.OFFSET_X;
			GameSettings.FRAMES_OFFSET_Y = obj.preferences.machine.framesHolder.OFFSET_Y;
			GameSettings.LINEMAST_OFFSET_X = obj.preferences.machine.linesMask.OFFSET_X;
			GameSettings.LINEMAST_OFFSET_Y = obj.preferences.machine.linesMask.OFFSET_Y;
			
			//paytable
			GameSettings.PAYTABLE_TOTAL_PAGES = obj.payTable.PAYTABLE_TOTAL_PAGES;
			GameSettings.POSITIONS_AR = obj.payTable.POSITIONS_AR;
			GameSettings.PAYTABLE_SHEKVECA = obj.payTable.PAYTABLE_SHEKVECA;
			
			
			
			
		}
		
		
		public function fullScreen(e:MouseEvent):void {
			
			Starling.current.nativeStage.removeEventListener(MouseEvent.MOUSE_UP, fullScreen);
			
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					
			} else {
				stage.displayState = StageDisplayState.NORMAL;
					//to do
			}
		}
		
		
		
		public function addBonusIntroVideo():void 
		{
			bonusIntro = new BonusIntroHolder(this);
			addChild(bonusIntro);
			bonusIntro.showVideo();
			TweenLite.from(bonusIntro, 0.6, {alpha:0, x:stage.stageWidth/4, y:stage.stageHeight/4, scaleX:0.5, scaleY:0.5, ease:Expo.easeOut});
		}
		
		public function removeBonusIntroAndLoadBonus():void
		{
			bonusIntro.parent.removeChild(bonusIntro);
			bonusIntro = null;
			GameHolder.cont.addBonusGame();
		}
	
	}

}

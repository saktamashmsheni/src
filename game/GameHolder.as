package game
{
	import com.greensock.TweenMax;
	import com.utils.GAnalyticsEvents;
	import com.utils.GoogleAnalytics;
	import com.utils.MovieclipTextureAdder;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextArea;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import flash.net.SharedObject;
	import flash.text.TextFormatAlign;
	import game.doubleGame.DoubleHolder;
	import game.header.musicPlayer.MusicManager;
	import game.machine.LineButtons;
	import game.machine.Lines;
	import game.machine.Machine;
	import jackpotCL.FourWayJackpot;
	import cashier.TransferContainer;
	import flash.text.TextFormat;
	import jackpotCL.JackpotStartInfo;
	import jackpotCL.JackpotWinAnimation;
	import leaderBoard.LeaderBoardHolder;
	import leaderBoard.LeaderboardInfo;
	import notifi.BonusGameStatus;
	import bonus.BonusMcContainer;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.utils.MouseEvent;
	import com.utils.StaticGUI;
	import connection.SocketAnaliser;
	import flash.display.ShaderParameter;
	import flash.utils.setTimeout;
	import game.footer.FooterHolder;
	import game.header.HeaderHolder;
	import notifi.FreeSpinStatus;
	import notifi.ScatterWinWindow;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Align;
	import starling.utils.Align;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class GameHolder extends Sprite
	{
		public var machineHolder:Machine;
		public var footerHolder:FooterHolder;
		public var headerHolder:HeaderHolder;
		
		private var loaderMc:LoaderMc;
		
		public var freeSpinsAmount:int = 0;
		private var _freeSpinsState:Boolean = false;
		public var doubleHolder:DoubleHolder;
		private var lineButsHolder:LineButtons;
		public var linesHolder:Lines;
		private var freeSpinStatus:FreeSpinStatus;
		public var fourWayJackpotHolder:FourWayJackpot;
		public var currentFreeSpinNum:Number = 0;
		private var bonusStatusMc:BonusGameStatus;
		private var bigWinAnim:BigWin;
		private var wasEndMsg:Boolean;
		private var startInfo:JackpotStartInfo;
		private var jackpotWinAnimation:JackpotWinAnimation;
		private var leaderBoardHolder:LeaderBoardHolder;
		public var transferHolder:TransferContainer;
		public static const NORMAL_STATE:int = 0;
		public static const DOUBLE_STATE:int = 1;
		public static const AUTOPLAY_STATE:int = 2;
		public static const FREE_SPINS_STATE:int = 3;
		public static var cont:GameHolder;
		public var lastBuyIn:Number = 0;
		public var rules:RulesHolder;
		public var bonusHolder:BonusMcContainer;
		public static var gameState:int = NORMAL_STATE;
		public var histArray:Array = [];
		
		//static private const GAME_OFFSET_X:Number = 80;
		private var wildSelector:WildSelector;
		static private const GAME_OFFSET_X:Number = 0;
		public static var WILD_FREE_SPIN:Boolean;
		public var leaderboardInfo_mc:LeaderboardInfo;
		public var scatterWinMc:ScatterWinWindow;
		public var LEADER_BOARD_OBJECT:Object;
		
		public function GameHolder()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			cont = this;
			initialise();
		
			//TweenLite.delayedCall(0.5, aaa);
		
		}
		
		private function aaa():void
		{
			hideSlotItemsForStates();
			showDoubleHolder(120);
		}
		
		private function initialise():void
		{
			var i:int;
			
			machineHolder = new Machine();
			machineHolder.touchable = false;
			machineHolder.x = -330;
			machineHolder.y = -250;
			addChild(machineHolder);
			this.machineHolder.addEventListener(GameEvents.SPIN_COMPLETE, whenSpinComplete);
			
			fourWayJackpotHolder = new FourWayJackpot();
			fourWayJackpotHolder.x = 0;
			fourWayJackpotHolder.y = -238;
			addChild(fourWayJackpotHolder);
			
			lineButsHolder = new LineButtons();
			lineButsHolder.x = -428;
			lineButsHolder.y = 120;
			addChild(lineButsHolder);
			
			linesHolder = new Lines();
			linesHolder.x = -369;
			linesHolder.y = -215;
			//linesHolder.alpha = .4;
			//linesHolder.scaleX = 1.03;
			//linesHolder.scaleY = 0.94;
			
			
			headerHolder = new HeaderHolder();
			headerHolder.y = -300;
			addChild(headerHolder);
			
			footerHolder = new FooterHolder();
			footerHolder.x = -373;
			footerHolder.y = 215;
			addChild(footerHolder);
			footerHolder.addEventListener(GameEvents.SPIN_STARTED, spinStarted);
			
			
			addChild(linesHolder);
			linesHolder.addLineBtns(lineButsHolder);
			
			for (i = 0; i < this.numChildren; i++)
			{
				this.getChildAt(i).x += GAME_OFFSET_X;
			}
			
			
			leaderBoardHolder = new LeaderBoardHolder();
			leaderBoardHolder.x = -660;
			leaderBoardHolder.y = -300;
			addChild(leaderBoardHolder);
			
		    //TweenLite.delayedCall(1, showFreeSpinStatus, ["blalballba"]);
			
		}
		
		
		
		//init whole game
		public function initialiseWholeMachine(obj:Object):void
		{
			footerHolder.initFooter();
			footerHolder.updateBalance(obj.Chips);
			footerHolder.updateLines(GameSettings.ACT_LINES);
			footerHolder.updateBet(GameSettings.BET_INDEX);
			machineHolder.updateIndexes(obj);
			machineHolder.initMachine();
			linesHolder.initLines();
			linesHolder.shown = true;//false
			lineButsHolder.initButtons();
			
			leaderBoardHolder.initLeaderBoard();
		}
		
		private function whenSpinComplete(e:GameEvents):void
		{
			
			var sObj:Object = e.params.socketObject;
			var wildSpecNum:int = -1;
			
			this.footerHolder.sendSpinSecureCount = 0;
			//free spins
			if (sObj.FreeSpins > 0)
			{
				
				///wild
				if (sObj.WildReels.length > 0)
				{
					//machineHolder.modifyWildIcons(sObj.WildReels)
					
					var q:int = 0;
					while (wildSpecNum == -1)
					{
						wildSpecNum = Machine.wildSpecification(machineHolder.getIconByKJ(sObj.WildReels[q][0] + 1, sObj.WildReels[q][1]).ID);
						q++;
					}
					
				}
				
				if (wildSpecNum == 4)
				{
					//footerHolder.touchable = false;
					//gameState = AUTOPLAY_STATE
					//footerHolder.autoSpinAmount += sObj.WildReels.length / 3;
					//this.footerHolder.updateWin(sObj.TotalWin, true);
					
					machineHolder.setWildStaticReels(sObj.WildReels);
					WILD_FREE_SPIN = true;
				}
				else
				{
					WILD_FREE_SPIN = false;
				}
				
				
				
				
				if (freeSpinsState != true)
				{
					freeSpinsState = true;
				}
				
				freeSpinsAmount += sObj.FreeSpins;
				
				//this.linesHolder.frameHolder.setBonusLikeIcons(sObj, machineHolder.scatterIndex);
				//this.machineHolder.setBonusLikeIconsAnimations(sObj, machineHolder.scatterIndex);
				if (sObj.WinnerLines.length > 0)
				{
					GameHolder.gameState = GameHolder.DOUBLE_STATE;
				}
				
				if (WILD_FREE_SPIN == false)
				{
					showFreeSpinStatus("თქცენ მოიპოვეთ " + sObj.FreeSpins + " FREE SPIN", true, 0, GameHolder.gameState);
				}
				
				
				//this.machineHolder.showScatterBg();
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				footerHolder.updateState(GameHolder.NORMAL_STATE);
				footerHolder.spinEnabled = true;
				
				GameHolder.gameState = GameHolder.FREE_SPINS_STATE;
			}
			
			if (freeSpinsState && (currentFreeSpinNum) == freeSpinsAmount)
			{
				footerHolder.autoSpinAmount = 0;
				gameState = NORMAL_STATE;
				
				Root.soundManager.stopLoopSound();
			}
			
			
			
			if (LEADER_BOARD_OBJECT != null)
			{
				LeaderBoardHolder.cont.updateLeaderInfo(LEADER_BOARD_OBJECT);
				LEADER_BOARD_OBJECT = null;
			}
			
			
			
			
			
			
			
			this.footerHolder.updateWin(sObj.TotalWin, (freeSpinsState && currentFreeSpinNum >= 0));
			
			
			
			
			
			
			
			
			
			if (sObj.ScatterWin.length > 0)
			{
				for (var i:int = 0; i < sObj.ScatterWin.length; i++) 
				{
					this.machineHolder.setBonusLikeIconsAnimations(sObj, sObj.ScatterWin[i][1]);
					this.linesHolder.frameHolder.setBonusLikeIcons(sObj, sObj.ScatterWin[i][1]);
				}
			}
			
			
			if (sObj.WinnerLines.length > 0 || sObj.ScatterWin.length > 0)
			{
				var collectDel:Number = 0.3;
				/*if (sObj.ScatterWin.length > 0)
				{
					collectDel = 2.2;
				}*/
				
				if (BigWin.shouldShow(footerHolder.totalBetAmount, sObj.TotalWin) == true)
				{
					bigWinAnim = new BigWin(sObj.TotalWin);
					this.addChild(bigWinAnim);
					bigWinAnim.x = GAME_OFFSET_X;
					
					collectDel = 7
				}
				
				var winStr:String = "Wind_Regular_0";
				var winRnd:int = Math.floor(Math.random() * 5) + 1;
				winStr += String(winRnd);
				
				Root.soundManager.schedule(winStr, 1);
				
				TweenLite.delayedCall(collectDel, preEndDelayedFunc, [sObj]);
			}
			
			/*//scatter
			if (sObj.FirstScatterWin > 0 || sObj.SecondScatterWin > 0)
			{
				scatterWinMc = new ScatterWinWindow(sObj.FirstScatterWin > 0 ? sObj.FirstScatterWin : sObj.SecondScatterWin);
				scatterWinMc.x = GAME_OFFSET_X;
				addChild(scatterWinMc);
			}*/
			
			//activate old messages
			IniClass.cont.socketAnaliser.activateOldMessages();
			
			if (sObj.Bonus == true)
			{
				return;
			}
			
			var endDelay:Number = 0;
			if (BigWin.shouldShow(footerHolder.totalBetAmount, sObj.TotalWin) == true)
			{
				endDelay = 8.2;
			}
			
			
			
			/*if (sObj.FirstScatterWin > 0 || sObj.SecondScatterWin > 0)
			   {
			   endDelay = 3;
			   }*/
			
			//tu wild movida
			
			/*var obj:Object = sObj;
			   for (var l:int = 0; l < obj.WildReels.length; l++)
			   {
			   var isInWinLine:Boolean = false;
			   for (var j:int = 0; j < obj.WinnerLines.length; j++)
			   {
			   if (obj.WildReels[l][0] < obj.WinnerLines[j][2])
			   {
			   isInWinLine = true;
			   break;
			   }
			   }
			   }*/
			
			//obj = null;
			
			/*if (isInWinLine)
			   {
			   footerHolder.touchable = false;
			   TweenLite.delayedCall(2, enableTouchOnWildStateEnd);
			   }*/
			   
			   
			   
			   if (sObj.WildReels.length > 0)
				{
					machineHolder.modifyWildIcons(sObj.WildReels, sObj)
					endDelay += 1;
				}
			   
		   
				//winner lines
				this.linesHolder.showWinnerLinesArr(sObj, (gameState == AUTOPLAY_STATE || sObj.Bonus == true) ? false : true);
			
			
			TweenLite.delayedCall(endDelay, checkForEndmsg, [sObj]);
			
			sObj = null;
		
		}
		
		private function enableTouchOnWildStateEnd():void
		{
			footerHolder.touchable = true;
		}
		
		public function stopAutoSpinIfThereIsOnJackpot():void
		{
			if (machineHolder.isScrolling || gameState == AUTOPLAY_STATE)
			{
				gameState = NORMAL_STATE;
			}
		}
		
		private function bonusDelayedFunc():void
		{
			IniClass.cont.addBonusIntroVideo();
			machineHolder.stopIconsAnimation();
			linesHolder.shown = false;
		
		}
		
		private function preEndDelayedFunc(obj:Object):void
		{
			//aq ise ar sheva es piroba tu ar shesrulda
			if (obj.WinnerLines.length > 0 || obj.ScatterWin.length > 0) {
				if (gameState != AUTOPLAY_STATE)
				{
					gameState = DOUBLE_STATE;
					footerHolder.updateState(gameState);
				}
				else
				{
					Root.connectionManager.sendData({MT: SocketAnaliser.collect, SID: "", IM: {"Color": -1}});
				}
			}
		}
		
		private function checkForEndmsg(obj:Object):void
		{
			if (wasEndMsg == false)
			{
				if (gameState != DOUBLE_STATE)
				{
					setTimeout(checkForEndmsg, 100, obj);
					return;
				}
			}
			
			this.footerHolder.spinEnabled = true;
			this.footerHolder.touchable = true;
			if (freeSpinsState && currentFreeSpinNum > 0 && (currentFreeSpinNum) != freeSpinsAmount)
			{
				footerHolder.autoSpinAmount = 999;
				gameState = AUTOPLAY_STATE
			}
			
			
			//Tracer._log("################### " + freeSpinsState);
			//Tracer._log("################### " + currentFreeSpinNum);
			//Tracer._log("################### " + freeSpinsAmount);
			
			
			if (gameState == AUTOPLAY_STATE)
			{
				TweenLite.delayedCall(obj.WinnerLines.length > 0 ? 1 : 0.4, this.footerHolder.autoSpinFunction);
			}
			
			
			if (WILD_FREE_SPIN == true && (currentFreeSpinNum) != freeSpinsAmount && gameState != AUTOPLAY_STATE)
			{
				//TweenLite.delayedCall(2, freeSpinsStartFunc, [null]);
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				footerHolder.updateState(GameHolder.gameState);
				footerHolder.onSpinClick();
			}
		}
		
		//on spin click
		private function spinStarted(e:GameEvents):void
		{
			Tracer._log("spin started");
			this.linesHolder.shown = false;
			if (freeSpinsState == true)
			{
				updateLogoWhileFreeSpins(-1, true);
			}
			
			if (freeSpinsState == false)
			{
				footerHolder.winAmount = 0;
				footerHolder.updateWin(footerHolder.winAmount);
			}
			
			wasEndMsg = false;
			
			GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS, 'spin', 'spin clicked');
		}
		
		//show error
		public function showFreeSpinStatus(customText:String = "", start:Boolean = true, win:Number = 0, gameState:int = -1):void
		{
			try
			{
				freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_START, freeSpinsStartFunc);
				freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_END, freeSpinsEndFunc);
				freeSpinStatus = null;
			}
			catch (err:Error)
			{
				
			}
			
			freeSpinStatus = new FreeSpinStatus(this, customText, start, win, gameState);
			freeSpinStatus.addEventListener(GameEvents.FREE_SPINS_START, freeSpinsStartFunc);
			freeSpinStatus.addEventListener(GameEvents.FREE_SPINS_END, freeSpinsEndFunc);
			
			addChild(freeSpinStatus);
		}
		
		private function freeSpinsStartFunc(e:GameEvents):void
		{
			GameHolder.gameState = GameHolder.NORMAL_STATE;
			footerHolder.updateState(GameHolder.gameState);
			footerHolder.spinBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function freeSpinsEndFunc(e:GameEvents):void
		{
			currentFreeSpinNum = 0;
			freeSpinsState = false;
			WILD_FREE_SPIN = false;
			freeSpinsAmount = 0;
			
			if (footerHolder.freeSpinsWinAmount > 0)
			{
				gameState = DOUBLE_STATE;
				footerHolder.updateState(gameState);
			}
			else
			{
				gameState = NORMAL_STATE;
				footerHolder.updateState(gameState);
			}
			
			footerHolder.freeSpinsWinAmount = 0;
		}
		
		public function freeSpinCompleteMessage(obj:Object):void
		{
			if (freeSpinsState == true)
			{
				footerHolder.autoSpinAmount = 0;
				
				if (obj.Win > 0)
				{
					footerHolder.winAmount = footerHolder.freeSpinsWinAmount;
					gameState = DOUBLE_STATE;
					footerHolder.updateState(gameState);
					if (WILD_FREE_SPIN != true)
					{
						var str:String = FooterHolder.InLari == false ? obj.Win / GameSettings.CREDIT_VAL + " ქულა" : String((Number(obj.Win) / 100).toFixed(2)) + " GEL";
						freeSpinStatus = new FreeSpinStatus(this, "თქვენ ამოგეწურათ FREE SPIN. თქვენ მოიგეთ " + str, false, gameState);
						addChild(freeSpinStatus);
					}
				}
				else
				{
					gameState = NORMAL_STATE;
					footerHolder.updateState(gameState);
					if (WILD_FREE_SPIN != true)
					{
						freeSpinStatus = new FreeSpinStatus(this, "თქვენ ამოგეწურათ FREE SPIN", false, gameState);
						addChild(freeSpinStatus);
					}
					
				}
				
				
				///////////////////////
				if (WILD_FREE_SPIN == true)
				{
					freeSpinsEndFunc(null);
					machineHolder.clearStaticReels();
				}
				
					//this.machineHolder.hideScatterBg();
			}
		}
		
		public function updateFromDoubleGame(win:Number, doubleEnd:Boolean = false):void
		{
			//es vazgvev imiro ro ro waagebs doubles qula gaanulos
			if (freeSpinsState == true)
			{
				freeSpinsState = false;
				WILD_FREE_SPIN = false;
			}
			
			// delay of delFuncFromDoubleAllWin method must be less then delFuncFromDoubleEnd delay
			const DOUBLE_END_AND_WIN_FALSE_DELAY:Number = 1;
			const DOUBLE_END_AND_WIN_TRUE_DELAY:Number = .8;
			
			if (win == false || doubleEnd == true)
			{
				footerHolder.spinEnabled = false;
				IniClass.cont.socketAnaliser.StopMessage = true;
				TweenLite.delayedCall(DOUBLE_END_AND_WIN_FALSE_DELAY, delFuncFromDoubleEnd);
			}
			else
			{
				
			}
			
			if (win == false)
			{
				footerHolder.resetWin();
			}
			
			footerHolder.winAmount = int(win);
			footerHolder.updateWin(footerHolder.winAmount);
			
			if (doubleEnd == true && win > 0)
			{
				IniClass.cont.socketAnaliser.StopMessage = true;
				
				TweenLite.delayedCall(DOUBLE_END_AND_WIN_TRUE_DELAY, delFuncFromDoubleAllWin);
			}
		
		}
		
		private function delFuncFromDoubleEnd():void
		{
			removeDoubleHolder();
			GameHolder.gameState = GameHolder.NORMAL_STATE;
			footerHolder.updateState(GameHolder.gameState);
			footerHolder.spinEnabled = true;
			IniClass.cont.socketAnaliser.activateOldMessages();
		}
		
		private function delFuncFromDoubleAllWin():void
		{
			
			/*	if (wasEndMsg == false)
			   {
			   setTimeout(delFuncFromDoubleAllWin, 100);
			   }*/
			footerHolder.updateBalance(footerHolder.balanceAmount, true);
			footerHolder.resetWin(true);
			IniClass.cont.socketAnaliser.activateOldMessages();
		
		}
		
		public function end(obj:Object):void
		{
			if (gameState != AUTOPLAY_STATE)
			{
				footerHolder.balanceAmount = obj.Chips;
				
				Tracer._log("wasEndMsg");
				wasEndMsg = true;
				
			}
			else
			{
				TweenLite.delayedCall(0.6, endDelayFunc, [obj]);
			}
			if (gameState == NORMAL_STATE && !freeSpinsState)
			{
				footerHolder.spinEnabled = true;
			}
			
			if (obj.FreeSpinsEnd == true){
				footerHolder.spinEnabled = true;
			}
		}
		
		public function endDelayFunc(obj:Object):void
		{
			footerHolder.balanceAmount = obj.Chips;
			footerHolder.updateBalance(obj.Chips, false);
			footerHolder.resetWin(true);
			wasEndMsg = true;
			Tracer._log("wasEndMsg");
		}
		
		public function get freeSpinsState():Boolean
		{
			return _freeSpinsState;
		}
		
		public function set freeSpinsState(value:Boolean):void
		{
			_freeSpinsState = value;
			if (WILD_FREE_SPIN == true)
			{
				return;
			}
			
			if (value == true)
			{
				
				headerHolder.logoMc.currentFrame = 2;
				TweenLite.from(headerHolder.logoMc, 0.4, {alpha: 0, scaleY: 0, ease: Expo.easeOut});
				TextField(headerHolder.getChildByName("freeSpins_txt")).visible = true;
				TextField(headerHolder.getChildByName("freeSpins_txt")).text = currentFreeSpinNum + " / " + freeSpinsAmount;
			}
			else
			{
				switch (Root.lang)
				{
				case "ge": 
					headerHolder.logoMc.currentFrame = 0;
					break;
				case "en": 
					headerHolder.logoMc.currentFrame = 1;
					break;
				case "ru": 
					headerHolder.logoMc.currentFrame = 2;
					break;
				}
				
				TextField(headerHolder.getChildByName("freeSpins_txt")).visible = false;
			}
		}
		
		public function updateLogoWhileFreeSpins(leftFreeSpins:int, updateOld:Boolean = false):void
		{
			if (leftFreeSpins == 0)
			{
				if (freeSpinsState == true)
				{
					freeSpinsAmount = 0;
					freeSpinsState = false;
				}
				
				return;
			}
			
			if (updateOld == false)
			{
				currentFreeSpinNum = freeSpinsAmount - leftFreeSpins;
				TextField(headerHolder.getChildByName("freeSpins_txt")).text = (freeSpinsAmount - leftFreeSpins) + " / " + freeSpinsAmount;
			}
			else
			{
				currentFreeSpinNum = currentFreeSpinNum + 1
				TextField(headerHolder.getChildByName("freeSpins_txt")).text = currentFreeSpinNum + " / " + freeSpinsAmount;
			}
		}
		
		public function showDoubleHolder(amount:int):void {
			if (doubleHolder != null)
				return;
			doubleHolder = new DoubleHolder(this);
			doubleHolder.x = -20;
			doubleHolder.y = -9;
			addChild(doubleHolder);
			doubleHolder.show(amount);
		}
		
		public function updateDoubleHolder(obj:Object):void
		{
			if (doubleHolder == null)
		   return;
		
		   doubleHolder.update(obj);
		}
		
		public function updateDoubleHalfHolder(obj:Object):void
		{
		if (doubleHolder == null)
		   return;
		
		   doubleHolder.updateHalf(obj);
		}
		
		public function removeDoubleHolder():void
		{
			if (doubleHolder == null)
				return;
			
			doubleHolder.hide();
			StaticGUI.safeRemoveChild(doubleHolder, true);
			doubleHolder = null;
			
			showSlotItemsForStates();
			
			GoogleAnalytics._sendScreenView('Slot main screen');
		}
		
		///-----bonus-----
		
		public function loadBonus(BonusStrikes:int):void
		{
			bonusHolder = new BonusMcContainer(footerHolder.totalBetAmount, BonusStrikes);
			if ((IniClass.cont.assLoadMan.isInLoadingExperoenceDone("Bonus Library")) == true)
			{
				return;
			}
			IniClass.cont.assLoadMan.clearLoadManager();
			IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "BonusLibrary.swf", "Bonus Library", AssetsLoaderManager.SWFType);
			IniClass.cont.assLoadMan.startLoadAssets();
		}
		
		public function loadAndAddBonus(BonusStrikes:int):void
		{
			
			showLoader();
			if (IniClass.cont.assLoadMan.isInLoadingExperoence("Bonus Library"))
			{
				addBonusGame();
				return;
			}
			bonusHolder = new BonusMcContainer(footerHolder.totalBetAmount, BonusStrikes);
			if (Assets.BonusLoaded)
			{
				addBonusGame();
			}
			else
			{
				IniClass.cont.assLoadMan.clearLoadManager();
				IniClass.cont.assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allBonusAssetsLoaded);
				IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "BonusLibrary.swf", "Bonus Library", AssetsLoaderManager.SWFType);
				IniClass.cont.assLoadMan.startLoadAssets();
			}
		}
		
		private function allBonusAssetsLoaded(e:AssetsLoaderEvents):void
		{
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allBonusAssetsLoaded);
			addBonusGame();
		}
		
		public function addBonusGame():void
		{
			if (!(IniClass.cont.assLoadMan.isInLoadingExperoenceDone("Bonus Library")))
			{
				setTimeout(addBonusGame, 100);
				return;
			}
			hideLoader();
			addChild(bonusHolder);
		}
		
		public function bonusFinish(bonusWin:Number, allSuccess:Boolean = false):void
		{
			bonusHolder.hide();
			bonusHolder = null;
			if (freeSpinsState == true && currentFreeSpinNum > 0 && currentFreeSpinNum != freeSpinsAmount)
			{
				footerHolder.updateWin(bonusWin, true);
				if (BigWin.shouldShow(footerHolder.totalBetAmount, bonusWin) == true)
				{
					bigWinAnim = new BigWin(bonusWin);
					this.addChild(bigWinAnim);
				}
			}
			footerHolder._bonusGame = false;
			footerHolder.spinEnabled = true;
			MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE_ONDELAY);
			
			gameState = NORMAL_STATE;
			footerHolder.updateState(gameState);
			footerHolder.spinEnabled = true;
			
			bonusStatusMc = new BonusGameStatus(bonusWin, !allSuccess);
			addChild(bonusStatusMc);
			
			try
			{
				bonusStatusMc.removeEventListener(GameEvents.BONUS_FINISHED, bonusStatusFinish);
			}
			catch (err:Error)
			{
			}
			bonusStatusMc.addEventListener(GameEvents.BONUS_FINISHED, bonusStatusFinish);
		}
		
		private function bonusStatusFinish(e:GameEvents):void
		{
			if (GameHolder.cont.freeSpinsState == true && GameHolder.cont.currentFreeSpinNum > 0 && GameHolder.cont.currentFreeSpinNum != GameHolder.cont.freeSpinsAmount)
			{
				this.footerHolder.spinEnabled = true;
				
				if (freeSpinsState && currentFreeSpinNum > 0 && (currentFreeSpinNum) != freeSpinsAmount)
				{
					footerHolder.autoSpinAmount = 999;
					gameState = AUTOPLAY_STATE
				}
				
				Tracer._log("################### " + freeSpinsState);
				Tracer._log("################### " + currentFreeSpinNum);
				Tracer._log("################### " + freeSpinsAmount);
				if (gameState == AUTOPLAY_STATE)
				{
					TweenLite.delayedCall(0.1, this.footerHolder.autoSpinFunction);
				}
			}
			else
			{
				if (e.params.win > 0)
				{
					footerHolder.updateBalance(footerHolder.balanceAmount, true, e.params.win);
					footerHolder.resetWin(true);
				}
			}
			
			bonusStatusMc.removeEventListener(GameEvents.BONUS_FINISHED, bonusStatusFinish);
			StaticGUI.safeRemoveChild(bonusStatusMc, true);
			bonusStatusMc = null;
		}
		
		///-----paytable------
		public function loadAndAddPayTable():void
		{
			
			if (rules != null)
			{
				removePaytable();
				return;
			}
			
			showLoader();
			rules = new RulesHolder(GameSettings.BETS_AR[GameSettings.BET_INDEX]);
			//showLoader();
			if (Assets.payTableLoaded)
			{
				addPaytable();
			}
			else
			{
				IniClass.cont.assLoadMan.clearLoadManager();
				IniClass.cont.assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allAssetsLoaded);
				IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "PaytableLibrary.swf", "Paytable Library", AssetsLoaderManager.SWFType);
				IniClass.cont.assLoadMan.startLoadAssets();
			}
		}
		
		private function allAssetsLoaded(e:AssetsLoaderEvents):void
		{
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allAssetsLoaded);
			addPaytable();
		}
		
		public function addPaytable():void
		{
			hideLoader();
			hideSlotItemsForStates(true);
			addChild(rules);
			rules.x = GAME_OFFSET_X;
		}
		
		public function removePaytable():void
		{
			rules.disposePaytable();
			StaticGUI.safeRemoveChild(rules);
			rules = null;
			showSlotItemsForStates();
			GoogleAnalytics._sendScreenView('Slot main screen');
		}
		
		public function addCashier():void
		{
			transferHolder = new TransferContainer();
			addChild(transferHolder);
			transferHolder.x = transferHolder.x + GAME_OFFSET_X;
			transferHolder.y = 30;
		}
		
		public function removeCashier():void
		{
			StaticGUI.safeRemoveChild(transferHolder, true)
			transferHolder = null;
			
			GoogleAnalytics._sendScreenView('Slot main screen');
		}
		
		public function showJackpotStartWindow():void
		{
			var mySO:SharedObject = SharedObject.getLocal("4jack_Info_Euro_Goal");
			try
			{
				if (mySO.data.vala < 2 || mySO.data.vala == null)
				{
					if (mySO.data.vala == null)
					{
						mySO.data.vala = 0;
					}
					
					startInfo = new JackpotStartInfo();
					addChild(startInfo);
					mySO.data.vala++;
				}
			}
			catch (e:Error)
			{
				mySO.data.vala = 0;
			}
			
			mySO.flush();
			mySO.close();
		}
		
		public function removeJackpotStartInfo():void
		{
			StaticGUI.safeRemoveChild(startInfo, true);
			startInfo = null;
		}
		
		///-----Jackpot Win-----
		public function loadAndAddJackpotWin(win:Number, jackId:int):void
		{
			showLoader();
			jackpotWinAnimation = new JackpotWinAnimation(win, jackId);
			
			if (Assets.JackpotWinLoaded)
			{
				addJackpotWin();
			}
			else
			{
				IniClass.cont.assLoadMan.clearLoadManager();
				IniClass.cont.assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allJackpotAssetsLoaded);
				IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "JackpotWinLibrary.swf", "Jackpot Library", AssetsLoaderManager.SWFType);
				IniClass.cont.assLoadMan.startLoadAssets();
			}
		}
		
		private function allJackpotAssetsLoaded(e:AssetsLoaderEvents):void
		{
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allJackpotAssetsLoaded);
			addJackpotWin();
		}
		
		public function addJackpotWin():void
		{
			hideLoader();
			addChild(jackpotWinAnimation);
		}
		
		public function removeJackpotAnim():void
		{
			jackpotWinAnimation.disposeAll();
			StaticGUI.safeRemoveChild(jackpotWinAnimation, true)
			jackpotWinAnimation = null;
		}
		
		public function hideSlotItemsForStates(hideFooter:Boolean = false):void
		{
			
			TweenLite.to(machineHolder.iconsHolder, 0.5, {autoAlpha: 0});
			TweenLite.to(linesHolder, 0.5, {autoAlpha: 0});
			TweenLite.to(linesHolder.frameHolder, 0.5, {autoAlpha: 0});
			
			if (hideFooter)
			{
				TweenLite.to(footerHolder, 0.5, {autoAlpha: 0});
			}
		
		}
		
		public function showSlotItemsForStates():void
		{
			if ((gameState == AUTOPLAY_STATE && bonusHolder == null) || (!gameState == DOUBLE_STATE && bonusHolder == null) || gameState == NORMAL_STATE || (gameState == DOUBLE_STATE && bonusHolder == null))
			{
				
				TweenLite.to(machineHolder.iconsHolder, 0.5, {autoAlpha: 1});
				TweenLite.to(linesHolder, 0.5, {autoAlpha: 1});
				TweenLite.to(linesHolder.frameHolder, 0.5, {autoAlpha: 1});
				TweenLite.to(footerHolder, 0.5, {autoAlpha: 1});
			}
			
			if (bonusHolder != null)
			{
				TweenLite.to(bonusHolder, 0.5, {autoAlpha: 1});
			}
			
			if (bonusHolder == null)
			{
				TweenLite.to(footerHolder, 0.5, {autoAlpha: 1});
			}
		}
		
		public function reconnectFunc(obj:Object):void
		{
			
			footerHolder.updateBet(GameSettings.BETS_AR.indexOf(obj.HandInfo.Bet));
			footerHolder.updateLines(obj.HandInfo.Line1);
			
			if (obj.Scatter.FreeSpins > 0)
			{
				
				footerHolder.spinEnabled = false;
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				footerHolder.updateState(GameHolder.NORMAL_STATE);
				
				freeSpinsAmount = obj.Scatter.TotalFreeSpins;
				
				currentFreeSpinNum = 0;
				freeSpinsState = true;
				footerHolder.spinEnabled = true;
				
				updateLogoWhileFreeSpins(obj.Scatter.FreeSpins);
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				
				//this.machineHolder.showScatterBg();
				
				footerHolder.freeSpinsWinAmount = obj.Scatter.FreeSpinWin;
				footerHolder.updateWin(obj.Scatter.FreeSpinWin);
				
					//Root.soundManager.stopLoopSound()
					//Root.soundManager.loopdSound("scatter");
			}
			
			if (obj.HandInfo == null)
			{
				return;
			}
			
			machineHolder.setCustomReels(obj.HandInfo.SpinResult.Reels);
			linesHolder.hideAllLines();
			TweenLite.delayedCall(0.1, linesHolder.showWinnerLinesArr, [obj.HandInfo.SpinResult, false]);
			
			if (obj.HandInfo.HandState == 0)
			{
				footerHolder.updateWin(obj.HandInfo.Win);
			}
			else
			{
				footerHolder.updateWin(obj.HandInfo.SpinResult.TotalWin);
			}
			
			if (obj.HandInfo.HandState == 0)
			{
				GameHolder.gameState = GameHolder.DOUBLE_STATE;
				this.footerHolder.updateState(GameHolder.DOUBLE_STATE);
				footerHolder.spinEnabled = true;
				GameHolder.cont.hideSlotItemsForStates();
				showDoubleHolder(obj.HandInfo.Win);
				this.doubleHolder.modifyCardsOnReconnect(obj.HandInfo.Cards);
			}
		}
		
		private function setBonusItemsForReconnect(obj:Object):void
		{
			if (bonusHolder == null || bonusHolder.bonusInited == false)
			{
				Tracer._log("waiting for bonus");
				setTimeout(setBonusItemsForReconnect, 100, obj);
				return;
			}
			bonusHolder.totalWin_txt.text = String(obj.HandInfo.BonusWin);
			if (obj.HandInfo.HandState == 1)
			{
				bonusHolder.modifyCharacters(obj.HandInfo);
			}
		}
		
		public function showLoader():void
		{
			loaderMc = new LoaderMc();
			addChild(loaderMc);
		}
		
		public function hideLoader():void
		{
			if (loaderMc == null)
				return;
			loaderMc.disposeLoader();
			StaticGUI.safeRemoveChild(loaderMc, true)
			loaderMc = null;
		}
		
		public function addWildSelector(firstOpen:Boolean = false):void
		{
			wildSelector = new WildSelector(firstOpen);
			wildSelector.x = 65;
			wildSelector.y = 75;
			addChild(wildSelector);
		}
		
		public function removeWildSelector():void
		{
			wildSelector.destroy();
			StaticGUI.safeRemoveChild(wildSelector, true);
			wildSelector = null;
			
			if (rules != null)
			{
				removePaytable();
			}
			
			GoogleAnalytics._sendScreenView('Slot main screen');
		}
	
	}

}
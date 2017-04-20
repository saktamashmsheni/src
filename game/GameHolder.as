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
	import game.adjara.AdjaraSpins;
	import game.adjara.AdjaraSpinsGraphics;
	import game.doubleGame.DoubleHolder;
	import game.footer.CreditContainer;
	import game.header.musicPlayer.MusicManager;
	import game.machine.LineButtons;
	import game.machine.Lines;
	import game.machine.Machine;
	import game.machine.MultipleWins;
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
		public var lineButsHolder:LineButtons;
		public var linesHolder:Lines;
		private var freeSpinStatus:FreeSpinStatus;
		public var fourWayJackpotHolder:FourWayJackpot;
		public var currentFreeSpinNum:Number = 0;
		private var bonusStatusMc:BonusGameStatus;
		public var bigWinAnim:BigWinCont;
		public var wasEndMsg:Boolean;
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
		private var multipleWins:MultipleWins;
		private var endDelay:Number;
		private var sideAnim_con:SideAnim;
		public var SPIN_OBJ:Object;
		public static var WILD_FREE_SPIN:Boolean;
		public var leaderboardInfo_mc:LeaderboardInfo;
		public var scatterWinMc:ScatterWinWindow;
		public var LEADER_BOARD_OBJECT:Object;
		
		private var adjaraSpinsStatus:AdjaraSpinsGraphics;
		
		public function GameHolder()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			cont = this;
			initialise();
		}
		
		

		///asdasdasdasdas
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
			linesHolder.x = -373;
			linesHolder.y = -215;
			//linesHolder.alpha = .4;
			//linesHolder.scaleX = 1.03;
			//linesHolder.scaleY = 0.94;
			
			
			headerHolder = new HeaderHolder();
			headerHolder.y = -300;
			addChild(headerHolder);
			
			if (GameSettings.PREFERENCES.header != null && GameSettings.PREFERENCES.header.cont != null)
			{
				headerHolder.x += GameSettings.PREFERENCES.header.cont.OF_X;
				headerHolder.y += GameSettings.PREFERENCES.header.cont.OF_Y;
			}
			
			footerHolder = new FooterHolder();
			footerHolder.x = -373;
			footerHolder.y = 215;
			footerHolder.x = footerHolder.x + GameSettings.PREFERENCES.footer.cont.OF_X;
			footerHolder.y = footerHolder.y + GameSettings.PREFERENCES.footer.cont.OF_Y;
			addChild(footerHolder);
			footerHolder.addEventListener(GameEvents.SPIN_STARTED, spinStarted);
			
			
			addChild(linesHolder);
			linesHolder.addLineBtns(lineButsHolder);
			
			for (i = 0; i < this.numChildren; i++)
			{
				this.getChildAt(i).x += GAME_OFFSET_X;
			}
			
			if (GameSettings.TOURNAMENT_VISIBILITY)
			{
				leaderBoardHolder = new LeaderBoardHolder();
				leaderBoardHolder.x = -660;
				leaderBoardHolder.y = -300;
				addChild(leaderBoardHolder);
			}
			
			//winsPopLoader();
			
		    //TweenLite.delayedCall(2, showFreeSpinStatus, [2,0,2345645456]);
			
		}
		
		
		
		//init whole game
		public function initialiseWholeMachine(obj:Object):void
		{
			footerHolder.initFooter();
			footerHolder.updateBalance(obj.Chips);
			footerHolder.updateLines(GameSettings.ACT_LINES);
			footerHolder.updateBet(GameSettings.BET_INDEX);
			//machineHolder.updateIndexes(obj);
			machineHolder.initMachine();
			linesHolder.initLines();
			linesHolder.shown = true;//false
			lineButsHolder.initButtons();
			
			if (GameSettings.TOURNAMENT_VISIBILITY)
				leaderBoardHolder.initLeaderBoard();
			
			//winsPopLoader();
			
			//bigWinAnim = new BigWinCont(505050, 0);
			//this.addChild(bigWinAnim);
			
		}
		
		
		
		
		
		private function whenSpinComplete(e:GameEvents):void
		{
			SPIN_OBJ = e.params.socketObject;
			var sObj:Object = e.params.socketObject;
			var wildSpecNum:int = -1;
			var wildSpinDel:Number = 0;
			endDelay = 0;
			
			this.footerHolder.sendSpinSecureCount = 0;
			//free spins
			if (sObj.FreeSpins > 0)
			{
				MusicManager._cont._removeSound();
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
					
					GoogleAnalytics._sendScreenView('WILD Free Spin screen');
				}
				else
				{
					WILD_FREE_SPIN = false;
				}
				
				
				
				
				if (freeSpinsState != true)
				{
					freeSpinsState = true;
					if (WILD_FREE_SPIN == false)
					{
						showFreeSpinStatus(0, sObj.FreeSpins, 0, GameHolder.gameState);
					}
					
					GoogleAnalytics._sendScreenView('Free Spin screen');
				}
				else
				{
					if (WILD_FREE_SPIN == false)
					{
						showFreeSpinStatus(1, sObj.FreeSpins, 0, GameHolder.gameState);
					}
				}
				
				freeSpinsAmount += sObj.FreeSpins;
				
				//this.linesHolder.frameHolder.setBonusLikeIcons(sObj, machineHolder.scatterIndex);
				//this.machineHolder.setBonusLikeIconsAnimations(sObj, machineHolder.scatterIndex);
				if (sObj.WinnerLines.length > 0)
				{
					GameHolder.gameState = GameHolder.DOUBLE_STATE;
				}
				
				
				
				
				//this.machineHolder.showScatterBg();
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				footerHolder.updateState(GameHolder.NORMAL_STATE);
				footerHolder.spinEnabled = true;
				
				GameHolder.gameState = GameHolder.FREE_SPINS_STATE;
				
				
				
				
			}
			
			
			
			if (WILD_FREE_SPIN && sObj.FreeSpins > 0)
			{
				wildSpinDel = machineHolder.getWildSpinsDelCount(sObj.WildReels, sObj);
				trace("wildSpinDel: " + wildSpinDel);
			}
			
			
			if (sObj.WildReels.length > 0)
			{
				
				if (GameSettings.WILD_SPEC_TOP == 3 && GameSettings.SIDE_ANIM > 0)
				{
					TweenLite.delayedCall(2, machineHolder.modifyWildIcons, [sObj.WildReels, sObj, GameSettings.WILD_SPEC_TOP]);
				}
				else
				{
					machineHolder.modifyWildIcons(sObj.WildReels, sObj, GameSettings.WILD_SPEC_TOP, GameSettings.GAME_NAME == "sparta" ? true : false);
					if (GameSettings.GAME_NAME == "sparta")
					{
						Root.soundManager.PlaySound("wildSnd");
					}
				}
				
				
				endDelay += 1;
				
				if (GameSettings.WILD_SPEC_TOP == 3)
				{
					wildSpinDel = 3;
					footerHolder.spinEnabled = false;
					footerHolder.touchable = false;
					
					if (GameSettings.SIDE_ANIM)
					{
						addSideAnim();
					}
				}
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
					this.linesHolder.shown = true;
					if (GameSettings.GAME_NAME != "africa" && GameSettings.GAME_NAME != "5 diamonds")
					{
						this.linesHolder.frameHolder.setBonusLikeIcons(sObj, sObj.ScatterWin[i][1]);
					}
				}
				
				if (sObj.WinnerLines.length <= 0)
				{
					Root.soundManager.PlaySound("scatterWin");
				}
			}
			
			var bigWinIndex:int = -1;
			if (sObj.WinnerLines.length > 0 || sObj.ScatterWin.length > 0)
			{
				var collectDel:Number = 0.3;
				/*if (sObj.ScatterWin.length > 0)
				{
					collectDel = 2.2;
				}*/
				
				bigWinIndex = BigWinCont.shouldShow(footerHolder.totalBetAmount, sObj.TotalWin);
				if (WILD_FREE_SPIN && sObj.FreeSpins > 0)
				{
					bigWinIndex = -1;
				}
				
				if (bigWinIndex > -1)
				{
					bigWinAnim = new BigWinCont(sObj.TotalWin, bigWinIndex);
					bigWinAnim.x = GAME_OFFSET_X;
					TweenLite.delayedCall(wildSpinDel, this.addChild, [bigWinAnim]);
					
					if (gameState == AUTOPLAY_STATE)
					{
						collectDel = 9
					}
				}
				
				if (sObj.WinnerLines.length > 0)
				{
					var winStr:String = "winSnd";
					winStr += String(sObj.WinnerLines[0][1] + 1);
					TweenLite.delayedCall(wildSpinDel, Root.soundManager.PlaySound, [winStr]);
				}
				
				if (gameState == AUTOPLAY_STATE)
				{
					collectDel += 1;
				}
				
				//collectDel += (wildSpinDel + sObj.WinnerLines.length*0.4);
				
				if (!(WILD_FREE_SPIN && sObj.FreeSpins > 0))
				{
					TweenLite.delayedCall(collectDel, preEndDelayedFunc, [sObj]);
				}
			}
			
			/*//scatter
			if (sObj.FirstScatterWin > 0 || sObj.SecondScatterWin > 0)
			{
				scatterWinMc = new ScatterWinWindow(sObj.FirstScatterWin > 0 ? sObj.FirstScatterWin : sObj.SecondScatterWin);
				scatterWinMc.x = GAME_OFFSET_X;
				addChild(scatterWinMc);
			}*/
			
			
			
			if (WILD_FREE_SPIN && sObj.FreeSpins > 0)
			{
				footerHolder.spinEnabled = false;
				footerHolder.touchable = false;
				lineButsHolder.touchable = false;
				this.footerHolder.alpha = 0.9;
				//activate old messages
				endDelay += (wildSpinDel + sObj.WinnerLines.length*0.4);
				TweenLite.delayedCall(wildSpinDel + sObj.WinnerLines.length * 0.4, IniClass.cont.socketAnaliser.activateOldMessages);
			}
			else
			{
				//activate old messages
				TweenLite.delayedCall(wildSpinDel, IniClass.cont.socketAnaliser.activateOldMessages);
			}
			
			
			
			if (_freeSpinsState == true && WILD_FREE_SPIN == false)
			{
				if (!MusicManager._cont.isScatterSound)
				{
					MusicManager._cont.scatterSound();
				}
			}
			
			
			
			
			if (sObj.Bonus == true)
			{
				return;
			}
			
			
			if (bigWinIndex > -1)
			{
				if (_freeSpinsState == true && WILD_FREE_SPIN == false)
				{
					endDelay = 8.2 + wildSpinDel;
				}
				else
				{
					endDelay = 1 + wildSpinDel;
				}
				
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
			   
			   
			   
			    
				
				
				if (gameState == AUTOPLAY_STATE && sObj.WinnerLines.length > 0)
				{
					endDelay += 2;
				}
			   
				
		   
				//winner lines
				/*if (WILD_FREE_SPIN && sObj.FreeSpins > 0)
				{*/
					TweenLite.delayedCall(wildSpinDel, this.linesHolder.showWinnerLinesArr, [sObj, (sObj.Bonus == true) ? false : true]);
				/*}
				else
				{
					this.linesHolder.showWinnerLinesArr(sObj, (sObj.Bonus == true) ? false : true);
				}*/
				
				
				if (GameSettings.MULTIPLE_WINS && sObj.BulkDepth > 2)
				{
					addMultipleWins(sObj.BulkDepth);
				}
				
			trace("endDelay:" + endDelay);
			
			
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
		
		public function preEndDelayedFunc(obj:Object):void
		{
			//aq ise ar sheva es piroba tu ar shesrulda
			if (obj.WinnerLines.length > 0 || obj.ScatterWin.length > 0) {
				if (gameState != AUTOPLAY_STATE /*|| (WILD_FREE_SPIN == true && obj.FreeSpins > 0)*/)
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
		
		public function checkForEndmsg(obj:Object):void
		{
			if (wasEndMsg == false)
			{
				if (gameState != DOUBLE_STATE)
				{
					setTimeout(checkForEndmsg, 100, obj);
					return;
				}
			}
			
			if (!(WILD_FREE_SPIN && obj.FreeSpins > 0))
			{
				this.footerHolder.spinEnabled = true;
				this.footerHolder.touchable = true;
				this.footerHolder.alpha = 1;
				if (GameSettings.LINES_FIXED == false) {lineButsHolder.touchable = true};
			}
			if (freeSpinsState && currentFreeSpinNum > 0 && (currentFreeSpinNum) != freeSpinsAmount)
			{
				footerHolder.autoSpinAmount = 999;
				gameState = AUTOPLAY_STATE
			}
			
			
			//Tracer._log("################### " + freeSpinsState);
			//Tracer._log("################### " + currentFreeSpinNum);
			//Tracer._log("################### " + freeSpinsAmount);
			
			
			if (gameState == AUTOPLAY_STATE && !(!WILD_FREE_SPIN && obj.FreeSpins > 0))
			{
				TweenLite.delayedCall((obj.WinnerLines.length > 0 || obj.ScatterWin.length > 0) > 0 ? 1 : 0.2, this.footerHolder.autoSpinFunction);
			}
			
			
			else if (WILD_FREE_SPIN == true && (currentFreeSpinNum) != freeSpinsAmount && gameState != AUTOPLAY_STATE)
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
			//this.linesHolder.shown = false;
			if (freeSpinsState == true)
			{
				updateLogoWhileFreeSpins(-1, true);
			}
			
			
			if (AdjaraSpins.FreeSpinMode)
			{
				AdjaraSpins.updateCount();
			}
			
			if (freeSpinsState == false)
			{
				footerHolder.winAmount = 0;
				footerHolder.updateWin(footerHolder.winAmount);
			}
			
			SPIN_OBJ = null;
			wasEndMsg = false;
			
			GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS, 'spin', 'spin clicked');
		}
		
		//show error
		public function showFreeSpinStatus(statusState:int, frCount:int = 0, win:int = 0, gameState:int = -1):void
		{
			/*try
			{
				freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_START, freeSpinsStartFunc);
				freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_END, freeSpinsEndFunc);
				freeSpinStatus = null;
			}
			catch (err:Error)
			{
				
			}*/
			
			freeSpinStatus = new FreeSpinStatus(statusState, frCount, win, gameState);
			freeSpinStatus.addEventListener(GameEvents.FREE_SPINS_START, freeSpinsStartFunc);
			freeSpinStatus.addEventListener(GameEvents.FREE_SPINS_END, freeSpinsEndFunc);
			
			
			addChild(freeSpinStatus);
		}
		
		private function freeSpinsStartFunc(e:GameEvents):void
		{
			footerHolder.spinEnabled = true;
			GameHolder.gameState = GameHolder.NORMAL_STATE;
			footerHolder.updateState(GameHolder.gameState);
			footerHolder.onSpinClick();
		}
		
		private function freeSpinsEndFunc(e:GameEvents):void
		{
			currentFreeSpinNum = 0;
			freeSpinsState = false;
			WILD_FREE_SPIN = false;
			freeSpinsAmount = 0;
			
			GoogleAnalytics._sendScreenView('Slot main screen');
			
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
			MusicManager._cont._removeSound();
			MusicManager._cont.isScatterSound = false;
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
						showFreeSpinStatus(2, 0, obj.Win, gameState);
						//var str:String = FooterHolder.InLari == false ? obj.Win / GameSettings.CREDIT_VAL + " ქულა" : String((Number(obj.Win) / 100).toFixed(2)) + " GEL";
						//freeSpinStatus = new FreeSpinStatus(this, "თქვენ ამოგეწურათ FREE SPIN. თქვენ მოიგეთ " + str, false, gameState);
						//addChild(freeSpinStatus);
					}
				}
				else
				{
					gameState = NORMAL_STATE;
					footerHolder.updateState(gameState);
					if (WILD_FREE_SPIN != true)
					{
						showFreeSpinStatus(2, 0, obj.Win, gameState);
						//freeSpinStatus = new FreeSpinStatus(this, "თქვენ ამოგეწურათ FREE SPIN", false, gameState);
						//addChild(freeSpinStatus);
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
		
		public function removeFreeSpins():void
		{
			if (freeSpinStatus == null)
				return;
				
			freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_START, freeSpinsStartFunc);
			freeSpinStatus.removeEventListener(GameEvents.FREE_SPINS_END, freeSpinsEndFunc);
			freeSpinStatus.disposeFrStatus();
			StaticGUI.safeRemoveChild(freeSpinStatus, true);
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
			AdjaraSpins.updateCount(obj.AdjaraFreeSpins);
			
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
				
				headerHolder.logoMc.currentFrame = 1;
				TweenLite.from(headerHolder.logoMc, 0.4, {alpha: 0, scaleY: 0, ease: Expo.easeOut});
				TextField(headerHolder.getChildByName("freeSpins_txt")).visible = true;
				TextField(headerHolder.getChildByName("freeSpins_txt")).text = currentFreeSpinNum + " / " + freeSpinsAmount;
			}
			else
			{
				headerHolder.logoMc.currentFrame = 0;
				
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
			if ((IniClass.cont.assLoadMan.isInLoadingExperoenceDone(AssetsLoaderManager.BONUS_LIBRARY)) == true)
			{
				return;
			}
			IniClass.cont.assLoadMan.clearLoadManager();
			IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "BonusLibrary.swf", AssetsLoaderManager.BONUS_LIBRARY, AssetsLoaderManager.SWFType);
			IniClass.cont.assLoadMan.startLoadAssets();
		}
		
		public function loadAndAddBonus(BonusStrikes:int):void
		{
			
			showLoader();
			if (IniClass.cont.assLoadMan.isInLoadingExperoence(AssetsLoaderManager.BONUS_LIBRARY))
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
				IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "BonusLibrary.swf", AssetsLoaderManager.BONUS_LIBRARY, AssetsLoaderManager.SWFType);
				IniClass.cont.assLoadMan.startLoadAssets();
			}
		}
		
		
		
		
		
		
		
		/*public function loadAndAddBigWinsLoader():void
		{
			showLoader();
			if (IniClass.cont.assLoadMan.isInLoadingExperoence(AssetsLoaderManager.WINS_POP_LIBRARY))
			{
				addBigWinAnim();
				return;
			}
			bonusHolder = new BonusMcContainer(footerHolder.totalBetAmount, BonusStrikes);
			if (Assets.BigWinsLoaded)
			{
				addBigWinAnim();
			}
			
			
			IniClass.cont.assLoadMan.clearLoadManager();
			IniClass.cont.assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, bigWinPopLoaded);
			IniClass.cont.assLoadMan.setLoadAssets(GameSettings.PATH + "WinsPopLibrary.swf", AssetsLoaderManager.WINS_POP_LIBRARY, AssetsLoaderManager.SWFType);
			IniClass.cont.assLoadMan.startLoadAssets();
			
			
		}
		
		private function bigWinPopLoaded(e:AssetsLoaderEvents):void {
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, bigWinPopLoaded);
			
			addBigWinAnim();
		}
		
		private function addBigWinAnim():void 
		{
			this.addChild(bigWinAnim);
		}*/
		
		
		
		
		
		
		
		private function allBonusAssetsLoaded(e:AssetsLoaderEvents):void
		{
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, allBonusAssetsLoaded);
			addBonusGame();
		}
		
		public function addBonusGame():void
		{
			if (!(IniClass.cont.assLoadMan.isInLoadingExperoenceDone(AssetsLoaderManager.BONUS_LIBRARY)))
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
				var bigWinIndex:int = BigWinCont.shouldShow(footerHolder.totalBetAmount, bonusWin);
				if (bigWinIndex > -1)
				{
					bigWinAnim = new BigWinCont(bonusWin, bigWinIndex);
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
				IniClass.cont.assLoadMan.setLoadAssets(IniClass.GET_FILE_FULL_PATH("PaytableLibrary.swf"), AssetsLoaderManager.PAYTABLE_LIBRARY, AssetsLoaderManager.SWFType);
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
			return;
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
				IniClass.cont.assLoadMan.setLoadAssets(IniClass.GET_FILE_FULL_PATH("JackpotWinLibrary.swf", true), AssetsLoaderManager.JACKPOT_LIBRARY, AssetsLoaderManager.SWFType);
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
			StaticGUI.safeRemoveChild(jackpotWinAnimation, true);
			jackpotWinAnimation = null;
		}
		
		public function hideSlotItemsForStates(hideFooter:Boolean = false):void
		{
			
			TweenLite.to(machineHolder.iconsHolder, 0.5, {autoAlpha: 0});
			TweenLite.to(linesHolder, 0.5, {autoAlpha: 0});
			TweenLite.to(linesHolder.frameHolder, 0.5, {autoAlpha: 0});
			
			if (hideFooter)
			{
				//footerHolder.touchable = false;
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
				//footerHolder.touchable = true;
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
			
			if (obj.HandInfo == null)
				return;
				
			
			//update credit
			if (obj.HandInfo.SpinResult.Bet > GameSettings.BETS_AR[GameSettings.BETS_AR.length - 1])
			{
				for (var i:int = 0; i < GameSettings.CREDIT_AR.length; i++) 
				{
					if (GameSettings.BETS_AR.indexOf(obj.HandInfo.SpinResult.Bet / GameSettings.CREDIT_AR[i]) != -1)
					{
						var betIndex:int = GameSettings.BETS_AR.indexOf(obj.HandInfo.SpinResult.Bet / GameSettings.CREDIT_AR[i]);
						CreditContainer.cont.updateCreditManual(GameSettings.CREDIT_AR[i]);
						
						obj.HandInfo.SpinResult.Bet = GameSettings.BETS_AR[betIndex];
						break;
					}
				}
			}
			
			
			footerHolder.updateBet(GameSettings.BETS_AR.indexOf(obj.HandInfo.SpinResult.Bet));
			footerHolder.updateLines(obj.HandInfo.SpinResult.Line);
			if (obj.HandInfo.SpinResult.Reels)
			{
				machineHolder.setCustomReels(obj.HandInfo.SpinResult.Reels);
				TweenLite.delayedCall(0.1, linesHolder.showWinnerLinesArr, [obj.HandInfo.SpinResult, false]);
			}
			linesHolder.hideAllLines();
			
			
			
			
			if (obj.HandInfo.DoubleState)
				footerHolder.updateWin(obj.HandInfo.DoubleState.Win);
			else
				footerHolder.updateWin(obj.HandInfo.SpinResult.TotalWin);
			
				
			if (obj.HandInfo.DoubleState)
			{
				GameHolder.gameState = GameHolder.DOUBLE_STATE;
				this.footerHolder.updateState(GameHolder.DOUBLE_STATE);
				footerHolder.spinEnabled = true;
				GameHolder.cont.hideSlotItemsForStates();
				showDoubleHolder(obj.HandInfo.DoubleState.Win);
				this.doubleHolder.modifyCardsOnReconnect(obj.HandInfo.DoubleState.Cards);
				GameHolder.cont.lineButsHolder._isEnabled(false);
			}
			
			if (obj.HandInfo.FreeSpinState)
			{
				GameHolder.cont.lineButsHolder._isEnabled(false);
				if (obj.HandInfo.FreeSpinState.FreeSpinState == 1)
					WILD_FREE_SPIN = true;
				else
					WILD_FREE_SPIN = false;
					
					
				footerHolder.spinEnabled = false;
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				footerHolder.updateState(GameHolder.NORMAL_STATE);
				
				freeSpinsAmount = obj.HandInfo.FreeSpinState.TotalFreeSpin;
				
				currentFreeSpinNum = 0;
				freeSpinsState = true;
				footerHolder.spinEnabled = true;
				
				if (GameHolder.WILD_FREE_SPIN == false)
					updateLogoWhileFreeSpins(obj.HandInfo.FreeSpinState.FreeSpins);
				
				GameHolder.gameState = GameHolder.NORMAL_STATE;
				
				
				footerHolder.freeSpinsWinAmount = obj.HandInfo.SpinResult.TotalWin;
				footerHolder.updateWin(obj.HandInfo.SpinResult.TotalWin);
				
				if (WILD_FREE_SPIN)
				{
					///wild
					machineHolder.setWildStaticReels(obj.HandInfo.SpinResult.WildReels);
					machineHolder.modifyWildIcons(obj.HandInfo.SpinResult.WildReels, obj.HandInfo.SpinResult, GameSettings.WILD_SPEC_TOP)
				}
				
			}
			
			if (_freeSpinsState == true && WILD_FREE_SPIN == false)
			{
				if (!MusicManager._cont.isScatterSound)
				{
					MusicManager._cont.scatterSound();
				}
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
		
		
		
		public function addMultipleWins(xNum):void 
		{
			multipleWins = new MultipleWins(xNum);
			addChild(multipleWins);
		}
		public function removeMultipleWins():void 
		{
			if (multipleWins == null) return;
			
			multipleWins.destroyALL();
			StaticGUI.safeRemoveChild(multipleWins, true);
			multipleWins = null;
		}
		
		
		
		public function addSideAnim():void
		{
			sideAnim_con = new SideAnim();
			addChild(sideAnim_con);
			sideAnim_con.x = 330;
			sideAnim_con.y = -30;
		}
		
		public function removeSideAnim():void
		{
			StaticGUI.safeRemoveChild(sideAnim_con);
			sideAnim_con = null;
		}
		
		
		
		
		///-----adjara spins------
		public function loadAndAddAdjaraSpinsStatus():void {
			
			if (IniClass.cont.assLoadMan.Busy)
			{
				setTimeout(loadAndAddAdjaraSpinsStatus, 200);
				return;
			}
			
			if (adjaraSpinsStatus != null) {
				removeAdjaraSpinsStatus();
				return;
			}
			
			showLoader();
			adjaraSpinsStatus = new AdjaraSpinsGraphics();
			//showLoader();
			if (Assets.adjaraSpinsLoaded) {
				addAdjaraSpinsStatus();
			} else {
				IniClass.cont.assLoadMan.clearLoadManager();
				IniClass.cont.assLoadMan.addEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, adjaraSpinsAssetsLoaded);
				IniClass.cont.assLoadMan.setLoadAssets(IniClass.GET_FILE_FULL_PATH("adjaraSpinsLibrary.swf", true),AssetsLoaderManager.ADJARA_FREE_SPINS, AssetsLoaderManager.SWFType);
				IniClass.cont.assLoadMan.startLoadAssets();
			}
		}
		
		private function adjaraSpinsAssetsLoaded(e:AssetsLoaderEvents):void {
			IniClass.cont.assLoadMan.removeEventListener(AssetsLoaderEvents.ALL_ASSETS_LOADED, adjaraSpinsAssetsLoaded);
			addAdjaraSpinsStatus();
		}
		
		public function addAdjaraSpinsStatus():void {
			hideLoader();
			addChild(adjaraSpinsStatus);
			adjaraSpinsStatus.x = 510;
			adjaraSpinsStatus.y = -160;
			adjaraSpinsStatus.initAdjaraSpins();
		}
		
		public function removeAdjaraSpinsStatus():void {
			StaticGUI.safeRemoveChild(adjaraSpinsStatus, true);
			adjaraSpinsStatus = null;
		}
		
		public function removeAdjaraSpinsCont():void 
		{
			adjaraSpinsStatus.disposeAll();
			StaticGUI.safeRemoveChild(adjaraSpinsStatus, true);
			adjaraSpinsStatus = null;
		}
	
	}

}
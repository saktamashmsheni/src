package connection {
	import com.Rijndael.util.Hex;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.GAnalyticsEvents;
	import com.utils.GoogleAnalytics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import game.adjara.AdjaraSpins;
	import game.adjara.AdjaraSpinsGraphics;
	import jackpotCL.FourWayJackpot;
	import game.GameHolder;
	import leaderBoard.LeaderBoardHolder;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class SocketAnaliser extends EventDispatcher {
		
		public var socketObject:Object;
		
		public static var addNew:int = 1;
		public static var spin:int = 2;
		public static var collect:int = 3;
		public static var bonusItem:int = 4;
		public static var end:int = 6;
		public static var freeSpinComplete:int = 7;
		public static var rating:int = 8;
		public static var jackpot:int = 9;
		public static var fourWayJackpot:int = 10;
		public static var doubleGameHalf:int = 12;
		public static var spinWild:int = 14;
		public static var wildSelect:int = 17;
		public static var spinScatter:int = 61;
		public static var _leaderTimer:int = 18;
		public static var _leaderBoard:int = 17;
		public static var _leaderTOPUsers:int = 16;
		public static var _leaderPrizes:int = 19;
		public static var gameBalance:int = 54;
		public static var adjaraSpins:int = 45;
		
		public var StopMessage:Boolean = false;
		private var messagesArr:Array = [];
		private var timer:Timer;
		
		
		public static var AUTH_OBJECT:Object;
		
		public function init():void {
			Root.connectionManager.addEventListener(ConnectionManager.ON_CONNECTION, Authorize);
			Root.connectionManager.addEventListener(ConnectionManager.ON_CONNECTION_LOST, connectionLost);
			Root.connectionManager.addEventListener(ConnectionManager.ON_SOCKET_DATA, onSocketData);
		}
		
		private function Authorize(e:Event):void {
			Tracer._log("...connected");
			Root.connectionManager.sendData({SID: Root.userRoomSession, UID: Root.userRoomId, MT: SocketAnaliser.addNew}, true);
			
			if (timer == null) {
				timer = new Timer(10000, 0);
				timer.addEventListener(TimerEvent.TIMER, SendPing);
				timer.start();
			}
			
			
		
		/*dispatchEvent(new GameEvents(GameEvents.CONNECTED));*/
		}
		
		private function SendPing(e:TimerEvent):void {
		}
		
		private function connectionLost(e:Event):void {
			Main.cont._showError(1000);
			
			GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'connection lost','connection was lost');
		}
		
		//activate old messages
		public function activateOldMessages():void {
			StopMessage = false;
			if (messagesArr.length <= 0) {
				return;
			}
			{
				takeAction(messagesArr[0]);
				messagesArr.shift();
				if (StopMessage == true) {
					return;
				}
			}
			
			///shemowmebaa
			if (messagesArr.length > 0) {
				activateOldMessages();
			}
		
		}
		
		private function dontStopBool(messageType:int):Boolean {
			if (messageType == 9999) {
				return true;
			}
			
			return false;
		}
		
		private function onSocketData(e:Event):void {
			socketObject = Root.connectionManager.obj;
			
			if (StopMessage && dontStopBool(socketObject.messageType) == false) {
				messagesArr.push(socketObject);
				return;
			} else {
				takeAction(socketObject);
			}
		}
		
		
		
		private function takeAction(socketObject:Object):void {
			
			/*if (shouldEnableLoader(socketObject.MT) == true)
			   {
			   LoaderMc.container.disable();
			   }*/
			
			if (socketObject.IM.ErrorCode) {
				Main.cont._showError(socketObject.IM.ErrorCode);
			}
			
			switch (socketObject.MT) {
				case addNew: 
					
					
					StopMessage = true;
					
					AUTH_OBJECT = socketObject.IM;
 					
					GameSettings.GAME_ID = socketObject.IM.GameID;
					
					GameSettings.SYS_NUM = socketObject.IM.Reels;
					//GameSettings.SYS_NUM = 2;
					
					GameSettings.TOTAL_ICONS = socketObject.IM.ImagesCount;
					
					//currency
					GameSettings.Currency_ID = socketObject.IM.CurrencyID;
					GameSettings.Currency_Rate = socketObject.IM.Buy;
					//GameSettings.Currency_ID = 3;
					//GameSettings.Currency_Rate = 1.5;
					
					//lines
					GameSettings.TOTAL_LINES = socketObject.IM.Lines.Number;
					GameSettings.ACT_LINES = socketObject.IM.Lines.Number;
					GameSettings.LINES_FIXED = socketObject.IM.Lines.Fixed;
					GameSettings.LINES_VISIBILITY = socketObject.IM.Lines.Visible;
					GameSettings.LINES_COUNT_CONFIG = socketObject.IM.Lines.LinesCountConfig;
					
					GameSettings.BETS_AR = socketObject.IM.CurrencyBets;
					
					
					GameSettings.WILDS_AR = socketObject.IM.WILDS;
					for (var i:int = 0; i < GameSettings.WILDS_AR.length; i++) 
					{
						if (GameSettings.WILDS_AR[i][1] > GameSettings.WILD_SPEC_TOP)
							GameSettings.WILD_SPEC_TOP = GameSettings.WILDS_AR[i][1];
						
					}
					GameSettings.SCATTERS_AR = socketObject.IM.SCATTERS;
					GameSettings.BONUSES_AR = [];
					
					
					GameSettings.PAYTABLE_AR = socketObject.IM.PayTable;
					
					
					Root.Key = Hex.toArray(socketObject.IM.Key);
					
					
					
					//jackpot
					GameSettings.IS_JACKPOT_ON = socketObject.IM.JackPotAmount;
					//GameHolder.cont.showJackpotStartWindow();
					//FourWayJackpot.cont.updateInfo(socketObject.IM.JackPotStats, socketObject.IM);
					
					IniClass.cont.startLoadAssets();
					
					
					
					
					break;
					
					
				case adjaraSpins:
					if (socketObject.IM.Elapsed && socketObject.IM.Elapsed == true)
					{
						if (AdjaraSpinsGraphics.cont)
						{
							AdjaraSpinsGraphics.cont.elapsed();
						}
						GameHolder.cont.footerHolder.spinEnabled = true;
					}
					else if (socketObject.IM.FreeSpinMode == false)
					{
						GameHolder.cont.loadAndAddAdjaraSpinsStatus();
						AdjaraSpins.setSpins(socketObject.IM);
					}
					else if(socketObject.IM.FreeSpinMode == true)
					{
						GameHolder.cont.footerHolder.updateBet(GameSettings.BETS_AR.indexOf(uint((socketObject.IM.Bet))));
						GameHolder.cont.footerHolder.updateLines(socketObject.IM.Line);
						
						AdjaraSpins.setSpins(socketObject.IM);
						AdjaraSpinsGraphics.cont.initAdjaraSpins();
					}
				break;
					
				/*case wildSelect:
					Root.ALL_WILD_INDEX = socketObject.IM.Icon;
					GameHolder.cont.machineHolder.updateWildIcons();
					GameHolder.cont.removeWildSelector();
				break;*/
				
				case _leaderBoard:
					if (!GameSettings.TOURNAMENT_VISIBILITY)
						return;
						
					if (!LeaderBoardHolder.FILLED)
					{
						LeaderBoardHolder.FILLED = true;
						LeaderBoardHolder.cont.updateLeaderInfo(socketObject.IM)
						//LeaderboardHolder.cont.updateLeaderInfo(Root.leaderAr[Root.leaderInd]);
					}
					else
					{
						GameHolder.cont.LEADER_BOARD_OBJECT = socketObject.IM;
						//GameHolder.cont.LEADER_BOARD_OBJECT = Root.leaderAr[Root.leaderInd];
					}
					//Root.leaderInd++;
					
					
				break;
				
					
				case _leaderTOPUsers:
					if (!GameSettings.TOURNAMENT_VISIBILITY)
						return;
					LeaderBoardHolder.cont.onTopUsersResponse(socketObject.IM);
				break;
				
				case _leaderPrizes:
					if (!GameSettings.TOURNAMENT_VISIBILITY)
						return;
					LeaderBoardHolder.cont.onPrizesResponse(socketObject.IM);
				break;
					
				case _leaderTimer:
					if (!GameSettings.TOURNAMENT_VISIBILITY)
						return;
					LeaderBoardHolder.cont.updateTimer(socketObject.IM);
				break;
				
				
				case spin: 
					StopMessage = true;
					GameHolder.cont.machineHolder.startSpin(socketObject.IM);
					if (GameSettings.IS_JACKPOT_ON) {
						//JackpotInfo.cont.updateInfo(socketObject.IM.JackPotStats);
					}
					GameHolder.cont.footerHolder.updateBalance(socketObject.IM.Chips);
					break;
				
				case collect: 
					GameHolder.cont.updateDoubleHolder(socketObject.IM);
					break;
				
				case doubleGameHalf:
					GameHolder.cont.updateDoubleHalfHolder(socketObject.IM);
					break;
				case bonusItem: 
					GameHolder.cont.bonusHolder.bonusItemChosen(socketObject.IM);
					break;
				
				
				case end: 
					//GameHolder.cont.updateLogoWhileFreeSpins(socketObject.IM.TotalFreeSpins);
					GameHolder.cont.end(socketObject.IM);
					break;
				
				case freeSpinComplete: 
					GameHolder.cont.freeSpinCompleteMessage(socketObject.IM);
					break;
				
				/*case rating:
				   RatingWindow.cont.update(socketObject.IM);
				   break;*/
				
				/*case jackpot:
				   GameHolder.cont.showJackPot(socketObject.IM.Win, socketObject.IM.JackPotID);
				   GameHolder.cont.footerHolder.updateBalance(socketObject.IM.Chips);
				   break;*/
				
				case fourWayJackpot: 
					try 
					{
						FourWayJackpot.cont.updateInfo(socketObject.IM.Stats, socketObject.IM);
					}catch (err:Error)
					{
						
					}
					
					break;
				
				case jackpot: 
					GameHolder.cont.loadAndAddJackpotWin(socketObject.IM.Win, socketObject.IM.JackPotID);
					GameHolder.cont.footerHolder.updateBalance(socketObject.IM.Chips);
					GameHolder.cont.stopAutoSpinIfThereIsOnJackpot();
					break;
				
				//transfer
				case gameBalance: 
					if (GameHolder.cont.transferHolder != null) {
						GameHolder.cont.transferHolder.processData(socketObject);
						GameHolder.cont.footerHolder.updateBalance(socketObject.IM.GameBalance);
					}
					break;
				case 52: 
					if (GameHolder.cont.transferHolder != null) {
						GameHolder.cont.transferHolder.processData(socketObject);
					}
					break;
				case 53: 
					if (GameHolder.cont.transferHolder != null) {
						GameHolder.cont.transferHolder.processData(socketObject);
					}
					break;
			}
		}
		
		public static function shouldEnableLoader(msgNum:int):Boolean {
			if (msgNum == 2 || msgNum == 3 || msgNum == 4 || msgNum == 5) {
				return false;
			}
			return true;
		}
	
	}

}
package {
	
	//import connection.SocketAnaliser;
	import bonus.BonusMcContainer;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.utils.GAnalyticsEvents;
	import com.utils.GoogleAnalytics;
	import com.utils.MouseEvent;
	import com.utils.StaticGUI;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import game.BigWin;
	import game.GameHolder;
	import net.hires.debug.Stats;
	import notifi.ErrorStatus;
	import starling.core.Starling
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.ResizeEvent;
	
	public class Main extends Sprite {
		
		private var stats:Stats;
		private var myStarling:Starling;
		private var bgImg:Image;
		private var gameHolder:GameHolder;
		private var errorStatus:ErrorStatus;
		private var errorInterval:int;
		public static var cont:Main;
		
		public function Main() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			visible = false;
			cont = this;
			
			
		}
		
		public function startMain():void
		{
			initialise();
			stage.addEventListener(ResizeEvent.RESIZE, onResize);
			onResize(null);
		}
		
		
		public function initialise():void {
			
			bgImg = new Image(Assets.getTexture("gameBg"));
			this.addChild(bgImg);
			
			StaticGUI.setAlignPivot(bgImg)
			
			/*bgImg.x = -(bgImg.width - this.stage.stageWidth) / 2;
			bgImg.y = -(bgImg.height - this.stage.stageHeight) / 2;*/
			
			bgImg.x = this.stage.stageWidth / 2;
			bgImg.y = this.stage.stageHeight/ 2;
			
			gameHolder = new GameHolder();
			addChild(gameHolder);
			gameHolder.x = int(this.stage.stageWidth / 2);
			gameHolder.y = int(this.stage.stageHeight / 2 - 15);
			
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, myKeyDown);
			
			GoogleAnalytics._sendScreenView('Slot main screen');
		
		}
		
		
		
		public function onResize(e:ResizeEvent):void {
			// set rectangle dimensions for viewPort:
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = e != null ? e.width : Starling.current.stage.stageWidth;//e.width;
			viewPortRectangle.height = e != null ? e.height : Starling.current.stage.stageHeight;//e.height Starling.current.stage.stageHeight;
			
			// resize the viewport:
			Starling.current.viewPort = viewPortRectangle;
			
			// assign the new stage width and height:
			stage.stageWidth = e != null ? e.width : Starling.current.stage.stageWidth;
			stage.stageHeight = e != null ? e.height : Starling.current.stage.stageHeight;
			
			//bgImg.width = stage.stageWidth;
			//bgImg.height = stage.stageHeight;
			
			//bgImg.x = (stage.stageWidth - bgImg.width) / 2;
			//bgImg.y = (stage.stageHeight - bgImg.height) / 2;
			
			var stageScaleX:Number = parseFloat(Number(stage.stageWidth / 1000).toFixed(1));
			var stageScaleY:Number = parseFloat(Number(stage.stageHeight / 750).toFixed(1));
			
			
			bgImg.scaleX = bgImg.scaleY = gameHolder.scaleX = gameHolder.scaleY = (stageScaleX > stageScaleY) ? stageScaleY : stageScaleX;
			
			if (gameHolder.scaleX < 0.9) {
				bgImg.scaleX = bgImg.scaleY = gameHolder.scaleX = gameHolder.scaleY = 0.9;
			}
			
			//gameHolder.scaleY = gameHolder.scaleX + 0.1;
			
			gameHolder.x = (GameSettings.TOURNAMENT_VISIBILITY == true) ? int(stage.stageWidth / 2) + GameSettings.PREFERENCES.game.OFF_X : int(stage.stageWidth / 2);
			gameHolder.y = int(stage.stageHeight) / 2 + GameSettings.PREFERENCES.game.OFF_Y;
			
			bgImg.x = this.stage.stageWidth / 2;
			bgImg.y = this.stage.stageHeight/ 2;
			
			
		}
		
		public function showGame():void {
			TweenLite.to(this, 0.5, {autoAlpha: 1});
			//this.alpha = 1;
			//this.visible = 1;
			
			Root.soundManager.PlaySound("uiStart");
		}
		
		
		
		
		private function myKeyDown(e:KeyboardEvent):void {
			if (GameHolder.gameState == GameHolder.AUTOPLAY_STATE || GameHolder.cont.freeSpinsState == true) {
				return;
			}
			
			if (e.keyCode == Keyboard.SPACE) {
				tryTostopScroll();
			}
		}
		
		public function tryTostopScroll():void {
			
			if (GameHolder.cont.footerHolder.spinEnabled == false) {
				//TweenMax.killDelayedCallsTo(GameHolder.cont.machineHolder.StopScroll);
				//TweenLite.delayedCall(0, GameHolder.cont.machineHolder.StopScroll, [null, true]);
				GameHolder.cont.machineHolder.makeFastStop();
				return;
			}
			try {
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, myKeyDown);
				if (GameHolder.cont.footerHolder.touchable != false)
				{
					GameHolder.cont.footerHolder.onSpinClick(null);
				}
				TweenLite.delayedCall(0.1, function():void {
					Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, myKeyDown);
				});
			} catch (err:Error) {
				
			}
		}
		
		//show error
		public function _showError(errCd:int, customText:String = "", clear:Boolean = false):void {
			if (errorStatus != null && errorStatus.parent != null) {
				if (clear == false) {
					errorInterval = setInterval(function():void {
						_showError(errCd, customText, true);
					}, 1500);
					return;
				} else {
					clearInterval(errorInterval);
					StaticGUI.safeRemoveChild(errorStatus, true);
					errorStatus = null;
				}
			} else {
				//Root.soundManager.PlaySound("support");
			}
			errorStatus = new ErrorStatus(errCd, null, customText);
			addChild(errorStatus);
			
			GoogleAnalytics._sendActionEvent(GAnalyticsEvents.GAME_EVENTS,'ERROR','error');
		}
		
	
	}

}

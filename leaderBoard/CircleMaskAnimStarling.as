package leaderBoard  {
	
	import com.greensock.TweenLite;
	import com.utils.StaticGUI;
	import feathers.controls.text.BitmapFontTextRenderer;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import leaderBoard.LeaderBoardEvents;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.TextureMaskStyle;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class CircleMaskAnimStarling extends Sprite {
		
		private var image:Image;
		private var bmd:BitmapData;
		private var value:Number = 0;
		private var radius:Number = 100;
		private var bmd2:BitmapData;
		private var shape2:Shape;
		private var leaderBoardTimer:Timer;
		private var timeLeft:int = -1;
		private var totalTime:int;
		private var toStart:Boolean = false;
		private var img:Image;
		private var circleTimerProgress:RadialProgressBar;
		
		public function CircleMaskAnimStarling() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void {
			
			bmd = drawBitmapDataCircle(value, radius,1);
			
			const sprite:Sprite = new Sprite();
			
			/*var ca:Canvas = new Canvas();
			ca.beginFill(0xff3400);
			ca.drawCircle(100, 100, 100);
			ca.endFill();*/
			
			
			/*img = new Image(Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml").getTexture("timer_line.png"));
			img.x = 21;
			img.y = 75;*/
			//img.color = Color.RED;
			//ca.alpha = 0;
			//sprite.addChild(ca);
			//sprite.addChild(img);
			//addChild(sprite);
			//image = new Image(Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml").getTexture("timer_line.png"));
			image = new Image(Texture.fromBitmapData(bmd));
			/*
			image.x = 0;
			image.y = 0;
			const style:TextureMaskStyle = new TextureMaskStyle();
			image.style = style;
			sprite.mask = image;*/
			//this.addEventListener(Event.ENTER_FRAME, onEnt)
			
			
			circleTimerProgress = new RadialProgressBar();
			circleTimerProgress.x = -78;
			circleTimerProgress.y = -25;
			addChild(circleTimerProgress);
			
			
		}
		
		public function upldateTimer(timeLeft:int, totalTime:int, toStart:Boolean):void
		{
			
			
			
			if (toStart == true)
			{
				circleTimerProgress.changeColor(Color.GRAY);
			}
			else
			{
				if (timeLeft > 1800000)
				{
					circleTimerProgress.changeColor(0xffffff);
				}
				else
				{
					circleTimerProgress.changeColor(Color.RED);
				}
			}
			
			
			
			if (leaderBoardTimer != null)
			{
				if (this.timeLeft - leaderBoardTimer.currentCount - timeLeft/100 <= 2)
				{
					return;
				}
			}
			
			
			this.totalTime = totalTime/1000;
			this.toStart = toStart;
			
			/*if (this.timeLeft != -1 && this.timeLeft != timeLeft && this.timeLeft - timeLeft > 0)
			{
				for (var i:int = 0; i < this.timeLeft - timeLeft; i++) 
				{
					TweenLite.delayedCall(1/i/(this.timeLeft - timeLeft), 
				}
			}*/
			
			
			this.timeLeft = timeLeft/1000;
			
			if (leaderBoardTimer == null)
			{
				leaderBoardTimer = new Timer(1000, this.timeLeft)
				leaderBoardTimer.addEventListener(TimerEvent.TIMER, onEnt);
				leaderBoardTimer.start();
			}
			else
			{
				value = 0;
				leaderBoardTimer.stop();
				leaderBoardTimer.removeEventListener(TimerEvent.TIMER, onEnt);
				leaderBoardTimer = null;
				leaderBoardTimer = new Timer(1000, this.timeLeft)
				leaderBoardTimer.addEventListener(TimerEvent.TIMER, onEnt);
				leaderBoardTimer.start()
			}
		}
		
		private function onEnt(e:TimerEvent):void {
			
			//value += 1/totalTime;
			//bmd = drawBitmapDataCircle(value, radius, timeLeft/totalTime);
			
			//image.texture = Texture.fromBitmapData(bmd);
			
			value = timeLeft / totalTime;
			circleTimerProgress.value = value;
			
			dispatchEvent(new LeaderBoardEvents(LeaderBoardEvents.TIMER_EVENT, {timerCount:timeLeft - leaderBoardTimer.currentCount}));
			
		}
		
		private function drawBitmapDataCircle(value, radius, fillPersent:Number):BitmapData {
			if(bmd2 != null) bmd2.dispose();
			bmd2 = null;
			shape2 = null;
			bmd2 = new BitmapData(radius * 2, radius * 2, true, 0x000000);
			shape2 = new Shape;
			
			shape2.graphics.lineStyle(1, 0x0000ff, 1);
			shape2.graphics.beginFill(0x123456, 1);
			drawWedge(shape2.graphics, radius, radius, radius, 360*fillPersent - (360 * value) % 360, 180);
			shape2.graphics.endFill();
			
			bmd2.draw(shape2);
			
			return bmd2;
		}
		
		private function drawWedge(target:flash.display.Graphics, x:Number, y:Number, radius:Number, arc:Number, startAngle:Number = 0, yRadius:Number = 0):void {
			if (yRadius == 0) {
				yRadius = radius;
			}
			
			target.moveTo(x, y);
			
			var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
			
			if (Math.abs(arc) > 360) {
				arc = 360;
			}
			
			segs = Math.ceil(Math.abs(arc) / 45);
			segAngle = arc / segs;
			theta = -(segAngle / 180) * Math.PI;
			angle = -(startAngle / 180) * Math.PI;
			if (segs > 0) {
				ax = x + Math.cos(startAngle / 180 * Math.PI) * radius;
				ay = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
				target.lineTo(ax, ay);
				for (var i:int = 0; i < segs; ++i) {
					angle += theta;
					angleMid = angle - (theta / 2);
					bx = x + Math.cos(angle) * radius;
					by = y + Math.sin(angle) * yRadius;
					cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
					cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
					target.curveTo(cx, cy, bx, by);
				}
				target.lineTo(x, y);
			}
		}
	}
}
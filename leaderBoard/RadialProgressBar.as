package leaderBoard {
	//import com.thebutton.assets.Assets;
	//import com.thebutton.theme.T;
	import feathers.core.FeathersControl;
	import starling.display.Canvas;
	import starling.display.Image;
	import starling.events.Event;
	import starling.geom.Polygon;
	import starling.utils.Color;
	import starling.utils.deg2rad;
 
	/**
	 * Progress bar with radial mask.
	 * @author Jakub Wagner, J4W
	 */
	public class RadialProgressBar extends FeathersControl {
		private var background:Image;
		private var progress:Image;
		private var canvas:Canvas;
		private var polygon:Polygon;
 
		private var sides:Number = 8;
		private var _value:Number = 1;
		private var _fromRotation:Number = deg2rad(-180);
 
		public function RadialProgressBar() {
			super();
		}
 
		override protected function initialize():void {
			super.initialize();
 
			canvas = new Canvas();
			canvas.y = -55;
 
			//background = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("grass_bg.png"));
			//background.y = -40;
			//background.alpha = 0;
			//background.x = T.s(33);
			//background.y = T.s(32);
 
			progress = new Image(Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml").getTexture("timer_line.png"));
 
			//addChild(background);
			addChild(progress);
			addChild(canvas);
			
			scaledActualWidth = progress.width;
			scaledActualHeight = progress.height;
 
			progress.mask = canvas;
			
			//canvas.rotation = deg2rad(90);
			
			
			//addEventListener(Event.ENTER_FRAME, onent);
		}
		
		/*private function onent(e:Event):void 
		{
			this.value -= 0.01;
			if (this.value <= 0)
			{
				this.value = 1;
			}
		}*/
 
		override protected function draw():void {
			super.draw();
 
			var radius:Number = progress.width / 2;
 
			polygon = new Polygon();
			updatePolygon(value, radius, radius, radius, _fromRotation);
 
			canvas.clear();
			canvas.beginFill(0xFF0000);
			canvas.drawPolygon(polygon);
			canvas.endFill();
		}
 
		public function get value():Number {
			return _value;
		}
		
		
		public function changeColor(col:uint):void
		{
			if (col == progress.color) return;
			progress.color = col;
		}
 
		public function set value(value:Number):void {
			if (_value != value) {
				invalidate(INVALIDATION_FLAG_DATA);
				_value = value;
			}
		}
 
		//[Inline]
		private function lineToRadians(rads:Number, radius:Number, x:Number, y:Number):void {
			polygon.addVertices(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
		}
 
		private function updatePolygon(percentage:Number, radius:Number = 50, x:Number = 0, y:Number = 0, rotation:Number = 0):void {
			polygon.addVertices(x, y);
			if (sides < 3)
				sides = 3; // 3 sides minimum
 
			radius /= Math.cos(1 / sides * Math.PI);
 
			var sidesToDraw:int = Math.floor(percentage * sides);
			for (var i:int = 0; i <= sidesToDraw; i++)
				lineToRadians((i / sides) * (Math.PI * 2) -rotation, radius, x, y);
 
			if (percentage * sides != sidesToDraw)
				lineToRadians(percentage * (Math.PI * 2) - rotation, radius, x, y);
		}
 
	}
 
}
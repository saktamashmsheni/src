package game.header.volumeController 
{
	import feathers.controls.Button;
	import feathers.controls.ProgressBar;
	import feathers.controls.Slider;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.utils.Align;
	import starling.utils.Align;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class SliderVolume extends Slider
	{
		private var progressBar:ProgressBar;
		
		
		public function SliderVolume() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			this.useHandCursor = true;
			
			this.minimum = 0;
			this.maximum = 100;
			this.step = 1;
			this.page = 10;
			this.value = 100;
			this.height = 98;
			this.minimumPadding = 0;
			this.maximumPadding = 0;
			this.addEventListener( Event.CHANGE, slider_changeHandler );
			
			//this.thumbProperties.defaultSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderHead.png") );
			//this.thumbProperties.downSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderHead.png") );
			
			var quad:Quad = new Quad(10, 5);
			quad.alpha = 0;
			
			this.thumbProperties.defaultSkin = quad;
			this.thumbProperties.downSkin = quad;
			
			
			this.minimumTrackFactory = function():Button
			{
				var button:Button = new Button();
				//skin the minimum track here
				button.defaultSkin = new Image(Assets.getAtlas("headerSheet", "headerSheetXml").getTexture("volume_slider_bg.png"));
				button.downSkin = new Image(Assets.getAtlas("headerSheet", "headerSheetXml").getTexture("volume_slider_bg.png"));
				//button.alpha = 0;
				return button;
			}
			
			this.validate();
			
			progressBar = new ProgressBar();
			progressBar.direction = this.direction;
			progressBar.x = 0;
			progressBar.y = 0;
			progressBar.minimum = this.minimum;
			progressBar.maximum = this.maximum;
			progressBar.value = this.value;
			progressBar.width = 20;
			progressBar.height = this.height;
			//progressBar.minimumPadding = -5;
			//progressBar.maximumPadding = -5;
			progressBar.touchable = false;
			this.addChild(progressBar);
			progressBar.fillSkin = new Image(Assets.getAtlas("headerSheet", "headerSheetXml").getTexture("volume_slider.png"));
			progressBar.fillSkin.height = 1;
			progressBar.fillSkin.width = 8;
			progressBar.validate();
			
			this.alignPivot(Align.CENTER, Align.CENTER);
			//progressBar.alignPivot(Align.CENTER, Align.CENTER);
			
			
		}
		
		private function slider_changeHandler(e:Event):void 
		{
			progressBar.value = this.value;
		}
		
	}

}
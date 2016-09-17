package cashier 
{
	import feathers.controls.Button;
	import feathers.controls.ProgressBar;
	import feathers.controls.Slider;
	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.Align;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class SliderTransf extends Slider
	{
		private var progressBar:ProgressBar;
		
		
		public function SliderTransf() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, added);
			
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			
			this.minimum = 0;
			this.maximum = 100;
			this.step = 1;
			this.page = 10;
			this.value = 0;
			this.width = 400;
			this.minimumPadding = 30;
			this.maximumPadding = 30;
			this.addEventListener( Event.CHANGE, slider_changeHandler );
			
			this.thumbProperties.defaultSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderHead.png") );
			this.thumbProperties.downSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderHead.png") );
			
			
			this.minimumTrackFactory = function():Button
			{
				var button:Button = new Button();
				//skin the minimum track here
				button.defaultSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderBg.png") );
				button.downSkin = new Image( Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("sliderBg.png") );
				return button;
			}
			
			this.validate();
			
			progressBar = new ProgressBar();
			progressBar.x = 35;
			progressBar.y = 35;
			progressBar.minimum = this.minimum;
			progressBar.maximum = this.maximum;
			progressBar.value = this.value;
			progressBar.width = this.width - 70;
			progressBar.height = 15;
			//progressBar.minimumPadding = -5;
			//progressBar.maximumPadding = -5;
			this.addChildAt(progressBar,0);
			progressBar.fillSkin = new Image(Assets.getAtlas("transferSheet", "transferSheetXml").getTexture("loadBg.png"));
			progressBar.fillSkin.width = 10;
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
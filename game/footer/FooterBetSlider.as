package game.footer {
	import feathers.controls.Button;
	import feathers.controls.Slider;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	

	public class FooterBetSlider extends Sprite {
		
		private var $betSlider:Slider;
		private var $betChangeHandler:Function;
		
		public function FooterBetSlider() {
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}
		
		private function addedHandler(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, remmovedHandler);
			
			$betSlider = new Slider();
			$betSlider.minimum = 0;
			$betSlider.maximum = GameSettings.BETS_AR.length-1;
			$betSlider.value = 0;
			$betSlider.step = 1;
			$betSlider.page = 10;
			$betSlider.width = 140;
			$betSlider.thumbOffset = 3;
			$betSlider.minimumPadding = -6;
			$betSlider.maximumPadding = -6;
			$betSlider.addEventListener( Event.CHANGE, sliderChangeHandler);
			addChild($betSlider);
			
			//$betSlider.thumbProperties.defaultSkin = new Image( Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("slider_scr.png") );
			//$betSlider.thumbProperties.downSkin = new Image( Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("slider_scr.png") );
			
			var $textureAtlas:TextureAtlas = Assets.getAtlas("footerSheet", "footerSheetXml");
			
			$betSlider.minimumTrackProperties.defaultSkin = new Image($textureAtlas.getTexture("slider_line.png"));
			$betSlider.minimumTrackProperties.downSkin = new Image($textureAtlas.getTexture("slider_line.png"));
			
			$betSlider.thumbProperties.defaultSkin = new Image($textureAtlas.getTexture("slider_scr.png"));
			$betSlider.thumbProperties.downSkin = new Image($textureAtlas.getTexture("slider_scr.png"));
			$betSlider.thumbProperties.disabledSkin = new Image($textureAtlas.getTexture("slider_scr_disabled.png"));
			
			/*$betSlider.thumbFactory = function():Button {
				
				var button:Button = new Button();
				
				button.defaultSkin = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("slider_scr.png"));
				button.downSkin = new Image(Assets.getAtlas("footerSheet", "footerSheetXml").getTexture("slider_scr.png"));
				return button;
			}*/
			$betSlider.validate();
			
		}
		
		public function _isEnabled(boo:Boolean = true):void{
			
			this.touchable = boo
			$betSlider.isEnabled = boo;
			this.useHandCursor = boo;
			if (boo){
				
				//this.alpha = 1;
			}else{
				//this.alpha = .5;
			}
		}
		
		public function set _betChangeCallBack(func:Function):void {
			$betChangeHandler = func;
		}
		
		private function sliderChangeHandler(e:Event):void {
			var slider:Slider = Slider( e.currentTarget );
			GameSettings.BET_INDEX = slider.value;
			$betChangeHandler();
			
		}
		
		private function remmovedHandler(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, remmovedHandler);
			if ($betSlider) {
				$betSlider.dispose();
			}
			this.dispose();
			this.removeChildren();
		}
		
	}

}
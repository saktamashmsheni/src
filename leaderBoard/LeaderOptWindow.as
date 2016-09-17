package leaderBoard 
{
	import com.utils.StaticGUI;
	import feathers.controls.Button;
	import feathers.controls.ScrollBar;
	import feathers.controls.ScrollContainer;
	import feathers.controls.ScrollInteractionMode;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class LeaderOptWindow extends Sprite
	{
		private var _atlas:TextureAtlas;
		private var bg:Image;
		private var prizeScroller:ScrollContainer;
		private var prizeItemsArray:Array = [];
		private var topScroller:ScrollContainer;
		private var topItemsArray:Array = [];
		
		public var WINDOW_TYPE:int = -1;
		
		public function LeaderOptWindow(type:int) 
		{
			WINDOW_TYPE = type;
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			initLeaderOptWin();
		}
		
		
		
		private function initLeaderOptWin():void 
		{
			_atlas = Assets.getAtlas("leaderboardSheet", "leaderboardSheetXml");
			
			bg = new Image(_atlas.getTexture("opt_page_bg.png"));
			StaticGUI.setAlignPivot(bg, "TC");
			bg.x = bg.width / 2;
			
			if (WINDOW_TYPE == 1)
			{
				bg.scaleX = -1;
			}
			
			addChild(bg);
			
			
			
		}
		
		public function addInfo(obj:Object):void
		{
			if (WINDOW_TYPE == 0)
			{
				createPrizesWindow(obj);
			}
			else if (WINDOW_TYPE == 1)
			{
				createTopUsersWindow(obj);
			}
		}
		
		private function createTopUsersWindow(obj:Object):void 
		{
			topScroller = new ScrollContainer();
			this.addChild( topScroller );
			
			topItemsArray = [];
			
			var topItem:TopItem;
			for (var i:int = 0; i < obj.Users.length; i++) 
			{
				topItem = new TopItem(obj.Users[i][0], obj.Users[i][1], obj.Users[i][2], obj.Users[i][3]);
				topScroller.addChild(topItem);
				topItemsArray.push(topItem);
			}
			topItem = null;
			
			topScroller.width = 147;
			topScroller.height = 287;
			topScroller.x = 7;
			topScroller.y = 27;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			topScroller.layout = layout;
			
			topScroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			topScroller.interactionMode = ScrollInteractionMode.MOUSE;
			topScroller.verticalScrollBarFactory = function ():ScrollBar
			{
				var scrollbar:ScrollBar = new ScrollBar();
			 	scrollbar.useHandCursor = true;
				scrollbar.direction = ScrollBar.DIRECTION_VERTICAL;
			 
				scrollbar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
			 
				scrollbar.thumbFactory = function ():Button
				{
					var button:Button = new Button();
					//button.defaultSkin = new Quad(10, 50, 0x000000);
					button.defaultSkin = new Image(_atlas.getTexture("opt_page_scroller.png"));
					return button;
				}
			 
				scrollbar.minimumTrackFactory = function ():Button
				{
					var button:Button = new Button();
					//button.defaultSkin = new Quad(10, 10, 0x999999);
					button.defaultSkin = new Image(_atlas.getTexture("opt_page_scroller_bg.png"));
					return button;
				}
			 
				return scrollbar;
			}
			
			topScroller.validate();
		}
		
		
		
		private function createPrizesWindow(obj:Object):void 
		{
			
			prizeScroller = new ScrollContainer();
			this.addChild( prizeScroller );
			
			prizeItemsArray = [];
			
			var prizeItem:PrizeItem;
			for (var i:int = 0; i < obj.Winners.length; i++) 
			{
				prizeItem = new PrizeItem(i + 1, obj.Winners[i]);
				prizeScroller.addChild(prizeItem);
				prizeItemsArray.push(prizeItem);
			}
			prizeItem = null;
			
			prizeScroller.width = 147;
			prizeScroller.height = 287;
			prizeScroller.x = 7;
			prizeScroller.y = 25;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			prizeScroller.layout = layout;
			
			prizeScroller.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FIXED;
			
			prizeScroller.interactionMode = ScrollInteractionMode.MOUSE;
			prizeScroller.verticalScrollBarFactory = function ():ScrollBar
			{
				var scrollbar:ScrollBar = new ScrollBar();
				scrollbar.useHandCursor = true;
				scrollbar.direction = ScrollBar.DIRECTION_VERTICAL;
			 
				scrollbar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
			 
				scrollbar.thumbFactory = function ():Button
				{
					var button:Button = new Button();
					//button.defaultSkin = new Quad(10, 50, 0x000000);
					button.defaultSkin = new Image(_atlas.getTexture("opt_page_scroller.png"));
					return button;
				}
			 
				scrollbar.minimumTrackFactory = function ():Button
				{
					var button:Button = new Button();
					//button.defaultSkin = new Quad(10, 10, 0x999999);
					button.defaultSkin = new Image(_atlas.getTexture("opt_page_scroller_bg.png"));
					return button;
				}
			 
				return scrollbar;
			}
			
			prizeScroller.validate();
		}
		
		
		
		public function disposeAll():void 
		{
			var i:int;
			_atlas = null;
			
			StaticGUI.safeRemoveChild(bg, true);
			bg = null;
			
			
			if (WINDOW_TYPE == 0)
			{
				for (i = 0; i < prizeItemsArray.length; i++) 
				{
					prizeItemsArray[i].disposeAll();
					StaticGUI.safeRemoveChild(prizeItemsArray[i], true);
				}
				prizeItemsArray = [];
				prizeItemsArray = null;
				StaticGUI.safeRemoveChild(prizeScroller, true);
				prizeScroller = null;
				prizeItemsArray = null;
				
				StaticGUI.safeRemoveChild(prizeScroller, true);
				prizeScroller = null;
			}
			else if (WINDOW_TYPE == 1)
			{
				for (i = 0; i < topItemsArray.length; i++) 
				{
					topItemsArray[i].disposeAll();
					StaticGUI.safeRemoveChild(topItemsArray[i], true);
				}
				topItemsArray = [];
				topItemsArray = null;
				StaticGUI.safeRemoveChild(topScroller, true);
				topScroller = null;
				topItemsArray = null;
				
				StaticGUI.safeRemoveChild(topScroller, true);
				topScroller = null;
			}
			
			StaticGUI.safeRemoveChild(this, true);
		}
		
	}

}
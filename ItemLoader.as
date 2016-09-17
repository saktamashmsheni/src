package  {
	
	import application.MainSettings;
	import flash.events.ProgressEvent;
	import flash.events.Event;

	
	public class ItemLoader extends LoaderCore {
		
		public function ItemLoader() {
			
			_callLoadAssets('mygame.ge/uploads/games/jokerjapanese/', 'flash/', 'itemLibrary_0001.swf');
			
		}
		
		override public function _onComplete(event:Event):void {
			
			try {
				
				var $o:Object = event.target.applicationDomain;
				
				 //cards: */
				
				ItemLibrary._historyController_Source                 = $o.getDefinition("dynamicClass.HistoryController_Source") as Class;
				
				_configureRemoveListeners();
				
				
				dispatchEvent(new AppEvent(AppEvent.ITEMLIBRARY_LOADED, null, true));
			} catch (e:ReferenceError) {
				
				//MainSettings.instance.container.preloader.error_txt.text = e;
				throw new Error("error loading ItemLibrary: " + e);
				
			}
		}

		
		override public function _onProgressHandler(event:ProgressEvent):void {
			
			MainSettings.instance.container.preloader._updateProgress(event.bytesTotal, event.bytesLoaded, null, 'Loading Graphic Assets...');
		
		}
	}
}
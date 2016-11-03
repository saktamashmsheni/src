package
{
	import com.greensock.TweenLite;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class AssetsLoaderManager extends EventDispatcher
	{
		private var preAssetsAr:Array = [];
		
		private var totalLoads:int;
		private var currentLoads:int = 0;
		
		private var _busy:Boolean = false; 
		private var curLoadingObj:Object;
		
		public static const SWFType:String = "swf";
		public static const XMLType:String = "xml";
		public static const JsonType:String = "json";
		
		
		// Loading assets cons names, it saves in dictionary
		
		public static const ITEMS_LIBRARY:String = 'itemsLibrary';
		public static const ICONS_LIBRARY:String = 'iconsLibrary';
		public static const FONTS_LIBRARY:String = 'fontsLibrary';
		public static const SOUND_LIBRARY:String = 'soundLibrary';
		public static const XML_MUI_PACK:String = 'XMLMuipack';
		public static const PAYTABLE_LIBRARY:String = 'paytableLibrary';
		public static const BONUS_LIBRARY:String = 'bonusLibrary';
		public static const JACKPOT_LIBRARY:String = 'jackpotLibrary';
		public static const WINS_POP_LIBRARY:String = 'winsPopLibrary';
		public static const CONFIGURATION:String  = 'configuration';
		
		
		private var loadersAr:Array;
		
		private var allLoadExperienceDic:Dictionary = new Dictionary();
		private var swfLoader:Loader;
		private var xmlLoader:URLLoader;
		
		public function setLoadAssets(path:String, valTxt:String, type:String):void
		{
			var obj:Object = { "path":path, "valTxt": valTxt, "type":type }
			allLoadExperienceDic[obj.valTxt] = 0;
			preAssetsAr.push(obj);
			
			totalLoads = preAssetsAr.length;
			
			obj = null;
		}
		
		
		public function isInLoadingExperience(nameStr:String):Boolean
		{
			if (allLoadExperienceDic[nameStr] != null)
			{
				return true;
			}
			return false;
		}
		
		public function isInLoadingExperoenceDone(nameStr:String):Boolean
		{
			if (allLoadExperienceDic[nameStr] != null && allLoadExperienceDic[nameStr] == 1)
			{
				return true;
			}
			return false;
		}
		
		
		public function clearLoadManager():void
		{
			for (var i:int = 0; i < preAssetsAr.length; i++) 
			{
				preAssetsAr[i] = null;
			}
			preAssetsAr = [];
			
			currentLoads = 0;
		}
		
		
		public function startLoadAssets():void 
		{
			if (preAssetsAr.length == 0) 
			{
				Busy = false;
				return;
			}
			
			Busy = true;
			
			curLoadingObj = preAssetsAr[0];
			loadersAr = [];
			
			if (curLoadingObj.type == SWFType)
			{
				swfLoader = new Loader();
				swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaderComplete);
				swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, swfLoaderProgress);
				if (!Root.TESTING)
				{
					var context:LoaderContext = new LoaderContext( true, new ApplicationDomain( ApplicationDomain.currentDomain ), SecurityDomain.currentDomain );
					swfLoader.load(new URLRequest(curLoadingObj.path),context);
				}
				else
				{
					swfLoader.load(new URLRequest(curLoadingObj.path));
				}
				
				loadersAr.push(swfLoader);
			}
			else if (curLoadingObj.type == XMLType || curLoadingObj.type == JsonType)
			{
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, xmlLoaderComplete, false, 0, true);
				xmlLoader.addEventListener(ProgressEvent.PROGRESS, xmlLoaderProgress);
				xmlLoader.load(new URLRequest(curLoadingObj.path));
				loadersAr.push(xmlLoader);
			}
		}
		
		
		public function unLoadAllLoaders():void
		{
			for (var i:int = 0; i < loadersAr.length; i++) 
			{
				if (loadersAr[i] is Loader)
				{
					Loader(loadersAr[i]).unloadAndStop();
					
					loadersAr[i] = null;
				}
				else if (loadersAr[i] is URLLoader)
				{
					loadersAr[i] = null;
				}
			}
			loadersAr = [];
		}
		
		
		
		
		
		//------xml------
		private function xmlLoaderProgress(e:ProgressEvent):void 
		{
			curLoadingObj.loaded = Number(e.bytesLoaded);
			curLoadingObj.total = Number(e.bytesTotal);
			currentLoaderProgress(curLoadingObj);
		}
		
		private function xmlLoaderComplete(e:Event):void 
		{
			if (curLoadingObj.type == XMLType)
			{
				curLoadingObj.content = new XML(e.target.data);
				currentLoaderComplete(curLoadingObj);
				startLoadAssets();
			}
			else if (curLoadingObj.type == JsonType)
			{
				curLoadingObj.content = JSON.parse(e.target.data);
				currentLoaderComplete(curLoadingObj);
				startLoadAssets();
			}
		}
		
		
		//-------swf-------
		private function swfLoaderProgress(e:ProgressEvent):void 
		{
			curLoadingObj.loaded = Number(e.bytesLoaded);
			curLoadingObj.total = Number(e.bytesTotal);
			currentLoaderProgress(curLoadingObj);
		}
		
		private function swfLoaderComplete(e:Event):void 
		{
			curLoadingObj.content = e.target;
			currentLoaderComplete(curLoadingObj);
			startLoadAssets();
		}
		
		
		
		
		
		
		
		//---------------current loader ----------------
		private function currentLoaderProgress(obj:Object):void
		{
			dispatchEvent(new AssetsLoaderEvents(AssetsLoaderEvents.CUR_ASSET_PROGRESS_INFO, obj));
		}
		
		private function currentLoaderComplete(obj:Object):void
		{
			allLoadExperienceDic[obj.valTxt] = 1;
			preAssetsAr.shift();
			dispatchEvent(new AssetsLoaderEvents(AssetsLoaderEvents.CUR_ASSET_LOADED, obj));
			updateLoad();
			
			Tracer._log(allLoadExperienceDic);
		}
		
		
		
		
		
		
		
		//---------------------------------------------------------------------------
		public function updateLoad():void
		{
			currentLoads++;
			Tracer._log("updateLoad " + currentLoads);
			if (currentLoads == totalLoads)
			{
				//TweenLite.delayedCall(2, function(){
					dispatchEvent(new AssetsLoaderEvents(AssetsLoaderEvents.ALL_ASSETS_LOADED));
					Busy = false;
				//});
			}
		}
		
		
		
		
		public function get Busy():Boolean 
		{
			return _busy;
		}
		
		public function set Busy(value:Boolean):void 
		{
			_busy = value;
		}
	
	}

}
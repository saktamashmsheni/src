package game.machine {
	import com.utils.StaticGUI;
	import game.GameHolder;
	import game.machine.iconFrame;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.Color;
	
	/**
	 * ...
	 * @author ...
	 */
	public class IconFramesHolder extends Sprite {
		private var testFrame:iconFrame;
		
		public function IconFramesHolder() {
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			setUpFrames();
		}
		
		private function setUpFrames():void {
			for (var i:int = 0; i < 15; i++) {
				testFrame = new iconFrame(Assets.getAtlas("iconFrames", "iconFramesXml").getTextures("win_frames_"), 50);
				testFrame.name = "frame_icon" + String(i + 1);
				//StaticGUI.setAlignPivot(testFrame);
				testFrame.x = int(i % 5 * (169) - 37);

				testFrame.y = int(int(i / 5) * (138) - 37);
				testFrame.visible = false;
				addChild(testFrame);
				testFrame.stop();
					//Starling.juggler.add(testFrame);
			}
		}
		
		public function initIconFrameHolder(icludeBonus:Boolean = true):void {
			for (var i:int = 0; i < 15; i++) {
				testFrame = getChildByName("frame_icon" + String(i + 1)) as iconFrame;
				if (icludeBonus == false && testFrame.isBonusLike == true) {
					continue;
				}
				testFrame.currentFrame = 0;
				testFrame.visible = false;
				testFrame.isBonusLike = false;
				
				Starling.juggler.remove(testFrame);
			}
		}
		
		public function setFrames(obj:Object, index:int, arr:Array):void {
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			initIconFrameHolder(false);
			
			curLine = Lines.lineNumAr[obj.WinnerLines[index][0]];
			
			//indexebis mixedvit framebis ageba da gamochena 
			for (var i:int = 0; i < arr.length; i++) {
				num = (curLine[arr[i]] - 1) * 5 + (arr[i] + 1);
				testFrame = getChildByName("frame_icon" + String(num)) as iconFrame;
				Starling.juggler.add(testFrame);
				testFrame.play();
				testFrame.visible = true;
				
				
				/*for (var j:int = 0; j < obj.WildReels.length; j++) 
				{
					if (arr[i] == obj.WildReels[j][0])
					{
						testFrame.visible = false;
					}
				}*/
				
				//testFrame.visible = true; //!!!!
				
				
			}
		
		}
		
		public function calcCurLineIndexesAr(obj:Object, index:int):Array {
			var indexesAr:Array;
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			initIconFrameHolder(false);
			
			curLine = Lines.lineNumAr[obj.WinnerLines[index][0]];
			
			indexesAr = []
			
			//indexebis ageba sadac iconebis
			for (var k:int = 0; k < obj.Reels.length; k++) {
				if (obj.Reels[k][curLine[k] - 1] == (obj.WinnerLines[index][1])) {
					var o:int = k;
					while (o--) {
						if (obj.Reels[o] != null && obj.Reels[o][curLine[o] - 1] != null && Machine.isWildIcon(obj.Reels[o][curLine[o] - 1])) {
							if (indexesAr.indexOf(o) == -1) {
								indexesAr.push(o);
							}
						} else {
							break;
						}
					}
					for (var j:int = k + 1; j < 5; j++) {
						if (obj.Reels[j] != null && obj.Reels[j][curLine[j] - 1] != null && Machine.isWildIcon(obj.Reels[j][curLine[j] - 1])) {
							if (indexesAr.indexOf(j) == -1) {
								indexesAr.push(j);
							}
						} else {
							break;
						}
					}
					
					indexesAr.push(k);
				}
			}
			indexesAr.sort(Array.NUMERIC);
			var newIndexesAr:Array = [];
			
			//indexebis mixedvit framebis ageba da gamochena 
			for (var i:int = 0; i < indexesAr.length; i++) {
				if (indexesAr[i] == 0 && indexesAr[1] != 1) {
					//indexesAr = indexesAr.splice(i);
					continue;
				} else if (indexesAr[i] == 4 && indexesAr[i - 1] != 3) {
					//Tracer._log(curLine[i]);
					//indexesAr = indexesAr.splice(i);
					continue;
				}
				
				newIndexesAr.push(indexesAr[i]);
				
			}
			
			return newIndexesAr;
		
		}
		
		
		
		public function setBonusLikeIcons(obj:Object, icoInd:int):void
		{
			var indexesAr:Array;
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			initIconFrameHolder(false);
			
			indexesAr = []
			
			
			//indexebis ageba sadac iconebis
			
			for (var k:int = 0; k < obj.Reels.length; k++)
			{
				for (var j:int = 0; j < obj.Reels[k].length; j++)
				{
					curLine = Lines.lineNumAr[k];
					if (obj.Reels[k][j] == (icoInd))
					{
						indexesAr.push(j * 5 + (k + 1));
						Tracer._log(k);
					}
				}
			}
			
			//indexebis mixedvit framebis ageba da gamochena 
			for (var i:int = 0; i < indexesAr.length; i++)
			{
				testFrame = getChildByName("frame_icon" + String(indexesAr[i])) as iconFrame;
				Starling.juggler.add(testFrame);
				testFrame.play();
				testFrame.visible = true;
				testFrame.isBonusLike = true;
			}
		
		}
		
	
	}

}
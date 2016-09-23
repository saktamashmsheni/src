package game.machine {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	import com.utils.StaticGUI;
	import game.GameHolder;
	import game.header.musicPlayer.MusicManager;
	import game.machine.Icon;
	import game.machine.IconFramesHolder;
	import game.machine.LineButtons;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Lines extends Sprite {
		public var frameHolder:IconFramesHolder;
		private var lineBtns:LineButtons;
		private var testButt:DisplayObject;
		private var testLine:DisplayObject;
		private var _shown:Boolean = true;
		private var winAnimIndex:int;
		private var indexesAr:Array;
		private var curLine:Array;
		
		private var linesContainer:Sprite;
		private var linesMask:Sprite;
		private var testMaskIcon:Quad;
		private var maskIconsAr:Array;
		public var lineWinStatus:LineWinStatus;
		public var transformedAr:Array;
		
		public static var cont:Lines;
		public static var lineNumAr:Array;
		
		
		
		public function Lines() {
			this.addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			cont = this;
		}
		
		private function setUpLines():void {
			var img:Image;
			var imgSp:Sprite;
			
			if (GameSettings.SYS_NUM == 0 && GameSettings.TOTAL_LINES == 27)
				lineNumAr = GameSettings.LINES_AR[3];
			else
				lineNumAr = GameSettings.LINES_AR[GameSettings.SYS_NUM];
			
				
				
			linesContainer = new Sprite();
			addChild(linesContainer);
			
			linesMask = new Sprite();
			linesMask.x = -30;
			linesMask.y = -60;
			addChild(linesMask);
			
			var quad:Quad;
			
			quad = new Quad(30, 420, Color.GRAY);
			quad.alpha = .5;
			quad.x = -quad.width;
			linesMask.addChild(quad);
			
			maskIconsAr = [];
			for (var j:int = 0; j < 15; j++) {
				quad = new Quad(Icon.iconWidth +14, Icon.iconHeight + 16, Color.RED);
				maskIconsAr.push(quad);
				quad.alpha = 1;
				quad.x = int(j % 5 * 165);
				quad.y = int(j / 5) * (135)+2;
				linesMask.addChild(quad);
				
				
			}
			
			/*quad = new Quad(15, 420, Color.GRAY);
			quad.x = linesMask.width - quad.width*2;
			linesMask.addChild(quad);*/
			
			for (j = 0; j < 5; j++) {
				
				quad = new Quad(40, 420, Color.GREEN);
				quad.alpha = 1;
				quad.x = 165*j+133;
				linesMask.addChild(quad);
			}
			
			linesContainer.mask = linesMask;
			
			var $textureName:String;
			var $textureAtlas:TextureAtlas = Assets.getAtlas("lines", "linesXml");
			
			//var $lineYPosVect:Vector.<int> = new Vector.<int>[210, 42, 335, 0, 20, 35, 250, 80, 80, 0];
			
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) {
				imgSp = new Sprite();
				$textureName = "lines" + StaticGUI.intWithZeros((i + 1),2) + ' instance 10000';
				img = new Image($textureAtlas.getTexture($textureName));
				//img.color = Color.RED;
				imgSp.addChild(img);
				//imgSp.visible = false;
				linesContainer.addChild(imgSp);
				imgSp.x = 5;
				imgSp.name = "line" + String(i + 1);
				//imgSp.y = $lineYPosVect[i];
				
				/*switch(i+1) {
					case 1:
						imgSp.y = 210;
						break;
					case 2:
						imgSp.y = 42;
						break;
					case 3:
						imgSp.y = 335;
						break;
						
					case 4:
						
						break;
					case 5:
						imgSp.y = 20;
						break;
						
					case 6:
						imgSp.y = 35;
						break;
						
					case 7:
						imgSp.y = 250;
						break;
						
					case 8:
						imgSp.y = 80;
						break;
						
					case 9:
						imgSp.y = 80;
						break;
						
					case 10:
						imgSp.y = 0;
						break;
				}*/
				
				//img.dispose();
			}
			
			linesContainer.scaleX = 1.65;
			linesContainer.scaleY = 1.5;
			linesContainer.x = -60;
			
			img = null;
			imgSp = null;
		}
		
		public function addLineBtns(lineBtns:LineButtons):void {
			this.lineBtns = lineBtns;
		}
		
		//init lines
		public function initLines():void {
			
			setUpLines();
			
			lineWinStatus = new LineWinStatus();
			addChild(lineWinStatus);
			
			frameHolder = new IconFramesHolder();
			frameHolder.x = -40;
			frameHolder.y = -60;
			//frameHolder.scaleX = 0.94;
			//frameHolder.scaleY = 1.1;
			addChild(frameHolder);
			addChild(linesMask)
			GameHolder.cont.footerHolder.addEventListener(GameEvents.LINE_CHANGED, whenLineisChanged);
			
			
			
		
		}
		
		
		
		//------winning line---------------------------------
		public function showWinnerLinesArr(obj:Object, animateLines:Boolean = true):void {
			var ic:Icon;
			var i:int;
			if (obj.WinnerLines.length == 0) {
				return;
			}
			
			
			
			winAnimIndex = 0;
			this.shown = true;
			
			lineAnimationStarter(obj, animateLines);
			
		}
		
		private function resetAnimatedIc(ic:Icon):void 
		{
			ic.rotation = deg2rad(0);
			ic.x = 0;
			ic.y = 0;
			
			
			var ind:int = transformedAr.indexOf(ic)
			if (ind == transformedAr.length - 1)
			{
				transformedAr = [];
			}
		}
		
		
		
		private function lineAnimationStarter(obj:Object, animateLines:Boolean):void
		{
			var i:int;
			for (i = 0; i < obj.WinnerLines.length; i++) {
				showWinnerLine(obj.WinnerLines[i][0] + 1);
			}
			
			if (/*animateLines && */GameHolder.cont.doubleHolder == null)
			{
				TweenMax.delayedCall(0.3, winnerLineStartAnDelay, [obj]);
			}
		}
		
		
		
		private function showWildAnimation(obj:Object, wildIcAr:Array, transformedAr:Array):void 
		{
			for (var i:int = 0; i < transformedAr.length; i++) 
			{
				//transformedAr[i].visible = false;
			}
			
			for (var j:int = 0; j < wildIcAr.length; j++) 
			{
				//Icon(wildIcAr[j]).playIcon();
			}
		}
		
		public function winnerLineStartAnDelay(obj:Object):void {
			//MusicManager._cont._addOrRemoveMusicMuter(MusicManager.MUSIC_MUTE);
			hideAllLines();
			animateLine(obj);
			//animateWinnerIcons(obj);
			//Root.soundManager.schedule("RegularWinSnd", 1);
			GameHolder.cont.machineHolder.animateIcons(obj);
		}
		
		
		
		public function resetMaskIcons():void {
			for (var j:int = 0; j < maskIconsAr.length; j++) {
				maskIconsAr[j].visible = true;
			}
		}
		
		public function setCurLineMaskIcons(obj:Object, index:int, arr:Array):void {
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			curLine = lineNumAr[obj.WinnerLines[index][0]];
			
			resetMaskIcons();
			
			//indexebis mixedvit framebis ageba da gamochena 
			for (var i:int = 0; i < arr.length; i++) {
				num = (curLine[arr[i]] - 1) * 5 + (arr[i] + 1);
				testMaskIcon = maskIconsAr[num - 1] as Quad;
				
				testMaskIcon.visible = false;
			}
		
		}
		
		
		
		
		//animate line
		private function animateLine(obj:Object):void {
			var i:int;
			showWinnerLine(obj.WinnerLines[winAnimIndex][0] + 1);
			
			var curLineIndAr:Array = frameHolder.calcCurLineIndexesAr(obj, winAnimIndex);
			frameHolder.setFrames(obj, winAnimIndex, curLineIndAr);
			this.setCurLineMaskIcons(obj, winAnimIndex, curLineIndAr);
			//GameHolder.cont.machineHolder.animateIcons(obj, winAnimIndex, curLineIndAr);
			
			//Root.soundManager.PlaySound("icon" + String(obj.WinnerLines[winAnimIndex][1] + 1));
			//Root.soundManager.PlaySound("iconSound");
			
			//masking
			curLine = Lines.lineNumAr[obj.WinnerLines[winAnimIndex][0]];
			indexesAr = [];
			
			//indexebis ageba sadac iconebis
			for (var k:int = 0; k < obj.Reels.length; k++) {
				if (obj.Reels[k][curLine[k] - 1] == (obj.WinnerLines[winAnimIndex][1]) ||Machine.isWildIcon(obj.Reels[k][curLine[k] - 1])) {
					
					if (curLineIndAr.indexOf(k) == -1) {
						continue;
					}
					indexesAr.push(k);
				}
			}
			
			/*if (obj.WinnerLines.length == 1) {
				return;
			}*/
			
			lineWinStatus.setStatus(obj.WinnerLines[winAnimIndex]);
			
			TweenMax.delayedCall(winAnimIndex == obj.WinnerLines.length - 1 ? 2 : 1, animateLinesContDel, [obj]);
		}
		
		public function animateLinesContDel(obj:Object):void {
			hideAllLines();
			winAnimIndex++;
			if (winAnimIndex == obj.WinnerLines.length) {
				winAnimIndex = 0
				frameHolder.initIconFrameHolder(false);
				GameHolder.cont.machineHolder.stopIconsAnimation(true);
				resetMaskIcons();
				lineAnimationStarter(obj, false);
				lineWinStatus.hide();
				return;
			}
			//cont.shown = false;
			animateLine(obj);
		}
		
		private function showWinnerLine(num:int):void {
			//testLine = linesContainer.getChildByName("line" + String(num));
			//testLine.visible = true;
			
			/*try{
				//testLine = linesContainer.getChildByName("line" + String(num));
				//testLine.visible = true;
				//testButt = lineBtns.getChildByName("b" + String(num));
				//testButt.alpha = 1;
			}catch (e:Error) {
				
			}*/
		}
		
		//activate
		private function activateLines(num:Number):void {
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) {
				if (i < num) {
					testLine = linesContainer.getChildByName("line" + String(i + 1));
					testLine.visible = true;
					testButt = lineBtns.getChildByName("b" + String(i + 1));
					testButt.alpha = 1;
				} else {
					testLine = linesContainer.getChildByName("line" + String(i + 1));
					testLine.visible = false;
					testButt = lineBtns.getChildByName("b" + String(i + 1));
					testButt.alpha = 0.5;
				}
				
					//testLine.gotoAndStop(1);
			}
			this.shown = true;
		}
		
		//when line changed
		private function whenLineisChanged(e:GameEvents):void {
			killDelayedCalls();
			resetMaskIcons();
			activateLines(e.params.activted);
		}
		
		public function killDelayedCalls():void {
			TweenMax.killDelayedCallsTo(winnerLineStartAnDelay);
			TweenMax.killDelayedCallsTo(animateLinesContDel);
		}
		
		//shown
		public function get shown():Boolean {
			return _shown;
		}
		
		public function set shown(value:Boolean):void {
			if (value == true) {
				this.visible = true;
			} else {
				TweenMax.killDelayedCallsTo(showWildAnimation);
				TweenMax.killDelayedCallsTo(lineAnimationStarter);
				TweenMax.killDelayedCallsTo(winnerLineStartAnDelay);
				TweenMax.killDelayedCallsTo(animateLinesContDel);
				this.visible = false;
				hideAllLines();
				frameHolder.initIconFrameHolder();
				this.resetMaskIcons();
				lineWinStatus.hide();
			}
			_shown = value;
		}
		
		public function hideAllLines():void {
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) {
				testLine = linesContainer.getChildByName("line" + String(i + 1));
				testLine.visible = false;
				//testButt = lineBtns.getChildByName("b" + String(i + 1));
				//testButt.alpha = 0.5;
			}
		}
		
		
		
		public function checkWildTransofmedArr():void 
		{
			if (transformedAr != null && transformedAr.length != 0)
			{
				for (var i:int = 0; i < transformedAr.length; i++) 
				{
					TweenMax.killTweensOf(transformedAr[i]);
					resetAnimatedIc(transformedAr[i]);
				}
			}
		}
	
	}

}
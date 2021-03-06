package game.machine {
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Linear;
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
	import starling.textures.Texture;
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
		private var lineHelper:LineHelper;
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
			
			if (GameSettings.SYS_NUM == 0 && GameSettings.TOTAL_LINES == 27)
				lineNumAr = GameSettings.LINES_AR[3];
			else
				lineNumAr = GameSettings.LINES_AR[GameSettings.SYS_NUM];
			
				
			linesContainer = new Sprite();
			addChild(linesContainer);
			
			linesMask = new Sprite();
			//linesMask.x = -3;
			addChild(linesMask);
			linesMask.x += GameSettings.LINEMAST_OFFSET_X;
			linesMask.y += GameSettings.LINEMAST_OFFSET_Y;
			
			var quad:Quad;
			
			/*quad = new Quad(30, 420, Color.GRAY);
			quad.alpha = 1;
			quad.x = -quad.width;
			linesMask.addChild(quad);*/
			
			maskIconsAr = [];
			
			var qWidth:uint = GameSettings.ICONSFRAME_SIZE[GameSettings.SYS_NUM][0];
			var qHeight:uint = GameSettings.ICONSFRAME_SIZE[GameSettings.SYS_NUM][1];
			
			var lineLoop:uint = GameSettings.LINEMASK_LOOP[GameSettings.SYS_NUM];
			var maskStepper:uint = GameSettings.LINEMASK_STEPPER[GameSettings.SYS_NUM];
			var maskStepX:uint = GameSettings.LINEMASK_STEP_X_Y[GameSettings.SYS_NUM][0];
			var maskStepY:uint = GameSettings.LINEMASK_STEP_X_Y[GameSettings.SYS_NUM][1];
			
			var maskLineHelerpVLoop:uint = GameSettings.ICONSFRAME_VERT_HELPER_LOOP[GameSettings.SYS_NUM];
			var maskLineHelperVWidth:uint = GameSettings.ICONSFRAME_VERT_HELPER_SIZE[GameSettings.SYS_NUM][0];
			var maskLineHelperVHeight:uint = GameSettings.ICONSFRAME_VERT_HELPER_SIZE[GameSettings.SYS_NUM][1];
			var maskLineHelperVStepX:uint = GameSettings.ICONSFRAME_VERT_HELPER_STEP_X[GameSettings.SYS_NUM];
			var maskLineHelperVOffset:uint = GameSettings.ICONSFRAME_VERT_HELPER_OFFSET[GameSettings.SYS_NUM];
			
			
			var maskLineHelerpHLoop:uint = GameSettings.ICONSFRAME_HORIZ_HELPER_LOOP[GameSettings.SYS_NUM];
			var maskLineHelperHWidth:uint = GameSettings.ICONSFRAME_HORIZ_HELPER_SIZE[GameSettings.SYS_NUM][0];
			var maskLineHelperHHeight:uint = GameSettings.ICONSFRAME_HORIZ_HELPER_SIZE[GameSettings.SYS_NUM][1];
			var maskLineHelperHStepY:uint = GameSettings.ICONSFRAME_HORIZ_HELPER_STEP_Y[GameSettings.SYS_NUM];
			var maskLineHelperHOffset:uint = GameSettings.ICONSFRAME_HORIZ_HELPER_OFFSET[GameSettings.SYS_NUM];
			
			for (var j:int = 0; j < lineLoop; j++) {
				
				quad = new Quad(qWidth, qHeight, Color.RED);
				maskIconsAr.push(quad);
				quad.x = int(j % maskStepper * maskStepX);
				quad.y = int(j / maskStepper) * maskStepY;
			
				linesMask.addChild(quad);
				
			}
			
			/*quad = new Quad(15, 420, Color.GRAY);
			quad.x = linesMask.width - quad.width*2;
			linesMask.addChild(quad);*/
			
			for (j = 0; j < maskLineHelerpVLoop; j++) {
				
				quad = new Quad(maskLineHelperVWidth, maskLineHelperVHeight, Color.GREEN);
				
				quad.x = maskLineHelperVStepX*j+maskLineHelperVOffset;
				linesMask.addChild(quad);
				
			}
			
			for (j = 0; j < maskLineHelerpHLoop; j++) {
				
				quad = new Quad(maskLineHelperHWidth, maskLineHelperHHeight, Color.GREEN);
				quad.y = maskLineHelperHStepY * j + maskLineHelperHOffset;
				
				linesMask.addChild(quad);
				
			}
			
			linesMask.alpha = .5;
			linesContainer.mask = linesMask;
			
			var $textureName:String;
			//var $textureAtlas:TextureAtlas = Assets.getAtlas("lines", "linesXml");
			
			lineHelper = new LineHelper();
			lineHelper.x += 4;
			lineHelper.y += 4;
			linesContainer.addChild(lineHelper);
				
			
			
			//showWinnerLine(3);
			
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
			frameHolder.x += GameSettings.FRAMES_OFFSET_X;
			frameHolder.y += GameSettings.FRAMES_OFFSET_Y;
			
			
			addChild(frameHolder);
			addChild(linesMask)
			GameHolder.cont.footerHolder.addEventListener(GameEvents.LINE_CHANGED, whenLineisChanged);
			
			
			//frameHolder.setFrames2();
		
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
				//showWinnerLine(obj.WinnerLines[i][0] + 1);
			}
			
			if (/*animateLines && */GameHolder.cont.doubleHolder == null)
			{
				TweenMax.delayedCall(GameSettings.WINNER_LINE_START_AND_DELAY, winnerLineStartAnDelay, [obj]);
				TweenMax.delayedCall(GameSettings.ANIMATE_LINE_DELAY, animateLine, [obj]);
				//TweenMax.to(this, 0.05, {alpha:0, yoyo:true, repeat:-1, repeatDelay:0.9, ease:Linear.easeNone});
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
			//TweenMax.delayedCall(0.5, animateLine, obj);
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
			lineHelper._disposeLine();
			showWinnerLine(obj.WinnerLines[winAnimIndex][0]);
			
			var curLineIndAr:Array = frameHolder.calcCurLineIndexesAr(obj, winAnimIndex);
			frameHolder.setFrames(obj, winAnimIndex, curLineIndAr);
			this.setCurLineMaskIcons(obj, winAnimIndex, curLineIndAr);
			//GameHolder.cont.machineHolder.animateIcons(obj, winAnimIndex, curLineIndAr);
			
			//Root.soundManager.PlaySound("icon" + String(obj.WinnerLines[winAnimIndex][1] + 1));
			if (GameHolder.WILD_FREE_SPIN == true)
			{
				Root.soundManager.PlaySound("RegularWinSnd");
			}
			
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
			
			TweenMax.delayedCall(winAnimIndex == obj.WinnerLines.length - 1 ? 2 : GameHolder.WILD_FREE_SPIN == true ? 0.4 : 1, animateLinesContDel, [obj]);
		}
		
		public function animateLinesContDel(obj:Object):void {
			hideAllLines();
			winAnimIndex++;
			if (winAnimIndex == obj.WinnerLines.length) {
				winAnimIndex = 0
				frameHolder.initIconFrameHolder(true);
				GameHolder.cont.machineHolder.stopIconsAnimation(true);
				resetMaskIcons();
				//lineAnimationStarter(obj, false);
				lineWinStatus.hide();
				lineHelper._disposeAll();
				if (GameSettings.MULTIPLE_WINS){GameHolder.cont.removeMultipleWins};
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
			
			lineHelper._showLine(lineNumAr[num]);
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
			TweenMax.killDelayedCallsTo(animateLine);
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
				TweenMax.killDelayedCallsTo(animateLine);
				this.visible = false;
				hideAllLines();
				frameHolder.initIconFrameHolder();
				this.resetMaskIcons();
				lineWinStatus.hide();
				lineHelper._disposeAll();
				if(GameSettings.MULTIPLE_WINS){GameHolder.cont.removeMultipleWins()}
			}
			_shown = value;
		}
		
		public function hideAllLines():void {
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) {
				//testLine = linesContainer.getChildByName("line" + String(i + 1));
				//testLine.visible = false;
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
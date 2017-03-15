package game.machine 
{
	import caurina.transitions.AuxFunctions;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import com.utils.MovieclipTextureAdder;
	import com.utils.SpritePool;
	import com.utils.StaticGUI;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import game.GameHolder;
	import game.adjara.AdjaraSpins;
	import game.machine.Icon;
	import game.machine.IconsHolder;
	import game.machine.IconsHolderLine;
	import game.machine.Lines;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class Machine extends Sprite
	{
		private var totalIcons:int = 13;
		private var blurValue:int = 30;
		private var iMask:Quad;
		private var used:Array;
		public var iconsHolder:IconsHolder;
		public var startSpeed:Number = 30;
		private var friction:Number = 1;
		private var TEST_LINE:*;
		private var TestLineIconMc:*;
		private var spinSoundCount:int = 1;
		private var spinSoundInActionArr:Array = [7,8,7,8,7,6];
		private var soundDrobBoolean:Boolean = false;
		private var lastIconsArray:Array;
		private var draFristTime:Boolean;
		public var currentSpinObj:Object;
		public var maxSpeed:Number = 80;
		public static var xDist:Number;
		public static var Ydistance:Number;
		public var curSpeed:Number = startSpeed;
		
		private var stopVarArr:Array = [0,1,2]
		
		//public var bonusIndex:int;
		//public var scatterIndex:int;
		//public var wildIndex:int;
		//public var fistScatterIndex:int;
		//public var secondScatterIndex:int;
		
		public var isScrolling:Boolean;
		private var iconPool:SpritePool;
		private var lightFrame:MovieClip;
		private var thisvarShouldRemoveAfterTesting:int;
		private var machineServerSpinStarted:Boolean = false;
		private var temporaryTopIconsAr:Array = [];
		private var BlackWhiteFilter:ColorMatrixFilter;
		private var REEL_X_COUNT:int;
		private var REEL_Y_COUNT:int;
		private var staticReels:Array = [];
		private var scatterIconCount:int;
		public var canNowStopBol:Boolean = false;
		public var iconsDictionary:Dictionary;
		
		//public static var wildIconsAtlas:TextureAtlas;
		public static var allIconsAtlas:TextureAtlas;
		
		
		public function Machine() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			//wildIconsAtlas = Assets.getAtlas("allWildSheet", "allWildSheetXml");
			allIconsAtlas = Assets.getAtlas("allIconsImg", "allIconsXml");
			
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			BlackWhiteFilter = new ColorMatrixFilter(); 
			BlackWhiteFilter.adjustSaturation( -1);
			
			//initMachine();
		}
		
		public function updateIndexes(obj:Object):void{
			//bonusIndex = 999999999;
			//scatterIndex = 99999999;
			//wildIndex = obj.WildIndex;
			//fistScatterIndex = obj.FirstScatterIndex
			//secondScatterIndex = obj.SecondScatterIndex
		}
		
		public function updateWildIcons():void
		{
			for (var i:int = 0; i < lastIconsArray.length; i++) 
			{
				if (Machine.isWildIcon(lastIconsArray[i].ID))
				{
					if (lastIconsArray[i].iconAnimationMc != null) continue;
					//lastIconsArray[i].setIcon(wildIndex); // ??????????????????????????????
				}
			}
		}
		
		public function initMachine():void 
		{
			xDist = GameSettings.MASHINE_OPTIONS[GameSettings.SYS_NUM].xDist;
			Ydistance = GameSettings.MASHINE_OPTIONS[GameSettings.SYS_NUM].yDist;
			
			REEL_X_COUNT = GameSettings.REEL_TYPE[GameSettings.SYS_NUM][0];
			REEL_Y_COUNT = GameSettings.REEL_TYPE[GameSettings.SYS_NUM][1];
			
			isScrolling = false;
			
			
			var iconBg:Image = new Image(Assets.getTexture("slot_icons_bg"));
			iconBg.x = -53;
			iconBg.y = 23;
			addChild(iconBg);
			iconBg = null;
			
			
			
			
			iconPool = new SpritePool(Icon, 60);
			iconsHolder = new IconsHolder();
			iconsHolder.x = GameSettings.ICON_HOLDER_POS[GameSettings.SYS_NUM][0];//-34;
			iconsHolder.y = GameSettings.ICON_HOLDER_POS[GameSettings.SYS_NUM][1];//40;
			this.addChild(iconsHolder);
			
			var bg:Image = new Image(Assets.getTexture("machineBg"));
			bg.x = -133;
			bg.y = -43;
			addChild(bg);
			if (GameSettings.PREFERENCES.machine.machineBg != null)
			{
				bg.x += GameSettings.PREFERENCES.machine.machineBg.OFFSET_X;
				bg.y += GameSettings.PREFERENCES.machine.machineBg.OFFSET_Y;
			}
			bg = null;
			
			iMask = new Quad(775, 441);
			iMask.color = Color.RED;
			//iMask.alpha = .5;
			iMask.y = 25;
			iMask.x = -55;
			addChild(iMask);
			iconsHolder.mask = iMask;
			
			lastIconsArray = [];
			
			var i:int = 1;
			while (i <= REEL_X_COUNT)
			{
				
				this.iconsHolder["s" + i] = new IconsHolderLine();
				this.iconsHolder["s" + i].ID = i;
				this.iconsHolder["s" + i].x = int((i - 1) * (xDist));
				this.iconsHolder["s" + i].y = int(this.iconsHolder["s" + i].y);
				this.iconsHolder.addChild(this.iconsHolder["s" + i]);
				/*used = new Array(9);
				var k:int = 0;
				while (k < 9)
				{
					used[k] = 0;
					k = (k + 1);
				}*/
				var j:int = 1;
				while (j <= REEL_Y_COUNT)
				{
					/*do
					{
						var itm:int = int(Math.random() * 9);
					} while (used[itm])
					used[itm] = 1;*/
					this.iconsHolder["s" + i].map["i" + j] = iconPool.getSprite();
					this.iconsHolder["s" + i].map["i" + j].setIcon(((i - 1) * REEL_Y_COUNT + j - 1) % GameSettings.TOTAL_ICONS);
					//this.iconsHolder["s" + i].map["i" + j].setIcon(Math.floor(i-1));
					this.iconsHolder["s" + i].map["i" + j].y = (REEL_Y_COUNT - j) * Ydistance;
					this.iconsHolder["s" + i].addChild(this.iconsHolder["s" + i].map["i" + j]);
					lastIconsArray.push(this.iconsHolder["s" + i].map["i" + j]);
					j = (j + 1);
				}
				this.iconsHolder["s" + i].C = REEL_Y_COUNT;
				i = (i + 1);
			}
			
			
			//showLightsFrame(4);
			
		}
		
		public function setCustomReels(reelsArr:Array):void
		{
			lastIconsArray = [];
			var i:int = 1;
			while (i <= REEL_X_COUNT)
			{
				var j:int = 1;
				while (j <= REEL_Y_COUNT)
				{
					this.iconsHolder["s" + i].map["i" + j].setIcon(reelsArr[i - 1][REEL_Y_COUNT - j]);
					this.iconsHolder["s" + i].map["i" + j].KJ = i + "@" + (REEL_Y_COUNT - j);
					this.iconsHolder["s" + i].map["i" + j].positionInReel = (REEL_Y_COUNT - j);
					
					lastIconsArray.push(this.iconsHolder["s" + i].map["i" + j]);
					j = (j + 1);
				}
				i = (i + 1);
			}
		}
		
		public function getDictionaryIcon(nn:String):*
		{
			if (iconsDictionary[nn] != null)
			{
				return iconsDictionary[nn];
			}
		}
		
		
		
		
		public function startMachineSpin():void
		{
			thisvarShouldRemoveAfterTesting = 0;
			
			currentSpinObj = null;
			isScrolling = true;
			GameHolder.cont.lineButsHolder._isEnabled(false);
			canNowStopBol = false;
			var i:int;
			lastIconsArray = [];
			curSpeed = startSpeed;
			
			stopVarArr = StaticGUI.shuffleArray(stopVarArr);
			Root.soundManager.PlaySound("spinStart");
			Root.soundManager.loopdSound("spinLoop");
			
			i = 1;
			var count:int = 1;
			while (i <= REEL_X_COUNT)
			{
				if (staticReels.indexOf(i) != -1)
				{
					this.iconsHolder["s" + i].isStop = false;
					this.iconsHolder["s" + i].isStaticReel = true;
					i = i + 1;
					continue;
				}
				this.iconsHolder["s" + i].isStop = false;
				this.iconsHolder["s" + i].isStaticReel = false;
				TweenLite.delayedCall(0.06 * (count-1) + 0, startEnterScroll, [i]);
				i = (i + 1);
				count = count + 1;
			}
		}
		
		
		//----------------------------------------start scrolling------------------------------
		public function startSpin(obj:Object):void
		{
			if (AdjaraSpins.FreeSpinMode == true)
			{
				GameHolder.cont.machineHolder.startMachineSpin();
			}
			scatterIconCount = 0;
			machineServerSpinStarted = true;
			currentSpinObj = obj;
			if (GameHolder.cont.freeSpinsState == false)
			{
				Root.soundManager.stopSound();
			}
			TweenNano.delayedCall(0.06 * (4) + 0, setCanStopBool);
			var spinTime:Number;
			if (GameHolder.cont.freeSpinsState == true)
			{
				spinTime = 0.4;
			}
			else
			{
				spinTime = 0.5;
			}
			//stop
			TweenMax.delayedCall(spinTime, StopScroll, [obj]);
			
			spinSoundCount++;
			if (spinSoundCount > 8 && soundDrobBoolean == false)
			{
				soundDrobBoolean = true;
				spinSoundCount = 1;
			}
			else if(spinSoundCount > spinSoundInActionArr.length && soundDrobBoolean == true)
			{
				spinSoundCount = 1;
			}
		}
		
		
		private function setCanStopBool():void
		{
			canNowStopBol = true;
			//Tracer._log("canstopBool: " + canNowStopBol);
		}
		
		
		
		public function startEnterScroll(loci:int):void
		{
			this.iconsHolder["s" + loci].addEventListener(Event.ENTER_FRAME, Scroll);
		}
		
		
		//scroll
		private function Scroll(event:Event):void
		{
			if (curSpeed < maxSpeed)
				curSpeed += friction;
			else
				curSpeed = maxSpeed;
			
			var ssp:IconsHolderLine = event.currentTarget as IconsHolderLine;
			var TEST_ICON:*;
			
			
			ssp.y = ssp.y + curSpeed;
			if (ssp.y - (ssp.C - REEL_Y_COUNT) * Ydistance >= 0)
			{
				
				if (ssp.C > REEL_Y_COUNT + 1)
				{
					ssp.C = ssp.C + 1;
					ssp.map["i" + ssp.C] = ssp.map["i" + (ssp.C - (REEL_Y_COUNT + 1))]
					ssp.map["i" + ssp.C].setIcon(Math.floor(Math.random() * GameSettings.TOTAL_ICONS), true);
					ssp.map["i" + ssp.C].y = (REEL_Y_COUNT - ssp.C) * Ydistance;
				}
				else
				{
					ssp.C = ssp.C + 1;
					ssp.map["i" + ssp.C] = iconPool.getSprite();
					ssp.map["i" + ssp.C].setIcon(Math.floor(Math.random() * GameSettings.TOTAL_ICONS), true);
					ssp.map["i" + ssp.C].y = (REEL_Y_COUNT - ssp.C) * Ydistance;
					ssp.addChild(ssp.map["i" + ssp.C]);
				}
				
				
			}
			ssp = null;
			return;
		} 
		
		
		public function makeFastStop():void 
		{
			if (machineServerSpinStarted == false)
			{
				//Tracer._log("cant");
				setTimeout(makeFastStop, 20);
				return;
			}
			
			TweenMax.killDelayedCallsTo(StopScroll);
			StopScroll(null, true);
			Root.soundManager.stopSound();
		}
		
		
		//stop scroll
		public function StopScroll(obj:Object, fastStop:Boolean = false):void
		{
			//vaida gacheda
			if (obj == null)
			{
				obj = currentSpinObj;
			}
			if (fastStop == true)
			{
				if (canNowStopBol == false)
				{
					//Tracer._log("cant");
					setTimeout(StopScroll, 100, obj, fastStop);
					return;
				}
			}
			
			var l:int;
			draFristTime = false;
			
			if (fastStop)
			{
				TweenMax.killTweensOf(this);
				TweenMax.killDelayedCallsTo(startEnterScroll);
				TweenMax.killDelayedCallsTo(removeScrollAndAnimate);
				TweenMax.killDelayedCallsTo(showLightsFrame);
			}
			
			var bonPos:int = CheckForPossibleBonuses(obj, [9999999999]);
			if (bonPos == 0 || fastStop == true)
			{
				bonPos = REEL_X_COUNT
			}
			
			
			if (fastStop == false)
			{
				for (l = 1; l <= bonPos; l++)
				{
					TweenMax.delayedCall(l * 0.3, removeScrollAndAnimate, [l, obj, fastStop, false]);
				}
			}
			else
			{
				for (l = 1; l <= REEL_X_COUNT; l++)
				{
					TweenLite.delayedCall(0, removeScrollAndAnimate, [l, obj, fastStop, false]);
				}
			}
			
			
			//------
			if (bonPos < REEL_X_COUNT)
			{
				var delCount:Number = 1;
				for (var i:int = bonPos+1; i <= REEL_X_COUNT; i++) 
				{
					maxSpeed = 500;
					friction = 5;
					TweenLite.delayedCall(l * 0.3 + (delCount)*2, removeScrollAndAnimate, [i, obj, fastStop, bonPos]);
					TweenLite.delayedCall(l * 0.3 + (delCount-1)*2 + ((i == bonPos + 1) ? 0 : 0.3), showLightsFrame, [i]);
					
					delCount++;
				}
				
				TweenLite.delayedCall(REEL_X_COUNT-i+1, speedOnBonPos);
			}
		}
		
		private function speedOnBonPos():void
		{
			maxSpeed = 80;
			friction = 0.2;
		}
		
		public function showLightsFrame(line:int):void
		{
			//line = 5;
			if (lightFrame == null)
			{
				lightFrame = new MovieClip(Assets.getAtlas("lightFrame", "lightFrameXml").getTextures("light"), 40);
				lightFrame.scaleY = 1.02;
				//lightFrame.pivotX = int(lightFrame.width / 2);
				Starling.juggler.add(lightFrame);
				addChild(lightFrame);
				lightFrame.play();
			}
			
			lightFrame.x = (line - 1) * (Icon.iconWidth + 18) - 90;//((line - 1) * (Icon.iconWidth-17)) ;
			lightFrame.y = -50;
			Root.soundManager.PlaySound("riser");
			Root.soundManager.PlaySound("lightsStart");
		}
		
		
		public function hideLightsFrame():void
		{
			if (lightFrame != null)
			{
				StaticGUI.safeRemoveChild(lightFrame, true);
				lightFrame = null;
			}
		}
		
		
		
		//removeScrollAnimation by lines
		public function removeScrollAndAnimate(line:int, obj:Object, fastStop:Boolean = false, boostUp:Boolean = false):void
		{
			TEST_LINE = this.iconsHolder["s" + line];
			
			if (TEST_LINE.isStop == true)
				return
			else
				TEST_LINE.isStop = true;
			
			
			if (TEST_LINE.isStaticReel == true)
			{
				for (var i:int = 0; i < REEL_Y_COUNT; i++) 
				{
					lastIconsArray.push(TEST_LINE.map["i" + (TEST_LINE.C - i)]);
				}
				return;
				
			}
			
			if (line == REEL_X_COUNT)
			{
				if (fastStop == false)
					Root.soundManager.PlaySound("sponLoopEnd");
					
					
				Root.soundManager.stopLoopSound();
			}
				
			
			
				
			TEST_LINE.removeEventListener(Event.ENTER_FRAME, this.Scroll);
			var _loc_2:* = [5, 1, 6, 3, 34, 5, 2, 5, 1, 3, 5, 1, 53];
			var num:int = 0;
			TEST_LINE.map["i" + TEST_LINE.C].resetBlur();
			
			
			while (num < REEL_Y_COUNT + 1)
			{
				TestLineIconMc = TEST_LINE.C + 1;
				TEST_LINE.C = TestLineIconMc;
				TEST_LINE.map["i" + TEST_LINE.C] = iconPool.getSprite();
				TEST_LINE.map["i" + TEST_LINE.C].identifier = String(line) + String(REEL_Y_COUNT - num);
				TEST_LINE.map["i" + TEST_LINE.C].ID = obj.Reels[line-1][REEL_Y_COUNT - num - 1];
				
				
				
				if (isScatterIcon(obj.Reels[line-1][REEL_Y_COUNT - num - 1]) && fastStop == false)
				{
					scatterIconCount++;
					if (REEL_X_COUNT - line >= 3 - scatterIconCount)
					{
						TweenLite.delayedCall(line * 0.030, Root.soundManager.schedule, ["Star_0" + String(line), 0.5]);
					}
				}
				
				if (num != REEL_Y_COUNT)
				{
					TEST_LINE.map["i" + TEST_LINE.C].KJ = line + "@" + ((REEL_Y_COUNT-1)-num);
					TEST_LINE.map["i" + TEST_LINE.C].positionInReel = ((REEL_Y_COUNT-1)-num);
					TEST_LINE.map["i" + TEST_LINE.C].parentLine = line;
					//this.iconsHolder["s" + line].map["i" + this.iconsHolder["s" + line].C].setIcon(5);
					TEST_LINE.map["i" + TEST_LINE.C].setIcon(obj.Reels[line-1][REEL_Y_COUNT - num - 1]);
					lastIconsArray.push(TEST_LINE.map["i" + TEST_LINE.C]);
				}
				else
				{
					temporaryTopIconsAr.push(TEST_LINE.map["i" + TEST_LINE.C]);
					TEST_LINE.map["i" + TEST_LINE.C].setIcon(Math.floor(Math.random() * GameSettings.TOTAL_ICONS));
				}
				
				TEST_LINE.map["i" + TEST_LINE.C].y = (REEL_Y_COUNT - TEST_LINE.C) * Ydistance;
				TEST_LINE.addChild(TEST_LINE.map["i" + TEST_LINE.C]);
				num = num + 1;
				
				
			}
			
			if (TEST_LINE.map["i" + (TEST_LINE.C - REEL_Y_COUNT)] != null)
			{
				TEST_LINE.map["i" + (TEST_LINE.C - REEL_Y_COUNT)].resetBlur();
			}
			
			
			//TweenMax.to(this.iconsHolder["s" + line], 0.5, {y: (this.iconsHolder["s" + line].C - 3) * Ydistance, ease: Back.easeOut, onComplete:spinComplete, onCompleteParams:[this.iconsHolder["s" + line], line, obj]});
			Starling.juggler.tween(TEST_LINE, 0.3, {
				   transition: Transitions.EASE_OUT_BACK,
				   y:  (TEST_LINE.C - (REEL_Y_COUNT + 1) ) * Ydistance,
				   onComplete:spinComplete,
				   onCompleteArgs:[TEST_LINE, line, obj]
				});
				
				if (fastStop == false)
				{
					Root.soundManager.schedule('stopV' + stopVarArr[(line-1)%3], 1);
				}
				else
				{
					Root.soundManager.schedule('fastStop', 0.2);
				}
					
				TEST_LINE.C = TEST_LINE.C -1;
			
		}
		
		
		
		//spin complete
		private function spinComplete(mc:IconsHolderLine, lineNum:int, obj:Object):void
		{
			for (var i:int = 0; i < lastIconsArray.length; i++) 
			{
				if (isBonusIcon(lastIconsArray[i].ID))
				{
					//Tracer._log("asd");
					//lastIconsArray[i].parent.parent.addChild(lastIconsArray[i].parent);
				}
			}
			
			var _loc_2:* = REEL_Y_COUNT + 1;
			while (_loc_2 <= REEL_Y_COUNT * 2)
			{
				iconPool.returnSprite(mc.map["i" + (mc.C - _loc_2)]);
				StaticGUI.safeRemoveChild(mc.map["i" + (mc.C - _loc_2)]);
				_loc_2 = _loc_2 + 1;
			}
			
			
			
			if (lineNum == REEL_X_COUNT)
			{
				//Tracer._log(mc.name);
				//dispath event SPIN COMPLETE
				
				hideLightsFrame();
				if (obj.Bonus == true)
				{
					
				}
				
				isScrolling = false;
				
				machineServerSpinStarted = false;
				
				for (var j:int = 0; j < temporaryTopIconsAr.length; j++) 
				{
					iconPool.returnSprite(temporaryTopIconsAr[j]);
					StaticGUI.safeRemoveChild(temporaryTopIconsAr[j]);
				}
				temporaryTopIconsAr = [];
				
				dispatchEvent(new GameEvents(GameEvents.SPIN_COMPLETE, { socketObject:obj } ));
				
			}
			return;
		} // end function
		
		
		public function CheckForPossibleBonuses(obj:Object, indAr:Array):int
		{
			var sveti:int;
			var bonusCount:int;
			
			for (var j:int = 0; j < indAr.length; j++) 
			{
				bonusCount = 0;
				sveti = 0;
				for (var i:int = 0; i < obj.Reels.length; i++) 
				{
					if (obj.Reels[i].indexOf(indAr[j]) > -1)
					{
						sveti = i + 1;
						bonusCount ++;
						if (bonusCount == 2)
						{
							return sveti;
						}
					}
				}
			}
			
			return 0;
		}
		
		
		
		public function getIconByKJ(line:int, num:int):Icon
		{
			for (var i:int = 0; i < lastIconsArray.length; i++) 
			{
				if (lastIconsArray[i].KJ == (line + "@" + num))
				{
					return lastIconsArray[i];
				}
			}
			
			return null;
		}
		
		
		public function resetAnimation(includeBonus:Boolean = false):void
		{
			for (var i:int = 0; i < lastIconsArray.length; i++) 
			{
				if (lastIconsArray[i].isBonusLike == false || (includeBonus && lastIconsArray[i].isBonusLike == true))
				{
					Icon(lastIconsArray[i]).stopIcon();
				}
			}
		}
		
		
		
		public function animateIcons(obj:Object):void
		{
			var indexesAr:Array;
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			//stopIconsAnimation();
			
			//resetAnimation();
			
			var alreadyPlayinAr:Array = [];
			var _ic:Icon;
			var _ic2:Icon;
			var curLineIndAr:Array;
			
			
			for (var i:int = 0; i <  obj.WinnerLines.length; i++) 
			{
				curLineIndAr = GameHolder.cont.linesHolder.frameHolder.calcCurLineIndexesAr(obj, i);
				curLine = Lines.lineNumAr[obj.WinnerLines[i][0]];
			
			
				//indexebis ageba sadac iconebis
				for (var k:int = 0; k < obj.Reels.length; k++)
				{
					if (curLineIndAr.indexOf(k) == -1)
					{
						continue;
					}
					
					_ic = getIconByKJ(k + 1, curLine[k] - 1);
					
					if ((obj.Reels[k][curLine[k] - 1] == (obj.WinnerLines[i][1]) || isWildIcon(obj.Reels[k][curLine[k] - 1])) && alreadyPlayinAr.indexOf(_ic.KJ) == -1)
					{
						_ic.playIcon();
						_ic.filter = null;
						alreadyPlayinAr.push(_ic.KJ);
					}
					
					_ic = null;
				}
			}
			
			curLineIndAr = null;
			alreadyPlayinAr = null;
			
			if (GameSettings.PREFERENCES.machine.regularWinSoundEnabled)
			{
				Root.soundManager.schedule("RegularWinSnd", 1);
			}
		}
		
		
		
		public function stopIconsAnimation(finalStop:Boolean = false ):void
		{
			if (lastIconsArray == null)
			{
				return;
			}
			var indexesAr:Array;
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
				
			for (var i:int = 0; i < GameSettings.TOTAL_LINES; i++) 
			{
				
				
				resetAnimation(finalStop);
				
				curLine = Lines.lineNumAr[i];
				
				var testIcon:Icon;
				
				//indexebis ageba sadac iconebis
				for (var k:int = 0; k < REEL_X_COUNT; k++)
				{
					testIcon = Icon(getIconByKJ(k + 1, curLine[k] - 1))
					testIcon.stopIcon();
					if (!finalStop)
					{
						if (isWildIcon(testIcon.ID) && testIcon.iconAnimationMc != null)
						{
							continue;
						}
						//testIcon.filter = BlackWhiteFilter;
					}
					else
					{
						//testIcon.filter = null;
					}
				}
			}
		}
		
		
		
		
		
		public function setBonusLikeIconsAnimations(obj:Object, icoInd:int):void 
		{
			var indexesAr:Array;
			var num:int;
			var curLine:Array;
			var frameAr:Array = [];
			
			resetAnimation();
			
			indexesAr = []
			
			//indexebis ageba sadac iconebis
			
			
			for (var k:int = 0; k < obj.Reels.length; k++)
			{
				for (var j:int = 0; j < obj.Reels[k].length; j++) 
				{
					curLine = Lines.lineNumAr[k];
					if (obj.Reels[k][j] == (icoInd))
					{
						//Tracer._log("setBonusLikeIconsAnimations");
						//MovieClip(getIconByKJ(k + 1, j).getChildAt(0)).play();
						Icon(getIconByKJ(k + 1, j)).playIcon();
						getIconByKJ(k+1, j).isBonusLike = true;
					}
				}
			}
		}
		
		
		
		
		public static function isBonusLikeIcon(ind:int, includeWilds:Boolean = false):Boolean
		{
			var i:int;
			var ar:Array;
			
			if (includeWilds)
			{
				ar = GameSettings.WILDS_AR
				for (i = 0; i < ar.length; i++) 
				{
					if (ar[i][0] == ind) return true;
					
				}
			}
			
			ar = GameSettings.SCATTERS_AR
			for (i = 0; i < ar.length; i++) 
			{
				if (ar[i][0] == ind) return true;
			}
			
			ar = GameSettings.BONUSES_AR
			for (i = 0; i < ar.length; i++) 
			{
				if (ar[i][0] == ind) return true;
			}
			
			ar = null;
			return false;
		}
		
		
		public static function isWildIcon(ind:int):Boolean
		{
			var ar:Array;
			ar = GameSettings.WILDS_AR;
			
			for (var i:int = 0; i < ar.length; i++) 
			{
				if (ar[i][0] == ind) return true;
			}
			return false;
		}
		
		public static function wildSpecification(id:int):int
		{
			var wildAr:Array = GameSettings.WILDS_AR;
			
			for (var i:int = 0; i < wildAr.length; i++) 
			{
				if (wildAr[i][0] == id)
				{
					return wildAr[i][1];
				}
			}
			
			return -1;
		}
		
		
		
		
		
		
		public function setWildStaticReels(wildsAr:Array):void
		{
			for (var i:int = 0; i < wildsAr.length; i++) 
			{
				if (staticReels.indexOf(wildsAr[i][0] + 1) == -1)
				{
					staticReels.push(wildsAr[i][0] + 1);
				}
			}
		}
		
		public function clearStaticReels():void
		{
			staticReels = [];
		}
		
		
		
		
		
		public static function isScatterIcon(ind:int):Boolean
		{
			var ar:Array;
			ar = GameSettings.SCATTERS_AR;
			
			for (var i:int = 0; i < ar.length; i++) 
			{
				if (ar[i][0] == ind) return true;
			}
			return false;
		}
		
		public static function isBonusIcon(ind:int):Boolean
		{
			var ar:Array;
			ar = GameSettings.BONUSES_AR;
			
			for (var i:int = 0; i < ar.length; i++) 
			{
				if (ar[i][0] == ind) return true;
			}
			return false;
		}
		
		
		
		
		
		public function modifyWildIcons(wildsAr:Array, obj:Object, wildSpecNum:int):void 
		{
			var ic:Icon;
			
			var newWildInd:int = getModifierWild();
			if (newWildInd == -1)
			{
				return;
			}
			
			var delCount:Number = 0;
			
			for (var i:int = 0; i < wildsAr.length; i++) 
			{
				ic = getIconByKJ(wildsAr[i][0] + 1, wildsAr[i][1]);
				//ic.modifiedWildsAnimation(wildSpecNum);
				
				if (isWildIcon(ic.ID) == false)
				{
					if (GameHolder.WILD_FREE_SPIN)
					{
						TweenLite.delayedCall(delCount, ic.setIcon, [newWildInd]);
						TweenLite.delayedCall(delCount, Root.soundManager.PlaySound, ['stopLine2']);
						delCount += 0.5;
					}
					else
					{
						ic.setIcon(newWildInd);
					}
					ic.modifiedWildsAnimation(wildSpecNum);
					obj.Reels[wildsAr[i][0]][wildsAr[i][1]] = newWildInd;
				}
			}
			
			//trace(obj.Reels);
		}
		
		public function getWildSpinsDelCount(wildsAr:Array, obj:Object):Number 
		{
			var ic:Icon;
			
			var newWildInd:int = getModifierWild();
			if (newWildInd == -1)
			{
				return 0;
			}
			
			var delCount:Number = 0;
			
			for (var i:int = 0; i < wildsAr.length; i++) 
			{
				ic = getIconByKJ(wildsAr[i][0] + 1, wildsAr[i][1]);
				if (isWildIcon(ic.ID) == false)
				{
					if (GameHolder.WILD_FREE_SPIN)
					{
						delCount += 0.5;
					}
				}
			}
			
			return delCount;
		}
		
		
		private function getModifierWild():int 
		{
			var arr:Array = GameSettings.WILDS_AR;
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (arr[i][1] > 0)
				{
					return arr[i][0];
				}
			}
			
			return -1;
		}
		
		
		
		
	}

}
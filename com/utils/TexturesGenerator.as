package com.utils
{
	/**
	 * ...
	 * @author George Chitaladze
	 */
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TexturesGenerator
	{
		public function TexturesGenerator()
		{
			//ese unda gaketdes
			/*var starling_mc:MovieClip = new MovieClip(TexturesGenerator.texturesFromMovieClipTimeline(SomeFlashMC, 2), 24);
			var myJuggler:Juggler = new Juggler();
			myJuggler.add(starling_mc);
			addChild(starling_mc);*/
		}
		
		public static function texturesFromMovieClipTimeline(mc:MovieClip, startFrame:int = 1, endFrame:int = -1):Vector.<Texture>
		{
			var _textures:Vector.<Texture> = new Vector.<Texture>();
			var _bmpdata:BitmapData;
			var finalWidth:Number = 0;
			var finalHeight:Number = 0;
			var idx:uint;
			if (endFrame == -1)
			{
				endFrame = mc.totalFrames;
			}
			for (idx = startFrame; idx <= endFrame; idx++)
			{
				mc.gotoAndStop(idx);
				if (mc.width > finalWidth)
				{
					finalWidth = mc.width;
				}
				if (mc.height > finalHeight)
				{
					finalHeight = mc.height;
				}
			}
			for (idx = startFrame; idx <= endFrame; idx++)
			{
				mc.gotoAndStop(idx);
				_bmpdata = new BitmapData(finalWidth, finalHeight, true, 0);
				_bmpdata.draw(mc);
				_textures.push(Texture.fromBitmapData(_bmpdata));
				_bmpdata.dispose();
			}
			return (_textures);
		}
	}

}
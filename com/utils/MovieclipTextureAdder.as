package com.utils 
{
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class MovieclipTextureAdder 
	{
		
		public function MovieclipTextureAdder() 
		{
			
		}
		
		public static function addTextures(mov:MovieClip, textures:Vector.<Texture>):MovieClip
		{
			for (var i:int = 0; i < textures.length; i++) 
			{
				mov.addFrame(textures[i]);
			}
			
			return mov;
		}
		
		
		public static function createMultipleAtlasMov(arr:Array, fps:int = 12):MovieClip
		{
			var mov:MovieClip = new MovieClip(arr[0], fps);
			
			for (var k:int = 1; k < arr.length; k++) 
			{
				for (var i:int = 0; i < arr[k].length; i++) 
				{
					mov.addFrame(arr[k][i]);
				}
			}
			
			return mov;
		}
		
	}

}
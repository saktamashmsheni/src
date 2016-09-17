package game.machine 
{
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author George Chitaladze
	 */
	public class iconFrame extends MovieClip
	{
		
		public var isBonusLike:Boolean = false;
		
		public function iconFrame(textures:Vector.<Texture>, fps:Number = 12) 
		{
			super(textures, fps);
		}
		
	}

}
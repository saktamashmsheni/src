package {
	
	public class Tracer {
		//[Inline]
		public static function _log(... args):void {
			if (CONFIG::TRACE == true)
				trace(args);
		}
	}
}
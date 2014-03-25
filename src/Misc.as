package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Misc 
	{
		
		public function Misc() 
		{
			
		}
		
		public static function dot(ax:Number, ay:Number, bx:Number, by:Number):Number {
			return (ax * bx + ay * by)
		}
		
		public static function dot_product(ax:Number, ay:Number, bx:Number, by:Number):Number {
			var r:Number
			r = Math.sqrt(ax * ax + ay * ay)
			ax /= r
			ay /= r
			r = Math.sqrt(bx * bx + by * by)
			bx /= r
			by /= r
			return dot(ax, ay, bx, by)
			
		}
		
	}

}
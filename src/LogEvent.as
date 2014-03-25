package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class LogEvent extends GameEvent 
	{
		public var msg:String
		
		public function LogEvent(mesg:String) 
		{
			super();
			msg = mesg
		}
		
		public static function log(mesg:String):void {
			new LogEvent(mesg).send()
		}
		
	}

}
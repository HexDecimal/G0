package  
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class State extends Observer 
	{
		public function State() 
		{
			super();
			
		}
		
		public function step():void {
			
		}
		public function keydown(e:KeyboardEvent):void {
			trace(String.fromCharCode(e.charCode) ,e.keyCode)
		}
	}

}
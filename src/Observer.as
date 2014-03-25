package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Observer 
	{
		
		public function Observer() 
		{
			Main.observer.register(this)
		}
		
		public function notify(event:GameEvent):void {
			
		}
		
	}

}
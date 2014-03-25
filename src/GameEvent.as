package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class GameEvent 
	{
		
		public function GameEvent() 
		{
			
		}
		
		public function send():void {
			Main.observer.send(this)
		}
		
	}

}
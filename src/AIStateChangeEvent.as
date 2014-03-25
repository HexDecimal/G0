package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class AIStateChangeEvent extends GameEvent 
	{
		public var ai:AI
		public var oldState:String
		public function get state():String {
			return ai.mode
		}
		
		public function AIStateChangeEvent(ai:AI, oldState:String) 
		{
			super();
			this.ai = ai
			this.oldState = oldState
		}
		
	}

}
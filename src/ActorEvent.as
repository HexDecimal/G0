package  
{
	
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ActorEvent extends GameEvent
	{
		
		public var actor:Actor
		
		public function ActorEvent(actor:Actor) 
		{
			super();
			this.actor = actor
		}
		
	}

}
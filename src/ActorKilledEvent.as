package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ActorKilledEvent extends ActorEvent 
	{
		public var lethal:Boolean
		
		public function ActorKilledEvent(actor:Actor, lethal:Boolean) 
		{
			super(actor);
			this.lethal = lethal
		}
		
	}

}
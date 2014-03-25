package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ActorShotEvent extends ActorEvent 
	{
		public var damage:int
		
		public function ActorShotEvent(actor:Actor, damage:int) 
		{
			super(actor);
			this.damage = damage
		}
		
	}

}
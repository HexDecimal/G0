package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ItemPickupEvent extends GameEvent 
	{
		public var item:Item
		public var actor:Actor
		public function ItemPickupEvent(item:Item, actor:Actor) 
		{
			super();
			this.item = item
			this.actor = actor
		}
		
	}

}
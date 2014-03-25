package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class SpawnedItemEvent extends GameEvent 
	{
		protected var _item:Item
		public function SpawnedItemEvent(item:Item) 
		{
			super();
			_item = item
		}
		
		public function get item():Item 
		{
			return _item;
		}
		
	}

}
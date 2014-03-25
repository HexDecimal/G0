package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Item extends Observer 
	{
		
		protected var _x:int
		protected var _y:int
		
		
		protected var _fg:uint = 0xffffff
		protected var _char:int = '$'.charCodeAt()
		
		protected var _autoPickup:Boolean = true
		
		public function Item(x:int, y:int) 
		{
			super();
			_x = x
			_y = y
			new SpawnedItemEvent(this).send()
		}
		
		public function get fg():uint 
		{
			return _fg;
		}
		
		public function get char():int 
		{
			return _char;
		}
		
		public function get x():int 
		{
			return _x;
		}
		
		public function get y():int 
		{
			return _y;
		}
		
		protected function takeItem(event:ItemPickupEvent):void {
			
		}
		
		override public function notify(event:GameEvent):void 
		{
			var pickup:ItemPickupEvent = event as ItemPickupEvent
			if (pickup) {
				takeItem(pickup)
			}
		}
		
		public function get autoPickup():Boolean 
		{
			return _autoPickup;
		}
		
	}

}
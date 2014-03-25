package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ItemCorpse extends Item 
	{
		
		public function ItemCorpse(x:int, y:int) 
		{
			super(x, y);
			_fg = 0x888888
			_char = '%'.charCodeAt()
		}
		
		override protected function takeItem(event:ItemPickupEvent):void 
		{
			if(event.item === this){
				LogEvent.log('Body hidden')
			}
		}
		
	}

}
package  
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class KIAState extends State 
	{
		protected var _gameState:GameState
		
		public function KIAState(gameState:GameState) 
		{
			super();
			_gameState = gameState
			LogEvent.log('You have been KIA\nPress a key to retry')
			_gameState.draw(true)
		}
		
		override public function keydown(e:KeyboardEvent):void 
		{
			Main.state = new GameState()
		}
	}

}
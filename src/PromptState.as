package  
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class PromptState extends State 
	{
		
		protected var _gameState:GameState
		protected var _yes:Function
		protected var _no:Function
		
		public function PromptState(gameState:GameState, yes:Function, no:Function) 
		{
			super();
			_gameState = gameState
			_yes = yes
			_no = no
			_gameState.draw(true)
		}
		
		public static function prompt(yes:Function, no:Function=null):void {
			Main.state = new PromptState(GameState(Main.state), Boolean(yes)?yes:doNothing, Boolean(no)?no:doNothing)
		}
		
		private static function doNothing():void {
			LogEvent.log('OK')
			}
		
		override public function keydown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 89) {
				Main.state = _gameState
				if(Boolean(_yes)){_yes()}
			}else if(e.keyCode == 78) {
				Main.state = _gameState
				if(Boolean(_no)){_no()}
			}else{
				super.keydown(e);
			}
		}
		
	}

}
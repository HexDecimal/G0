package  
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class EndGameState extends State 
	{
		
		protected var _gameState:GameState
		
		public function EndGameState(gameState:GameState) 
		{
			super();
			_gameState = gameState
			Main.cData.clear()
			
			Main.cData.setColor(0xffffff, 0)
			Main.cData.drawStr(8, 2, 'YOU WIN')
			Main.cData.drawStr(4, 4, 'TIME ' + _gameState.map.ticks/2)
			Main.cData.drawStr(4, 5, 'INTEL ' + _gameState.intelCount * 100 + '/' + _gameState.intelTotal * 100)
			Main.cData.drawStr(4, 6, 'ENEMY KILLED ' + _gameState.enemyKilled)
			Main.cData.drawStr(4, 7, 'ENEMY KO ' + _gameState.enemyKO)
			Main.cData.drawStr(4, 12, 'PRESS A KEY TO PLAY AGAIN')
		}
		
		override public function keydown(e:KeyboardEvent):void 
		{
			Main.state = new GameState()
		}
		/*
		override public function step():void 
		{
			super.step();
			
		}*/
		
	}

}
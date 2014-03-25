package  
{
	import flash.geom.Point;
	import rogueutil.line.PreciseAngle;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class AnimationState extends State 
	{
		protected var _gameState:GameState
		protected var _frame:int = 0
		protected var _animation:Vector.<Point>
		protected var _char:int
		
		public function AnimationState(gameState:GameState, aX:int, aY:int, bX:int, bY:int, char:int) 
		{
			super();
			_gameState = gameState
			_char = char
			_animation = PreciseAngle.getPoints(aX, aY, bX, bY)
		}
		
		public static function animate(aX:int, aY:int, bX:int, bY:int, char:int):void {
			GameState(Main.state).animationQueue.push(new AnimationState(GameState(Main.state), aX, aY, bX, bY, char))
		}
		
		public static function animate_shot(aX:int, aY:int, bX:int, bY:int):void {
			var degrees:Number = Math.atan2(bY - aY, bX - aX) / Math.PI * 180
			var index:int = Math.round((degrees + 360) / 45) % 4
			animate(aX, aY, bX, bY, '-\\|/'.charCodeAt(index))
			
		}
		
		override public function step():void 
		{
			_gameState.draw(true)
			var x:int = _animation[_frame].x - _gameState.map.cameraX
			var y:int = _animation[_frame].y - _gameState.map.cameraY
			if(Main.cData.rect.contains(x, y)){
				Main.cData.setColor(0xffffff, 0x000000)
				Main.cData.drawChar(x, y, _char)
			}
			if (++_frame >= _animation.length) {
				Main.state = _gameState
			}
		}
		
	}

}
package  
{
	import rogueutil.console.ConsoleData;
	import rogueutil.fov.RestrictiveShadowcastFOV;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Enemy extends Actor 
	{
		
		public function Enemy() 
		{
			super();
			_health = 50
			_ai = new AI(this)
			_viewRadius = 5.5
			_fov = new RestrictiveShadowcastFOV()
			dir = 8 * Math.random()
		}
		override protected function getWalkSpeed():int 
		{
			var speed:int = super.getWalkSpeed()
			if (_ai.mode == 'chase') {
				return speed
			}else if (_ai.mode == 'investigate') {
				speed += 1
			}else {
				speed += 2
			}
			return speed
		}
		
		
		override public function act_melee(x:int, y:int):Boolean 
		{
			return false
		}
		
		private var _tmpConsole:ConsoleData
		
		override public function draw(console:ConsoleData):void 
		{
			super.draw(console);
			_tmpConsole = console
			_fov.callOnVisible(drawFOV)
			_tmpConsole = null
		}
		
		protected function drawFOV(x:int, y:int):void {
			var vX:int = x - map.cameraX
			var vY:int = y - map.cameraY
			if(!_tmpConsole.rect.contains(vX, vY)){return}
			if (!map.player.fov.isVisible(x, y) || (Misc.dot_product(_dirX, _dirY, x - _x, y - _y) < .5) || (_x == x && _y == y)) { return }
			if (!map.isTransparent(x, y, this)) {return}
			_tmpConsole.bgColor.setPixel(vX, vY, Math.pow(_x - x, 2) + Math.pow(_y - y, 2) < 4 * 4?0x333333:0x111111)
		}
	}

}
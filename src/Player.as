package  
{
	import flash.geom.Point;
	import rogueutil.fov.PermissiveShadowcastFOV;
	import rogueutil.line.PreciseAngle;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Player extends Actor 
	{
		
		protected var _aimTime:int
		
		public function getAim():Number {
			var actor:Actor = getNearestVisibleActor()
			if(actor == null){return 0}
			var dist:Number = getDistToActor(actor)
			return Math.max(0, 1 - Math.pow(.5, ((_aimTime)/2 + 16) / (dist+1/4)))
		}
		
		public function Player() 
		{
			super();
			_fov = new PermissiveShadowcastFOV()
			_isPlayer = true
			_x = 1
			_y = 1
		}
		
		override public function act_move(x:int, y:int):Boolean 
		{
			if (map.getTileAt(_x + x, _y + y) == MapLayer.TILE_WATER) {
				LogEvent.log('Water extraction?\n[Y/N]')
				PromptState.prompt(endgame)
			}
			var item:Item = map.getItemAt(_x + x, _y + y)
			if (item && item.autoPickup) {
				// auto pickup some items
				new ItemPickupEvent(item, this).send()
			}
			return super.act_move(x, y);
		}
		
		override public function act_shoot(actor:Actor):Boolean 
		{
			var aim:Number = getAim()
			_aimTime = 0
			_waitTimer = 2
			var i:int
			for each(var p:Point in PreciseAngle.getPoints(x, y, actor.x, actor.y)) {
				if (map.layer.coverValue(p.x, p.y, this) > Math.random()) {
					LogEvent.log('Miss')
					new ActorShotFired(this).send()
					AnimationState.animate_shot(x, y, p.x, p.y)
					return true
				}
			}
			AnimationState.animate_shot(x, y, actor.x, actor.y)
			if (aim <  Math.random()) {
				LogEvent.log('Miss')
				new ActorShotFired(this).send()
				return true
			}
			var damage:int = 20
			LogEvent.log('Hit')
			if (aim > Math.random()) {
				damage += 20
				LogEvent.log('Critcal')
				if (aim > Math.random()) {
					damage += 20
					LogEvent.log('Vital shot')
				}
			}
			new ActorShotEvent(actor, damage).send()
			new ActorShotFired(this).send()
			return true
		}
		
		private function endgame():void {
			Main.state = new EndGameState(GameState(Main.state))
		}
		
		override public function notify(event:GameEvent):void 
		{
			super.notify(event);
			if (event is TickEvent) {
				_aimTime++
			}
		}
		
		/*override protected function die():void 
		{
			//Main.state = new KIAState(GameState(Main.state))
		}*/
		
	}

}
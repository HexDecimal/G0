package  
{
	import rogueutil.line.Bresenham;
	import rogueutil.line.PreciseAngle;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class AI extends Observer
	{
		protected var _actor:Actor
		protected var dir:int = 0
		
		protected var _goalX:int
		protected var _goalY:int
		
		protected var _timer:int
		
		protected var _mode:String = 'patrol'
		
		public function get alive():Boolean {
			return _actor.alive
		}
		
		public function AI(actor:Actor) 
		{
			_actor = actor
		}
		
		protected function get map():Map {
			return _actor.map
		}
		
		protected function get player():Actor {
			return _actor.map.player
		}
		
		public function get mode():String 
		{
			return _mode;
		}
		
		public function set mode(value:String):void 
		{
			var  event:AIStateChangeEvent = new AIStateChangeEvent(this, mode)
			_mode = value;
			event.send()
		}
		
		public function think(actor:Actor):void {
			if(!alive){return}
			this[mode]()
		}
		
		protected function canSeePlayer():Boolean {
			var distSqu:Number = Math.pow(player.x - _actor.x, 2) + Math.pow(player.y - _actor.y, 2)
			if (distSqu > 16 * 16) { return false }
			if (Misc.dot_product(_actor.dirX, _actor.dirY, player.x - _actor.x, player.y - _actor.y) < .5) { return false }
			// use the players vision as a kind of hack
			if(!PreciseAngle.plot(_actor.x, _actor.y, player.x, player.y, player.canNotSee)){return false}
			return true
		}
		
		/*protected function changeMode(mode:String):void {
			var  event:AIStateChangeEvent = new AIStateChangeEvent(this, mode)
			this.mode = mode
			event.send()
		}*/
		
		protected function canSpotPlayer():Boolean {
			var distSqu:Number = Math.pow(player.x - _actor.x, 2) + Math.pow(player.y - _actor.y, 2)
			if (distSqu > 5.5*5.5) { return false }
			if(Misc.dot_product(_actor.dirX, _actor.dirY, player.x - _actor.x, player.y - _actor.y) < .5) { return false }
			if(!PreciseAngle.plot(_actor.x, _actor.y, player.x, player.y, player.canNotSee)){return false}
			return true
		}
		
		protected function patrol():void {
			//var x:int = [ -1, 0, 1, 0][dir]
			//var y:int = [0, -1, 0, 1][dir]
			var dirChange:int = Math.random() < .5?1:-1
			
			if (!_actor.act_move(_actor.dirX, _actor.dirY)) {
				_actor.dir += dirChange
			}
			if (Math.random() < 1 / 48) {
				_actor.dir += dirChange
			}
			_goalX = player.x
			_goalY = player.y
			if (canSpotPlayer()) {
				LogEvent.log('Spotted the enemy!')
				new AlertEvent().send()
				AnimationState.animate(_actor.x, _actor.y, player.x, player.y, '!'.charCodeAt())
				mode = 'chase'
			}
		}
		
		override public function notify(event:GameEvent):void 
		{
			if(!alive){return}
			var moveEvent:ActorMovedEvent = event as ActorMovedEvent
			if(moveEvent && moveEvent.actor.isPlayer && mode == 'patrol' && canSeePlayer() && player.stance != 0){
				_goalX = player.x
				_goalY = player.y
				if (canSpotPlayer()) {
					LogEvent.log('Spotted the enemy!')
					new AlertEvent().send()
					AnimationState.animate(_actor.x, _actor.y, player.x, player.y, '!'.charCodeAt())
					mode = 'chase'
				}else {
					LogEvent.log('I see something.')
					AnimationState.animate(_actor.x, _actor.y, player.x, player.y, '?'.charCodeAt())
					mode = 'investigate'
				}
				//trace('can see player')
			}
			if (event is AlertEvent) {
				if (_distToPlayer < 32 && mode != 'chase') {
					mode = 'investigate'
					_goalX = player.x
					_goalY = player.y
					if (canSeePlayer()) {
						AnimationState.animate(_actor.x, _actor.y, player.x, player.y, '!'.charCodeAt())
						mode = 'chase'
					}
				}
			}
			if (event is ActorShotFired && mode == 'patrol') {
				var actor:Actor = ActorShotFired(event).actor
				if (_actor.getDistToActor(actor) < 32) {
					if (map.alertTimer == 0) {
						LogEvent.log('Shots fired!')
					}
					_actor.faceTowards(actor.x, actor.y)
					if(canSeePlayer()){
						AnimationState.animate(_actor.x, _actor.y, actor.x, actor.y, '!'.charCodeAt())
					}
					new AlertEvent().send()
					
					_goalX = actor.x
					_goalY = actor.y
					mode = 'chase'
				}
			}
		}
		
		protected function get _distToPlayer():Number {
			return Math.sqrt(Math.pow(_actor.x - player.x, 2) + Math.pow(_actor.y - player.y, 2))
		}
		
		protected function goto(x:int, y:int):Boolean {
			var dirX:int = x - _actor.x
			var dirY:int = y - _actor.y
			if (dirX) { dirX = dirX > 0?1: -1 }
			if (dirY) { dirY = dirY > 0?1: -1 }
			if (!_actor.act_move(dirX, dirY) && dirX && dirY) {
				if(!(_actor.act_move(dirX, 0) || _actor.act_move(dirX, dirY))){return true}
			}
			return (_actor.x == x && _actor.y == y)
		}
		
		protected function goto_goal():Boolean {
			return goto(_goalX, _goalY)
		}
		
		protected function search():void {
			if (--_timer == 0) {
				if(_distToPlayer < 12){
					LogEvent.log('Returning to patrol.')
				}
				mode = 'patrol'
				return
			}
			if (Math.random() < .5) {
				_actor.act_move(_actor.dirX, _actor.dirY)
			}else {
				_actor.dir += Math.random() < .5?1:-1
			}
		}
		
		protected function investigate():void {
			if (canSeePlayer()) {
				_goalX = player.x
				_goalY = player.y
			}
			if (goto_goal()) {
				_timer = 3 + 4 * Math.random()
				mode = 'search'
			}
			if (canSpotPlayer()) {
				LogEvent.log('Spotted the enemy!')
				new AlertEvent().send()
				AnimationState.animate(_actor.x, _actor.y, player.x, player.y, '!'.charCodeAt())
				mode = 'chase'
			}
			
		}
		
		protected function chase():void {
			//var x:int = [ -1, 0, 1, 0][dir]
			//var y:int = [0, -1, 0, 1][dir]
			//if (!actor.act_move(x, y)) {
			//	dir = (dir+1)%4
			//}
			
			var distSqu:Number = Math.pow(player.x - _actor.x, 2) + Math.pow(player.y - _actor.y, 2)
			
			if (distSqu > 18 * 18 || !PreciseAngle.plot(_actor.x, _actor.y, player.x, player.y, player.canNotSee)) {
				LogEvent.log('I can\'t see him!')
				mode = 'investigate'
				return
			}
			new AlertEvent().send()
			_goalX = player.x
			_goalY = player.y
			_actor.faceTowards(_goalX, _goalY)
			if(Math.random() < .5 && distSqu > 6 * 6){
				/*var x:int = player.x - _actor.x
				var y:int = player.y - _actor.y
				if (x) { x = x > 0?1: -1 }
				if (y) { y = y > 0?1: -1 }*/
				goto_goal()
				return
			}
			_actor.act_shoot(player)
		}
		
	}

}
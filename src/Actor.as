package  
{
	import flash.geom.Point;
	import rogueutil.console.ConsoleData;
	import rogueutil.fov.FOV;
	import rogueutil.fov.PermissiveShadowcastFOV;
	import rogueutil.line.PreciseAngle;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Actor extends Observer
	{
		
		public var map:Map
		protected var _x:int
		protected var _y:int
		
		protected var _health:int = 100
		
		protected var _dirX:int = -1
		protected var _dirY:int
		
		protected var _fov:FOV
		protected var _ai:AI
		protected var _viewRadius:Number = 24.5
		
		protected var _stance:int = 1 // low, normal, run : 0, 1, 2
		
		protected var _waitTimer:int = 1
		protected var _isPlayer:Boolean = false
		
		protected var _walkSpeed:int = 3
		
		public function Actor()
		{
		}
		
		public function get dir():int {
			if (_dirX == -1 && _dirY == 0) {
				return 0
			}else if (_dirX == -1 && _dirY == -1) {
				return 1
			}else if (_dirX == 0 && _dirY == -1) {
				return 2
			}else if (_dirX == 1 && _dirY == -1) {
				return 3
			}else if (_dirX == 1 && _dirY == 0) {
				return 4
			}else if (_dirX == 1 && _dirY == -1) {
				return 5
			}else if (_dirX == 0 && _dirY == -1) {
				return 6
			}else{
				return 7
			}
		}
		
		public function set dir(dir:int):void {
			dir = (dir + 8) % 8
			_dirX = [-1, -1, 0, 1, 1, 1, 0, -1][dir]
			_dirY = [0, -1, -1, -1, 0, 1, 1, 1][dir]
		}
		
		public function step():Boolean {
			if (--_waitTimer <= 0) {
				if (!_ai) { return true }
				_ai.think(this)
			}
			return false
		}
		
		public function draw(console:ConsoleData):void {
			if (!map.player.fov.isVisible(_x, _y)) {return}
			var x:int = _x - map.cameraX
			var y:int = _y - map.cameraY
			if(console.rect.contains(x, y)){
				console.setColor(0xffffffff, 0x0)
				console.drawChar(x, y, '@'.charCodeAt())
			}
		}
		
		public function get waitTimer():int 
		{
			return _waitTimer;
		}
		
		public function get fov():FOV 
		{
			return _fov;
		}
		
		public function get x():int 
		{
			return _x;
		}
		
		public function get y():int 
		{
			return _y;
		}
		
		public function get ai():AI 
		{
			return _ai;
		}
		
		public function set ai(value:AI):void 
		{
			_ai = value;
		}
		
		
		public function set fov(value:FOV):void 
		{
			_fov = value;
		}
		
		public function get dirX():int 
		{
			return _dirX;
		}
		
		public function get dirY():int 
		{
			return _dirY;
		}
		
		public function get isPlayer():Boolean 
		{
			return _isPlayer;
		}
		
		public function get alive():Boolean {
			return Boolean(map)
		}
		
		public function get health():int 
		{
			return _health;
		}
		
		public function get stance():int 
		{
			return _stance;
		}
		
		
		public function setPos(x:int, y:int):void {
			_x = x
			_y = y
		}
		
		public function computeFOV():void {
			if(_fov){ // compute all fov from player pov
				_fov.computeFOV(_x, _y, _viewRadius, map.player.canSee)
			}
		}
		
		public function canSee(x:int, y:int):Boolean {
			return alive && map.isTransparent(x, y, this)
		}
		
		public function canNotSee(x:int, y:int, index:int = 0):Boolean {
			return !canSee(x, y)
		}
		
		public function act_wait():Boolean {
			_waitTimer = 2
			return true
		}
		
		public function getDistToActor(actor:Actor):Number {
			return Math.sqrt(Math.pow(_x - actor.x, 2) + Math.pow(_y - actor.y, 2))
		}
		
		
		public function faceTowards(x:int, y:int):void {
			var degrees:Number = Math.atan2(x - _x, y - _y) / Math.PI * -180
			dir = (Math.round((degrees + 360) / 45) - 2)
		}
		
		public function getNearestVisibleActor():Actor {
			var pqueue:PriorityQueue = new PriorityQueue(8)
			for each(var actor:Actor in map.actors) {
				if (actor === this) { continue }
				pqueue.push(getDistToActor(actor), actor)
			}
			while(pqueue.count){
				actor = pqueue.pop()
				if (_fov.isVisible(actor.x, actor.y)) {
					return actor
				}
			}
			return null
		}
		
		
		public function act_autofire():Boolean {
			var actor:Actor = getNearestVisibleActor()
			if (actor) {
				return act_shoot(actor)
			}
			return false
		}
		
		public function act_shoot(actor:Actor):Boolean {
			new ActorShotFired(this).send()
			_waitTimer = 2
			var i:int
			for each(var p:Point in PreciseAngle.getPoints(x, y, actor.x, actor.y)) {
				if (map.layer.coverValue(p.x, p.y, this) > Math.random()) {
					AnimationState.animate_shot(x, y, p.x, p.y)
					return true
				}
			}
			AnimationState.animate_shot(x, y, actor.x, actor.y)
			var chance:Number = getDistToActor(actor) / 26
			if(chance < Math.random()){
				new ActorShotEvent(actor, 20).send()
				LogEvent.log('You\'ve been hit!')
			}else {
				LogEvent.log('Missed!')
			}
			return true
		}
		
		public function act_crouch_toggle():Boolean {
			if(_stance!=0){_stance = 0}else{_stance = 1}
			computeFOV()
			new ActorStanceChange(this).send()
			_waitTimer = 2
			return true
		}
		
		public function act_move(x:int, y:int):Boolean {
			if (!map.isWalkable(_x + x, _y + y, this)) {
				return act_melee(x, y)
			}
			_dirX = x
			_dirY = y
			_waitTimer = getWalkSpeed()
			_x += x
			_y += y
			computeFOV()
			new ActorMovedEvent(this).send()
			return true
		}
		
		public function kill(lethal:Boolean = true):void {
			if(_isPlayer){return}// don't kill the player, the engine just can't handle it
			if (!alive) { trace('actor ' + this + ' was already dead');return }
			if (lethal) { map.addItem(new ItemCorpse(_x, _y)) }
			map.removeActor(this)
			new ActorKilledEvent(this, lethal).send()
		}
		
		public function act_melee(x:int, y:int):Boolean {
			var target:Actor = map.getActorAt(_x + x, _y + y)
			if (!target) { return false }
			LogEvent.log('Guard Knocked Out')
			_waitTimer = getWalkSpeed()
			target.kill(false)
			return true
		}
		
		protected function getWalkSpeed():int {
			// get speed from stance
			if (_stance == 0) {return 4}
			if (_stance == 1) { return 2}
			return 1
		}
		
		override public function notify(event:GameEvent):void 
		{
			var shotEvent:ActorShotEvent = event as ActorShotEvent
			if (shotEvent && shotEvent.actor === this) {
				_health -= shotEvent.damage
				if (_health <= 0) {kill(true)}
				return
			}
			var killedEvent:ActorKilledEvent = event as ActorKilledEvent
			/*if (killedEvent && killedEvent.actor == this) {
				//die()
			}*/
			
		}
	}

}
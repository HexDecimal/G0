package  
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class GameState extends State 
	{
		
		public function GameState() 
		{
			super();
			_map = new Map()
		}
		
		protected var _intelCount:int = 0
		protected var _logHighlight:int = 0
		public var enemyKilled:int
		public var enemyKO:int
		public var intelTotal:int
		
		private var _map:Map
		private var _log:Vector.<String> = new Vector.<String>
		public var animationQueue:Vector.<AnimationState> = new Vector.<AnimationState>
		
		private static const SIDEBAR_WIDTH:int = 24
		private static const STAT_HEIGHT:int = 5
		
		public function draw(force:Boolean=false):void {
			var rect:Rectangle = Main.cData.rect
			rect.x = _map.cameraX
			rect.y = _map.cameraY
			
			_map.drawConsole(Main.cData, Main.cData.width - SIDEBAR_WIDTH, Main.cData.height, force)
			Main.cData.setColor(0xffffff, 0)
			Main.cData.drawRect(new Rectangle(Main.cData.width - SIDEBAR_WIDTH, 0, SIDEBAR_WIDTH, Main.cData.height), 0x20)
			
			Main.cData.setColor(0x888888, 0)
			for (var y:int = Main.cData.height - 1; y >= 0; y--) {
				Main.cData.drawStr(Main.cData.width - SIDEBAR_WIDTH, y, '|')
			}
			y = STAT_HEIGHT
			for (var x:int = SIDEBAR_WIDTH - 2; x >= 0; x--) {
				Main.cData.drawStr(Main.cData.width - 1 - x, y, '-')
			}
			x = Main.cData.width - SIDEBAR_WIDTH + 1
			Main.cData.drawStr(x, 0, 'HEALTH ' + map.player.health)
			Main.cData.drawStr(x, 1, 'GPS ' + (map.player.x + 100) + ',' + (map.player.y + 100))
			Main.cData.drawStr(x, 2, ['PRONE', 'STANDING', 'RUNNING'][map.player.stance])
			Main.cData.drawStr(x, 3, 'INTEL ' + (_intelCount * 100))
			if (Player(map.player).getAim()) {
				Main.cData.drawStr(x, 4, 'AIM ' + int(Player(map.player).getAim() * 100) + '%')
			}else {
				Main.cData.drawStr(x, 4, 'AIM N/A')
			}
			
			for (y = Main.cData.height - 2 - STAT_HEIGHT; y >= 0; y--) {
				if (y <= _logHighlight) {Main.cData.setColor(0xffffff, 0)}
				if(y < _log.length){
					Main.cData.drawStr(Main.cData.width - SIDEBAR_WIDTH + 1,Main.cData.height - 1 - y, _log[y])
				}
			}
		}
		
		override public function step():void {
			if (animationQueue.length) {
				Main.state = animationQueue.shift()
				return
			}
			_map.step()
			draw()
		}
		
		public function appendLog(str:String):void {
			var lines:Array = str.toUpperCase().split('\n').reverse()
			var newline:String
			var x:int
			_logHighlight = 0
			while (lines.length) {
				newline = ''
				for each(var word:String in String(lines.pop()).split(' ')) {
					if (newline.length + word.length + 1 >= SIDEBAR_WIDTH) {
						_log.unshift(newline)
						newline = ''
						_logHighlight++
					}
					newline = newline + (newline.length?' ':'') + word
				}
				_log.unshift(newline)
			}
		}
		
		override public function notify(event:GameEvent):void 
		{
			//var killEvent:ActorKilledEvent = event as ActorKilledEvent
			//if(killEvent)
			if (event is LogEvent) {
				appendLog(LogEvent(event).msg)
			}
			if (event is ItemPickupEvent && ItemPickupEvent(event).item is ItemIntel) {
				_intelCount++
				LogEvent.log('Intel acquired:\n' + ItemIntel(ItemPickupEvent(event).item).desc)
			}
			if (event is SpawnedItemEvent && SpawnedItemEvent(event).item is ItemIntel) {
				intelTotal++
			}
			if (event is ActorKilledEvent) {
				if (ActorKilledEvent(event).lethal) {
					enemyKilled++
				}else {
					enemyKO++
				}
			}
		}
		
		
		override public function keydown(e:KeyboardEvent):void {
			if (_map.isModal()) {
				/*if () {
					keyDir(-1, 0)
				}else if () {
					keyDir(0, -1)
				}else if () {
					keyDir(1, 0)
				}else if () {
					keyDir(0, 1)*/
				if (e.keyCode == 97 || e.keyCode == 90) {
					keyDir(-1, 1)
				}else if (e.keyCode == 98 || e.keyCode == 40 || e.keyCode == 88) {
					keyDir(0, 1)
				}else if (e.keyCode == 99 || e.keyCode == 67) {
					keyDir(1, 1)
				}else if (e.keyCode == 100 || e.keyCode == 37 || e.keyCode ==  65) {
					keyDir(-1, 0)
				}else if (e.keyCode == 102 || e.keyCode == 39 || e.keyCode == 68) {
					keyDir(1, 0)
				}else if (e.keyCode == 103 || e.keyCode == 81) {
					keyDir(-1, -1)
				}else if (e.keyCode == 104 || e.keyCode == 38 || e.keyCode == 87) {
					keyDir(0, -1)
				}else if (e.keyCode == 105 || e.keyCode == 69) {
					keyDir(1, -1)
				}else if (e.keyCode == 101 || e.keyCode == 83) {
					_map.player.act_wait()
				}else if (e.keyCode == 86) { // V
					_map.player.act_crouch_toggle()
				}else if (e.keyCode == 70) { // V
					_map.player.act_autofire()
				}else {
					super.keydown(e)
				}
			}
		}
		
		protected function keyDir(x:int, y:int):void {
			_map.player.act_move(x, y)
		}
		
		public function get map():Map 
		{
			return _map;
		}
		
		public function get intelCount():int 
		{
			return _intelCount;
		}
		
		
	}

}
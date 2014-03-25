package  
{
	import flash.geom.Rectangle;
	import rogueutil.console.ConsoleBlendMode;
	import rogueutil.console.ConsoleData;
	import rogueutil.fov.RestrictiveShadowcastFOV;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Map extends Observer
	{
		
		private static const CELL_WIDTH:int = 24
		private static const CELL_HEIGHT:int = 24
		
		protected var _dirty:Boolean = true
		protected var _player:Actor
		protected var _alertTimer:int = 0
		protected var _ticks:int
		
		protected var _cameraX:int
		protected var _cameraY:int
		
		
		protected var _colums:int
		protected var _rows:int
		
		protected var _width:int
		protected var _height:int
		
		protected var _actors:Vector.<Actor> = new Vector.<Actor>
		protected var _items:Vector.<Item> = new Vector.<Item>
		protected var _cData:ConsoleData
		protected var _layers:Vector.<MapLayer> = new Vector.<MapLayer>
		
		public function Map()
		{
			super()
			_colums = 5
			_rows = 5
			_width = _colums * CELL_WIDTH
			_height = _rows * CELL_HEIGHT
			_cData = new ConsoleData(_width, _height)
			_layers.push(new MapLayer(this))
			_player = new Player()
			addActor(_player)
			generate()
			_player.computeFOV()
		}
		
		
		public function addActor(actor:Actor):void {
			_actors.push(actor)
			actor.map = this
		}
		
		public function addItem(item:Item):void {
			_items.push(item)
		}
		
		public function removeActor(actor:Actor):void {
			_actors.splice(_actors.indexOf(actor), 1)
			actor.map = null
		}
		
		protected function removeItem(item:Item):void {
			_items.splice(_items.indexOf(item), 1)
		}
		
		public function isModal():Boolean {
			return _player && !_player.waitTimer
		}
		
		protected function generate():void {
			generateWater()
			for (var y:int = 0; y < _rows-1; y++ ) {
				for (var x:int = 0; x < _colums; x++ ) {
					generateCell(x, y)
				}
			}
			y = _rows - 1
			for (x = 1;  x < _colums-1; x++) {
				generateDock(x, y)
			}
			var props:int = 4 * _rows * _colums
			while (props--) {
				x = Math.random() * _width
				y = Math.random() * _height
				generateProp(x,y)
				
			}
			
			var enemies:int = _rows * _colums * 3 / 4
			while (enemies) {
				x = Math.random() * _width
				y = Math.random() * _height
				if ((x + y > 24) && (getTileAt(x, y) == MapLayer.TILE_DIRT || getTileAt(x, y) == MapLayer.TILE_INDOOR)) {
					var actor:Actor = new Enemy()
					actor.setPos(x, y)
					//actor.ai = new AI()
					//actor.fov = null
					addActor(actor)
					enemies--
				}
			}
		}
		
		protected function areaClear(x:int, y:int, width:int, height:int):Boolean {
			for (var ty:int = y + height - 1; ty >= y; ty-- ) {
				for (var tx:int = x + width - 1; tx >= x ; tx-- ) {
					if(!inBounds(tx, ty) || _layers[0].getTile(tx, ty) != 0){return false}
				}
			}
			return true
		}
		
		protected function generateProp(x:int, y:int):void {
			var width:int = 1 + Math.random() * 2
			var height:int = 1 + Math.random() * 2
			var tile:int = Math.random()<.5?1:3
			if (areaClear(x - 1, y - 1, width + 2, height + 2)) {
				for (var ty:int = y + height - 1; ty >= y; ty-- ) {
					for (var tx:int = x + width - 1; tx >= x; tx-- ) {
						_layers[0].setTile(tx, ty, tile)
					}
				}
			}
		}
		
		protected function generateDock(x:int, y:int):void {
			x *= CELL_WIDTH
			y *= CELL_HEIGHT
			var height:int = CELL_HEIGHT - 2 - 4 * Math.random()
			var width:int = CELL_WIDTH / 4 + (CELL_WIDTH / 4) * Math.random()
			
			x += (CELL_WIDTH - width) / 2
			
			for (var ty:int = y + height - 1; ty >= y; ty-- ) {
				for (var tx:int = x + width -1; tx >= x ; tx-- ) {
					_layers[0].setTile(tx, ty, MapLayer.TILE_INDOOR)
				}
			}
		}
		
		protected function populateStructure(x:int, y:int, width:int, height:int):void {
			var items:int
			var placeX:int
			var placeY:int
			
			if (Math.random() < .85) {
				items = 1 + 3 * Math.random()
				while (items--) {
					placeX = x + width * Math.random()
					placeY = y + height * Math.random()
					if(getItemAt(placeX, placeY)){continue}
					addItem(new ItemIntel(placeX, placeY))
				}
			}
			if (Math.random() < .5) {
				items = 4 + 8 * Math.random()
				while (items--) {
					_layers[0].setTile(x + width * Math.random(), y + height * Math.random(), MapLayer.TILE_COVER)
				}
			}
		}
		
		protected function generateStructure(x:int, y:int, width:int, height:int):void {
			var endX:int = x + width - 1
			var endY:int = y + height - 1
			
			for (var ty:int=y; ty <= endY; ty++ ) {
				for (var tx:int = x; tx <= endX; tx++ ) {
					if ((tx == x || ty == y || tx == endX || ty == endY)) {
						_layers[0].setTile(tx, ty, 1)
					}else {
						_layers[0].setTile(tx, ty, 2)
					}
				}
			}
			
			var doors:int = 2
			while (doors--) {
				var doorX:int = x
				var doorY:int = y
			
				if (Math.random() < .5) {
					doorX += 1 + Math.random() * (width - 2)
				}else {
					doorY += 1 + Math.random() * (height - 2)
				}
				if (Math.random() < .5) {
					if (doorX != x) {
						doorY = endY
					}else {
						doorX = endX
					}
				}
				_layers[0].setTile(doorX, doorY, 2) // doorway
			}
			populateStructure(x+1, y+1, width-2, height-2)
			
		}
		
		protected function generateWater():void {
			var minY:int = _height - CELL_HEIGHT
			var y:int = _height - CELL_HEIGHT * 3 / 4
			for (var x:int = _width - 1; x >= 0; x-- ) {
				 y = Math.max(minY, Math.min(y -1 + int(Math.random() * 3), _height - CELL_HEIGHT / 2))
				for (var ty:int = y; ty < _height; ty++ ) {
					_layers[0].setTile(x, ty, MapLayer.TILE_WATER)
				}
			}
		}
		
		protected function generateCell(x:int, y:int):void {
			x *= CELL_WIDTH
			y *= CELL_HEIGHT
			var endX:int = x + CELL_WIDTH
			var endY:int = y + CELL_HEIGHT
			
			var structWidth:int = 5 + Math.random() * (CELL_WIDTH - 12)
			var structHeight:int = 5 + Math.random() * (CELL_HEIGHT - 12)
			generateStructure(int(x + (CELL_WIDTH - structWidth) / 2),
			                  int(y + (CELL_HEIGHT - structHeight) / 2), structWidth, structHeight)
			
			/*var rect:Rectangle = new Rectangle(int(x + (CELL_WIDTH - structWidth) / 2), int(y + (CELL_HEIGHT - structHeight) / 2),
			                                   structWidth, structHeight)
			for (var ty:int=y; ty < endY; ty++ ) {
				for (var tx:int = x; tx < endX; tx++ ) {
					if(rect.contains(tx,ty) && (tx == rect.left || ty == rect.top || tx == rect.right-1 || ty == rect.bottom-1)){
						_layers[0].setTile(tx, ty, 1)
					}else {
						_layers[0].setTile(tx, ty, 0)
					}
				}
			}*/
		}
		
		public function step():void {
			if (isModal()) {
				if (player.health <= 0) {
					//Main.state = new KIAState(GameState(Main.state))
					LogEvent.log('You have been KIA\nTry again?\n[Y/N]')
					PromptState.prompt(restart, quitToDos)
				}
				return
			}
			for each(var actor:Actor in _actors.concat()) {
				if (actor.map && actor.step()) {
					_player = actor
				}
			}
			new TickEvent().send()
			_ticks++
			if (_alertTimer) {
				if (--_alertTimer == 0) {
					new AlertTimeoutEvent().send()
				}
			}
		}
		
		private function restart():void {
			Main.state = new GameState()
		}
		
		private function quitToDos():void {
			Main.state = new DosState()
		}
		
		public function getTileAt(x:int, y:int):int {
			return _layers[0].getTile(x, y)
		}
		
		public function isWalkable(x:int, y:int, actor:Actor):Boolean {
			if (!inBounds(x, y)) { return false }
			return (!getActorAt(x, y) && _layers[0].isWalkable(x, y))
		}
		
		public function isTransparent(x:int, y:int, actor:Actor):Boolean {
			return inBounds(x, y) && _layers[0].isTransparent(x, y, actor)
		}
		
		public function drawConsole(console:ConsoleData, width:int, height:int, force:Boolean=false):ConsoleData {
			if (!(_dirty || force)) { return _cData }
			_dirty = false
			
			for (var y:int = 0; y < height; y++ ){
				for (var x:int = 0; x < width; x++ ) {
					var fg:uint = 0x888888
					var bg:uint = 0
					if (!_player.fov.isVisible(x + _cameraX,y + _cameraY)) {
						//bg = ConsoleBlendMode.BlendAlpha(bg, 0x88888888)
						fg = 0
					}
					console.setColor(fg, 0)
					console.drawChar(x, y, _layers[0].getChar(x + _cameraX,y + _cameraY))
				}
			}
			for each(var item:Item in _items) {
				if (!player.fov.isVisible(item.x, item.y)) {continue}
				var ix:int = item.x - cameraX
				var iy:int = item.y - cameraY
				if(!console.rect.contains(ix, iy)){continue}
				console.setColor(item.fg, 0x0)
				console.drawChar(ix, iy, item.char)
			}
			for each(var actor:Actor in _actors) {
				actor.draw(console)
			}
			return _cData
			
		}
		
		public function getItemAt(x:int, y:int):Item {
			for each(var item:Item in _items) {
				if (item.x == x && item.y == y ) { return item }
			}
			return null
		}
		
		public function getActorAt(x:int, y:int):Actor {
			for each(var actor:Actor in _actors) {
				if (actor.x == x && actor.y == y ) { return actor }
			}
			return null
		}
		
		override public function notify(event:GameEvent):void 
		{
			var moveEvent:ActorMovedEvent = event as ActorMovedEvent
			if (moveEvent) {
				_dirty = true
				if(moveEvent.actor == _player){
					_cameraX = moveEvent.actor.x - (Main.cData.width - 20) / 2
					_cameraY = moveEvent.actor.y - Main.cData.height / 2
					_cameraX = Math.max(0, Math.min(_cameraX, _width - Main.cData.width + 20))
					_cameraY = Math.max(0, Math.min(_cameraY, _height - Main.cData.height))
				}
				return
			}
			if (event is ActorKilledEvent || event is ActorStanceChange) {
				_dirty = true
				return
			}
			if (event is ItemPickupEvent) {
				removeItem(ItemPickupEvent(event).item)
				return
			}
		}
		
		public function inBounds(x:int, y:int):Boolean {
			return(0 <= x && 0 <= y && x < _width && y < _height)
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function get player():Actor 
		{
			return _player;
		}
		
		public function get cameraX():int 
		{
			return _cameraX;
		}
		
		public function get cameraY():int 
		{
			return _cameraY;
		}
		
		public function get ticks():int 
		{
			return _ticks;
		}
		
		public function get time():int {
			var min:int = _ticks % 60
			var hour:int = _ticks / 60
			return hour * 100 + min
		}
		
		public function get layer():MapLayer
		{
			return _layers[0];
		}
		
		public function get actors():Vector.<Actor> 
		{
			return _actors;
		}
		
		public function get alertTimer():int 
		{
			return _alertTimer;
		}
		
	}

}
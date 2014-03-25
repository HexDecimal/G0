package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class MapLayer extends Observer 
	{
		private static const TRANSPARENT_BIT:int = 1 << 31
		private static const WALKABLE_BIT:int = 1 << 30
		private static const COVER_BIT:int = 1 << 29
		private static const TILE_BITS:int = 0x000f
		
		public static const TILE_DIRT:int = 0
		public static const TILE_WALL:int = 1
		public static const TILE_INDOOR:int = 2
		public static const TILE_COVER:int = 3
		public static const TILE_WATER:int = 4
		
		
		protected var _width:int
		protected var _height:int
		public var _tiles:Vector.<int>
		
		public function MapLayer(master:Map) 
		{
			super();
			_width = master.width
			_height = master.height
			
			_tiles = new Vector.<int>(_length)
			const defaultTile:int = TRANSPARENT_BIT | WALKABLE_BIT
			for (var i:int = _length - 1; i >= 0; i-- ) {
				_tiles[i] = defaultTile
				//_tiles[i] = int(Math.random() * 0xffffffff)
			}
		}
		
		
		public function getChar(x:int, y:int):int {
			var tile:int = _tiles[index(x, y)] & TILE_BITS
			if (tile == 0) {
				return ','.charCodeAt()
			}
			if (tile == 1) {
				return '#'.charCodeAt()
			}
			if (tile == 2) {
				return '.'.charCodeAt()
			}
			if (tile == 3) {
				return 0x2584 // half block
			}
			if (tile == 4) {
				return '~'.charCodeAt()
			}
			return 0x20//getTile(x, y)
		}
		
		public function getTile(x:int, y:int):int {
			return _tiles[index(x, y)] & TILE_BITS
		}
		
		public function isWalkable(x:int, y:int):Boolean {
			return Boolean(_tiles[index(x, y)] & WALKABLE_BIT)
		}
		
		public function coverValue(x:int, y:int, actor:Actor):Number {
			var tile:int = _tiles[index(x, y)]
			if(tile & COVER_BIT){
				var dist:Number = Math.sqrt(Math.pow(x - actor.x, 2) + Math.pow(y - actor.y, 2))
				if (dist < 2) {
					return 0
				}
				return 1 - Math.pow(.5, dist / 4)
			}else if ((tile & TRANSPARENT_BIT)) {
				return 0
			}else {
				return 0 // ignore wall, if enemy can be seen that's good enough
			}
		}
		
		public function isTransparent(x:int, y:int, actor:Actor):Boolean {
			if ((_tiles[index(x, y)] & COVER_BIT) && actor.stance == 0) {return false}
			return Boolean(_tiles[index(x, y)] & TRANSPARENT_BIT)
			/*var tile:int = _tiles[index(x, y)]
			if (tile == 1) {return false}
			if(tile==3&&Math.max(Math.abs(actor.x - x), Math.abs(actor.y - y))>2){return false}
			return true
			//return false*/
		}
		
		public function setTile(x:int, y:int, tile:int):void {
			if (tile == 0) {
				tile |= WALKABLE_BIT | TRANSPARENT_BIT
			}else if (tile == 1) {
				tile |= 0
			}else if (tile == 2) {
				tile |= WALKABLE_BIT | TRANSPARENT_BIT
			}else if (tile == 3) {
				tile |= WALKABLE_BIT | TRANSPARENT_BIT | COVER_BIT
			}else if (tile == 4) {
				tile |= TRANSPARENT_BIT
			}
			_tiles[index(x,y)] = tile
		}
		
		public function getBG(x:int, y:int):uint {
			return 0
			var tile:int = _tiles[index(x, y)]
			if (tile & 1) {
				return 0x222222
			}
			return 0x22ff22
		}
		
		protected function index(x:int, y:int):int {
			return y * _width + x
		}
		
		protected function get _length():int {
			return _width * _height
		}
		
		
	}

}
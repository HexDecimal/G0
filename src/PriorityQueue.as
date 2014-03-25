package  
{
	/**
	 * ...
	 * @author 
	 */
	public class PriorityQueue 
	{
		private var _count:int = 0
		private var _heap:Vector.<PQueueItem>
		
		/**
		 * Min priority queue
		 * @param	size 
		 * Starting size of the heap, this object does not have a max size
		 */
		public function PriorityQueue(size:int=0)
		{
			_heap = new Vector.<PQueueItem>(size)
		}
		
		/**
		 * Insert an item into the priority queue
		 */
		public function push(priority:int, value:*):Boolean {
			if (_heap.length == _count) { _heap.length++ }
			_heap[bubble_up(_count++, priority)] = new PQueueItem(priority, value)
			return true // always successful
		}
		
		/**
		 * Return the lowest priority item from this heap
		 */
		public function pop():* {
			if(_count==0){throw new Error('Heap is empty')} // rather bad case, just throw an error
			var value:* = _heap[0].value
			_count--
			if (_count) {
				_heap[bubble_down(0, _heap[_count].priority)] = _heap[_count]
				_heap[_count] = null
			}else{
				_heap[0] = null
			}
			return value
		}
		
		/**
		 * Return an item from the heap while pushing another
		 * This is faster when done in 1 step
		 */
		public function pushpop(priority:int, value:*):*{
			if(_count==0){throw new Error('Heap is empty')} // rather bad case, just throw an error
			var pqitem:PQueueItem = _heap[0]
			var value:* = pqitem.value
			
			// reuse popped item
			pqitem.priority = priority
			pqitem.value = value
			_heap[bubble_down(0, priority)] = pqitem
			return value
		}
		
		/**
		 * Look for an ideal place to put an item of this priority, shifting down items during the search
		 */
		private function bubble_up(index:int, priority:int):int {
			if (index == 0) { return 0 } // at root
			var iParent:int = indexParent(index)
			if (priority >= _heap[iParent].priority) { return index }
			_heap[index] = _heap[iParent] // shift parent down
			return bubble_up(iParent, priority)
		}
		
		/**
		 * Look for an ideal place to put an item of this priority, shifting up items during the search
		 */
		private function bubble_down(index:int, priority:int):int {
			var iChild:int = indexChildMin(index)
			// -1: no children
			// bubble down on equals to try and preserve order
			if ((iChild == -1) || (priority < _heap[iChild].priority)) { return index }
			_heap[index] = _heap[iChild] // shift min child up
			return bubble_down(iChild, priority)
		}
		
		private function indexChildMin(index:int):int {
			// index of left and right child
			var iLeft:int = index * 2 + 1
			var iRight:int = iLeft + 1
			if (iLeft >= _count) { return -1 } // no children for this index
			if (iRight >= _count) { return iLeft } // only left child
			// return index of smallest child, prefer right of heap
			return (_heap[iLeft].priority < _heap[iRight].priority)? iLeft : iRight
		}
		
		private function indexParent(index:int):int {
			return int((index - 1) / 2)
		}
		
		/**
		 * The current number of items on the queue
		 */
		public function get count():int 
		{
			return _count;
		}
		
	}

}

class PQueueItem {
	public var priority:int
	public var value:*
	
	public function PQueueItem(priority:int, value:*) {
		this.priority = priority
		this.value = value
	}
}
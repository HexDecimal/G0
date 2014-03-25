package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class Subject 
	{
		
		protected var _observers:Dictionary = new Dictionary(true)
		
		public function Subject() 
		{
			
		}
		
		public function send(event:GameEvent):void {
			for (var i:Object in _observers) {
				var observer:Observer = Observer(i)
				observer.notify(event)
			}
			/*for each(var observer:Observer in _observers) {
				observer.notify(event)
			}*/
		}
		
		public function register(observer:Observer):void {
			_observers[observer] = true
		}
		
	}

}
package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import net.hires.debug.Stats;
	import rogueutil.console.ConsoleData;
	import rogueutil.console.ConsoleFontBDF;
	import rogueutil.console.ConsoleRender;

	/**
	 * ...
	 * @author Kyle Stewart
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public static const observer:Subject = new Subject()
		public static var state:State
		private var _keyEvents:Vector.<KeyboardEvent>
		public static var cData:ConsoleData

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_RIGHT
			stage.frameRate = 60
			
			addEventListener(Event.EXIT_FRAME, step)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keydown)
			
			var font:ConsoleFontBDF = new ConsoleFontBDF(new Assets.font())
			
			cData = new ConsoleData(800 / font.tileWidth, 600 / font.tileHeight)
			
			state = new GameState()
			
			addChild(new ConsoleRender(cData, font))
			if (CONFIG::debug) {
				var stats:Stats = new Stats()
				stats.alpha = .5
				addChild(stats)
			}
		}
		
		private function keydown(e:KeyboardEvent):void {
			state.keydown(e)
		}
		
		private function step(e:Event):void {
			state.step()
		}

	}

}
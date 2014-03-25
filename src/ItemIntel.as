package  
{
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class ItemIntel extends Item 
	{
		protected static const intelList:Vector.<String> = Vector.<String>(['you can go prone with "V" to move in front of guards',
																			'evade guards by breaking line of sight',
																			'leave the camp via the water at the south docks',
																			'go prone with "V" to hide behind low cover',
																			'move diagonally with Q E Z C',
																			'press "F" to shoot at the nearest enemy',
																			'high aim also increases chance to critical',
																			'You can KO enemies by walking into them',
																			'Compromised NSA Backdoors',
																			'active field agents',
																			'Special OPS',
																			'Secret Documents',
																			'Helicopter identification',
																			'Tank identification',
																			'government secrets',
																			'standard interrogation techniques',
																			'enhanced interrogation techniques',
																			'weapons manuals',
																			'mech piloting manual',
																			'ICBM launch codes',
																			'weapons supplier',
																			'government wiretaps',
																			'Military budget',
																			'troop morale',
																			'list of personnel',
																			'military intelligence',
																			'military analysis',
																			'military capability',
																			'local resistance movements',
																			'military intelligence representatives',
																			'military doctrine',
																			'military logistics systems',
																			'Tank schematics',
																			'Mech schematics',
																			'book',
																			'A CD case',
																			'Dota 2 black market',
																			'Cardboard box identification guide',
																			'Military Conspiracies for Dummies',
																			'Embarrassing Microfilms',
																			'half life 3 release date',
																			'Volcano Island Hideout',
		                                                                    'effects of glowing mushrooms on batteries',
																			'<put intel here Kyle>',
																			'Waldo\'s current location',
																			'carmen sandiego\'s current location',
																			//'how not to program\nPut important global variables in individual state machines',
																			//'how not to program\n',
																			'When you see an enemy turn into a corpse before the bullet hits them, just be glad it works at all.',
																			'the game',
																			'witty Intel description that breaks the 4th wall',
																			'100 points!',
																			'You got to admit, these intels are just getting more awesome',
																			'Uh oh, we\'re nearing the end ot the intels'])
		protected static var intelPool:Vector.<String> = new Vector.<String>
		protected static var intelWindowSize:int = 10
		
		//protected var _desc:String = 'Test'
		
		public function ItemIntel(x:int, y:int) 
		{
			super(x, y);
			//init_intel()
		}
		
		protected function init_intel():void {
			//if (intelPool.length == 0) { intelPool = intelList.concat() }
			//_desc = intelPool.splice(intelPool.length * Math.random(), 1)[0]
		}
		
		public function get desc():String 
		{
			if (intelPool.length == 0) { intelPool = intelList.concat() }
			return intelPool.splice(Math.min(intelPool.length, intelWindowSize++) * Math.random(), 1)[0]
		}
		
	}

}
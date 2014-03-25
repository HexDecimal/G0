package  
{
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Kyle Stewart
	 */
	public class DosState extends State 
	{
		
		private var buffer:Vector.<String> = Vector.<String>(['Thank you for playing.', '', 'C:\\>'])
		private var command:String = ''
		
		public function DosState() 
		{
			super();
			Main.cData.clear()
			/*Main.cData.setColor(0x888888, 0)
			Main.cData.drawStr(0, 0, '\n\nC:\\>')*/
		}
		
		override public function step():void 
		{
			Main.cData.clear()
			Main.cData.setColor(0x888888, 0)
			var i:int = 0
			for (var y:int = Main.cData.height - 1; y >= 0; y-- ) {
				if(i >= buffer.length){break}
				Main.cData.drawStr(0, i, buffer[i])
				i++
			}
			
		}
		
		override public function keydown(e:KeyboardEvent):void 
		{
			if (e.keyCode == 8 && buffer[buffer.length-1].length > 4) {
				buffer[buffer.length - 1] = buffer[buffer.length - 1].slice(0, buffer[buffer.length - 1].length - 1)
			}else if (e.keyCode == '\r'.charCodeAt()) {
				if(buffer[buffer.length - 1].length >4){
					buffer.push('Illegal command: ' + (buffer[buffer.length - 1].slice(4).split(' ')[0]))
				}
				buffer.push('')
				buffer.push('C:\\>')
			}else if(e.charCode){
				buffer[buffer.length-1] += String.fromCharCode(e.charCode)
			}
			while (buffer.length > Main.cData.height) {
				buffer.shift()
			}
			super.keydown(e);
		}
	}

}
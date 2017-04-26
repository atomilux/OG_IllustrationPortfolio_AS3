package atlx {
	import flash.text.TextField;
	import fl.controls.TextArea;
	
	public class Debugger {

		static public var txtField:TextArea;
		
		public function Debugger() {
			// constructor code
		}
		
		static public function setDebuggerTarget(ref:TextArea):void {
			txtField = ref;
		}
		
		static public function debug(str:String):void {
			return;
			txtField.appendText(str + "\n");
			trace(str + "\n");
		}

	}
	
}

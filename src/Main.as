package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Security;
	import SceneController;
	import mochi.as3.*;

[SWF(width=600, height=600, frameRate=30)]
	public class Main extends Sprite {
		
		public static var CONTAINER:Sprite;
		private var _mochiads_game_id:String = "04a5f1cc02429a9f";
		public static var MOCHI_ON:Boolean = true;
		public function Main() {
			Security.allowInsecureDomain("*");
			Security.allowDomain("*");
			Security.allowDomain("http://www.mochiads.com/static/lib/services/");
			start();
		}
		private function start():void
		{
			CONTAINER = new Sprite();
			MochiServices.connect( _mochiads_game_id, root, onMochiConnectError);
			addChild(CONTAINER);
			
			new SceneController(CONTAINER);
		}
		private function onMochiConnectError():void
		{
			MOCHI_ON = false;
			trace("Mochi connect fails");
		}
	}
}

package 
{
	import flash.display.Sprite;
	import SceneController;

[SWF(width=600, height=600, frameRate=30)]
	public class Main extends Sprite {
		
		private var container:Sprite;
		
		public function Main() {
			container = new Sprite();
			this.addChild(container);
			
			new SceneController(container);
		}
	}
}

package {
	import flash.display.Sprite;

	import game.Events.SceneEvent;
	import game.Scenes.GameScene;
	import game.Scenes.MenuScene;
	
	public class SceneController {
		private var _menuScene:MenuScene;
		private var _gameScene:GameScene;
		
		public function SceneController(container:Sprite) {
			_menuScene = new MenuScene(container);
			_gameScene = new GameScene(container);
			
			_menuScene.open();
			addListeners();
		}
		
		private function addListeners():void {
			_menuScene.addEventListener(SceneEvent.WANT_REMOVE, onWantRemoveMenu);
			_gameScene.addEventListener(SceneEvent.WANT_REMOVE, onWantRemoveGame);
		}
		private function onWantRemoveMenu(event:SceneEvent):void {
			_menuScene.remove();
			_gameScene.open();
		}
		private function onWantRemoveGame(event:SceneEvent):void {
			_gameScene.remove();
			_menuScene.open();
		}
	}
}

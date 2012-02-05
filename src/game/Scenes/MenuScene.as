package game.Scenes {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.display.Sprite;
	import game.MapObjects.Enemy;
	
	import game.Events.SceneEvent;
	import com.greensock.TweenMax;

	public class MenuScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _menu:Sprite;
		private var _stars:Vector.<StarView>;
		private var _asters:Vector.<Enemy>;
		
		private var _playBtn:Sprite;
		private var _playBtnTxt:TextField;
		
		public function MenuScene(container:Sprite) {
			_container = container;
			_menu = new BckgMenuView as Sprite;
			
			createPlayBtn();
		}
		public function open():void {
			createStars();
			createAsteroids();
			_container.addChild(_menu);
			_container.addChild(_playBtn);
			_menu.addEventListener(Event.ENTER_FRAME, moveAsteroids);
		}
		
		public function remove():void {
			_container.removeChild(_menu);
			removeStars();
			removeAsteroids();
			_container.removeChild(_playBtn);
			_menu.removeEventListener(Event.ENTER_FRAME, moveAsteroids);
		}
		//
		private function createStars():void {
			_stars = new Vector.<StarView>;
			var len:int = Math.random() * 20 + 60;
			for (var i:int = 0; i < len; i++) {
				var star:StarView = new StarView;
				star.x = Math.random() * _menu.width;
				star.y = Math.random() * _menu.height;
				star.scaleX = star.scaleY = Math.random() * 1.2 + .4;
				_menu.addChild(star);
				_stars.push(star);
			}
		}
		//
		private function removeStars():void
		{
			for each (var star:StarView in _stars) {
				if (_menu.contains(star)) { _menu.removeChild(star); }
			}
			_stars.length = 0;
		}
		//
		private function createAsteroids():void {
			_asters = new Vector.<Enemy>;
			var len:int = Math.random() * 4 + 5;
			for (var i:int = 0; i < len; i++) {
				var aster:Enemy = new Enemy;
				aster.randomPosition(5,5);
				_menu.addChild(aster);
				_asters.push(aster);
			}
		}
		//
		private function removeAsteroids():void {
			for each(var aster:Enemy in _asters) {
				if (_menu.contains(aster)) { _menu.removeChild(aster); } 
			}
			_asters.length = 0;
		}
		//
		private function moveAsteroids(event:Event):void {
			for each(var aster:Enemy in _asters) {
				aster.simpleMove();
				removeCheck(aster);
			}
		}
		//
		private function removeCheck(aster:Enemy):void {
			if (aster.x > 630 || aster.x < -30 || aster.y > 630 || aster.y < -30) {
				aster.randomPosition(5,5);
			}
		}
		//
		private function createPlayBtn():void {
			_playBtn = new PlayBtnRunMode as Sprite;
			//_playBtn.graphics.beginFill(0x91e600);
			//_playBtn.graphics.drawRect(-40, -20, 80, 40);
			//_playBtn.graphics.endFill();
			_playBtn.x = 200;
			_playBtn.y = 450;
			/*_playBtnTxt = new TextField();
			_playBtnTxt.x = -12;
			_playBtnTxt.y = -10;
			_playBtnTxt.text = "play";
			_playBtnTxt.selectable = false;
			_playBtnTxt.autoSize = TextFieldAutoSize.LEFT;
			_playBtnTxt.mouseEnabled = false;
			_playBtn.addChild(_playBtnTxt);*/
			_playBtn.addEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtn.addEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtn.addEventListener(MouseEvent.CLICK, onPlayBtnClick);
		}
		//
		private function onPlayBtnMouseOver(event:MouseEvent):void {
			TweenMax.to(_menu, .4, {blurFilter:{blurX:10, blurY:10,quality:2}});
		}
		//
		private function onPlayBtnMouseOut(event:MouseEvent):void {
			TweenMax.to(_menu, .4, {blurFilter:{blurX:00, blurY:00}});
		}
		//
		private function onPlayBtnClick(event:MouseEvent):void {
			event.stopPropagation();
			_playBtn.removeEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtn.removeEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtn.removeEventListener(MouseEvent.CLICK, onPlayBtnClick);
			switchScene();
		}
		//
		private function switchScene():void {
			_playBtn.removeEventListener(MouseEvent.CLICK, onPlayBtnClick);
			dispatchEvent(new SceneEvent(SceneEvent.WANT_REMOVE));
		}
	}
}

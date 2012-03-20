package game.Scenes {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.display.Sprite;
	import game.GameModeID;
	import game.MapObjects.Enemy;
	
	import game.Events.SceneEvent;
	import com.greensock.TweenMax;

	public class MenuScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _menu:Sprite;
		private var _stars:Vector.<StarView2>;
		private var _asters:Vector.<Enemy>;
		
		private var _playBtnRun:MovieClip;
		private var _playBtnShoot:MovieClip;
		private var _gameMode:int;
		
		public function MenuScene(container:Sprite) {
			_container = container;
			_menu = new /*BckgMenuView as*/ Sprite;
			
		}
		public function open():void {
			createStars();
			createAsteroids();
			createPlayBtns();
			_container.addChild(_menu);
			_container.addChild(_playBtnRun);
			_container.addChild(_playBtnShoot);
			_menu.addEventListener(Event.ENTER_FRAME, moveAsteroids);
		}
		
		public function remove():void {
			_container.removeChild(_menu);
			removeStars();
			removeAsteroids();
			_container.removeChild(_playBtnRun);
			_container.removeChild(_playBtnShoot);
			_menu.removeEventListener(Event.ENTER_FRAME, moveAsteroids);
		}
		public function get gameMode():int { return _gameMode; }
		//
		private function createStars():void {
			_stars = new Vector.<StarView2>;
			var len:int = Math.random() * 20 + 60;
			for (var i:int = 0; i < len; i++) {
				var star:StarView2 = new StarView2;
				star.x = Math.random() * 600;
				star.y = Math.random() * 600;
				star.scaleX = star.scaleY = Math.random() * 1;
				_menu.addChild(star);
				_stars.push(star);
			}
			_menu.cacheAsBitmap = true;
		}
		//
		private function removeStars():void
		{
			for each (var star:StarView2 in _stars) {
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
		private function createPlayBtns():void {
			_playBtnRun = new PlayBtnRunMode as MovieClip;
			_playBtnRun.gotoAndStop(1);
			_playBtnRun.buttonMode = true;
			_playBtnRun.x = 150;
			_playBtnRun.y = 450;
			_playBtnRun.addEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtnRun.addEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtnRun.addEventListener(MouseEvent.CLICK, onPlayBtnRunClick);
			
			_playBtnShoot = new PlayBtnShootMode as MovieClip;
			_playBtnShoot.gotoAndStop(1);
			_playBtnShoot.buttonMode = true;
			_playBtnShoot.x = 450;
			_playBtnShoot.y = 450;
			_playBtnShoot.addEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtnShoot.addEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtnShoot.addEventListener(MouseEvent.CLICK, onPlayBtnShootClick);
		}
		//
		private function onPlayBtnMouseOver(event:MouseEvent):void {
			TweenMax.to(_menu, .4, { blurFilter: { blurX:10, blurY:10, quality:2 }} );
			var button:Sprite = event.currentTarget as Sprite;
			if (button == _playBtnRun) { button = _playBtnShoot; _playBtnRun.gotoAndStop(2); }
			else { button = _playBtnRun; _playBtnShoot.gotoAndStop(2); }
			TweenMax.to(button, .4, { blurFilter: { blurX:10, blurY:10, quality:2 }} );
		}
		//
		private function onPlayBtnMouseOut(event:MouseEvent):void {
			TweenMax.to(_menu, .4, { blurFilter: { blurX:00, blurY:00 }} );
			var button:Sprite = event.currentTarget as Sprite;
			if (button == _playBtnRun) { button = _playBtnShoot; _playBtnRun.gotoAndStop(1); }
			else { button = _playBtnRun; _playBtnShoot.gotoAndStop(1); }
			TweenMax.to(button, .4, { blurFilter: { blurX:00, blurY:00 }} );
		}
		//
		private function onPlayBtnRunClick(event:MouseEvent):void {
			event.stopPropagation();
			_playBtnRun.removeEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtnRun.removeEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtnRun.removeEventListener(MouseEvent.CLICK, onPlayBtnRunClick);
			_gameMode = GameModeID.RUN_GAME;
			switchScene();
		}
		//
		private function onPlayBtnShootClick(event:MouseEvent):void {
			event.stopPropagation();
			_playBtnShoot.removeEventListener(MouseEvent.MOUSE_OVER, onPlayBtnMouseOver);
			_playBtnShoot.removeEventListener(MouseEvent.MOUSE_OUT, onPlayBtnMouseOut);
			_playBtnShoot.removeEventListener(MouseEvent.CLICK, onPlayBtnShootClick);
			_gameMode = GameModeID.SHOOT_GAME;
			switchScene();
		}
		//
		private function switchScene():void {
			TweenMax.to(_menu, .1, { blurFilter: { blurX:0, blurY:0, quality:2 }} );
			dispatchEvent(new SceneEvent(SceneEvent.WANT_REMOVE));
		}
	}
}

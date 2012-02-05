package game.Scenes {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;
	
	import game.MapObjects.Ship;
	import game.MapObjects.Enemy;
	import game.MapObjects.Bullet;
	import game.MapObjects.Points;

	public class GameScene extends EventDispatcher implements IScene {
		//[Embed(source="../imgs/game.jpg")] private var gameImg : Class;
		private var _container:Sprite;
		private var _gameBkg:Sprite;
		private var _ship:Ship;
		private var _bullet:Bullet;
		private var _enemy:Enemy;
		private var _points:Points;
		
		private var _timerEnemy:Timer;
		private var _timeAddEnemy:Number;
		
		private var angle:Number;
		
		private var _bullets:Vector.<Bullet>;
		private var _enemies:Vector.<Enemy>;
		
		private var shipToLeft:Boolean;
		private var shipToRight:Boolean;
		private var shipToUp:Boolean;
		private var shipToDown:Boolean;
		
		private var restartText:TextField;
		
		
		private var timeClock:Timer;
		
		public function GameScene(container:Sprite) {
			_container = container;	
		}
		public function open():void {
			_gameBkg = new BckgView as Sprite;
			_container.addChild(_gameBkg);
			createShip();
			createPointsBar();
			_bullets = new Vector.<Bullet>();
			_enemies = new Vector.<Enemy>();
			_timeAddEnemy = Math.random()*2000;
			_timerEnemy = new Timer(_timeAddEnemy);
			_timerEnemy.start();
			clock();
			addSceneListeners();
		}
		public function remove():void {
			_container.stage.removeEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			_container.removeChild(_gameBkg);
			_container.removeChild(_ship);
			_container.removeChild(_points);
			if (_container.contains(restartText)) { _container.removeChild(restartText); }
			removeArrays();
		}
		
		/*Internal functions*/
		
		private function addSceneListeners():void {
			_container.addEventListener(Event.ENTER_FRAME, updateMoving);
			_container.stage.addEventListener(KeyboardEvent.KEY_DOWN, shipMoving);
			_container.stage.addEventListener(KeyboardEvent.KEY_UP, shipStopMoving);
			_container.addEventListener(MouseEvent.CLICK, shot);
			_timerEnemy.addEventListener(TimerEvent.TIMER, addEnemy);
			timeClock.addEventListener(TimerEvent.TIMER, tick);
		}
		private function removeSceneListeners():void {
			_container.removeEventListener(Event.ENTER_FRAME, updateMoving);
			_container.stage.removeEventListener(KeyboardEvent.KEY_DOWN, shipMoving);
			_container.stage.removeEventListener(KeyboardEvent.KEY_UP, shipStopMoving);
			_container.removeEventListener(MouseEvent.CLICK, shot);
			_timerEnemy.removeEventListener(TimerEvent.TIMER, addEnemy);
			timeClock.removeEventListener(TimerEvent.TIMER, tick);
		}
		private function removeArrays():void {
			for each (var bullet:Bullet in _bullets) {
				if (_container.contains(bullet)) { _container.removeChild(bullet); }
			}
			for each (var enemy:Enemy in _enemies) {
				if (_container.contains(enemy)) { _container.removeChild(enemy); }
			}
			_bullets.splice(0, _bullets.length);
			_enemies.splice(0, _enemies.length);
		}
		/* SHIP */
		private function createShip():void {
			_ship = new Ship();
			shipToLeft = false;
			shipToRight = false;
			shipToUp = false;
			shipToDown = false;
			_container.addChild(_ship);
			_ship.x = 300;
			_ship.y = 300;
		}
		private function shipMoving(event:KeyboardEvent):void {
			_ship.shipMove(event);
		}
		private function updateMoving(event:Event):void {
			_ship.updateShipMove();
			_ship.gunRotate(_container, angle);
			bulletMove();
			enemyMove();
			hitTestShip();
		}
		private function shipStopMoving(event:KeyboardEvent):void {
			_ship.shipStopMove(event);
		}
		/* Bullet */
		private function shot(event:MouseEvent):void {
			_bullet = new Bullet();
			_bullet.x = _ship.x + Math.cos(_ship._gun.rotation/180 * Math.PI)*_ship.gunWidth; 
			_bullet.y = _ship.y + Math.sin(_ship._gun.rotation/180 * Math.PI)*_ship.gunWidth;
			var sx : Number = 0;
			var sy : Number = 0;
			if (shipToRight) {sx+=3;}
			if (shipToLeft) {sx-=3;}
			if(shipToUp) {sy-=3;}
			if(shipToDown) {sy+=3;}
			_bullet.speedBulletX = 10*Math.cos(_ship._gun.rotation/180 * Math.PI) + sx;
			_bullet.speedBulletY = 10*Math.sin(_ship._gun.rotation/180 * Math.PI) + sy;
			_container.addChild(_bullet);
			_bullets.push(_bullet);
		}
		private function bulletMove():void {
			for (var i:int = 0; i < _bullets.length; i++) {
					_bullets[i].move();
					hitTestBullet(_bullets[i]);
				if (_bullets[i].x < 0 || _bullets[i].x > 600 || _bullets[i].y < 0 || _bullets[i].y > 600) {
					if (_container.contains(_bullets[i])) { _container.removeChild(_bullets[i]); }
					_bullets.splice(i, 1);
				}
			}
		}
		/* Enemy */
		private function addEnemy(event:TimerEvent):void {
			_timerEnemy.removeEventListener(TimerEvent.TIMER, addEnemy);
			_timeAddEnemy = Math.random()*1000;
			_timerEnemy = new Timer(_timeAddEnemy);
			_timerEnemy.start();
			_timerEnemy.addEventListener(TimerEvent.TIMER, addEnemy);
			_enemy = new Enemy();
			_enemy.randomPosition(10,10);
			_container.addChild(_enemy);
			_enemies.push(_enemy);
		}
		private function enemyMove():void {
			for (var j:int = 0; j < _enemies.length; j++) {
				//_enemies[j].move(_ship.x, _ship.y);
				_enemies[j].simpleMove();
				_enemies[j].remove(_container, _enemies[j], _enemies);
			}
		}
		/* Hit Tests */
		private function hitTestShip():void {
			for each (var enemy:Enemy in _enemies) {
				if (enemy.hitTestPoint(_ship.x,_ship.y,true)) {
					gameOver();
				}
			}
		}
		private function hitTestBullet(bullet:Bullet):void {
			for each (var enemy:Enemy in _enemies) {
				if (enemy.hitTestPoint(bullet.x, bullet.y,true)) {
					_points.clockSeconds -= 1;
					_points.addPoint(1);
					const indexE:int = _enemies.indexOf(enemy);
					if (indexE >= 0) { _enemies.splice(indexE, 1); } 
					if (_container.contains(enemy)) { _container.removeChild(enemy); }
					bullet.x = 650; //TODO fast bug fix я понимаю что это не совсем правильно
				}
			}
		}
		/* Points */
		private function createPointsBar():void {
			_points = new Points();
			_container.addChild(_points);
			_points.scaleX = _points.scaleY = 2;
			_points.x = 20;
			_points.y = 10;
		}
		private function clock():void {
			timeClock = new Timer(100);
			timeClock.start();
		}
		private function tick(event:TimerEvent):void {
			_points.tick(event);
		}
		/* Game Over and Restart Game */
		private function gameOver():void {
			restartText = new TextField();
			restartText.x = 110;
			restartText.y = 300;
			restartText.scaleX = restartText.scaleY = 3;
			restartText.autoSize = TextFieldAutoSize.LEFT;
			restartText.selectable = false;
			restartText.textColor = 0xFFFFFF;
			restartText.text = "Press SPACE to restart Game";
			_container.addChild(restartText);
			removeSceneListeners();
			_timerEnemy.stop();
			_timerEnemy.reset();
			timeClock.stop();
			timeClock.reset();
			_container.stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
		}
		private function restartGame(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SPACE) { 
				remove();
				open();
			}
		}
	}
}

package game.Scenes {
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.ui.Keyboard;
	import game.Events.SceneEvent;
	import game.GameModeID;
	import game.MapObjects.MatrixMap;
	import game.MapObjects.ResultWindow;
	
	import game.MapObjects.Ship;
	import game.MapObjects.Enemy;
	import game.MapObjects.Bullet;
	import game.MapObjects.Points;
	
	import mochi.as3.*;

	public class GameScene extends EventDispatcher implements IScene {
		private var _container:Sprite;
		private var _gameBkg:Sprite;
		private var _matrixMap:MatrixMap;
		private var _ship:Ship;
		private var _bullet:Bullet;
		private var _enemy:Enemy;
		private var _points:Points;
		private var _resultWindow:ResultWindow;
		
		private var _timerEnemy:Timer;
		private var _timeAddEnemy:Number;
		
		private var angle:Number;
		
		private var _bullets:Vector.<Bullet>;
		private var _enemies:Vector.<Enemy>;
		private var _blows:Vector.<BlowView>;
		
		private var shipToLeft:Boolean;
		private var shipToRight:Boolean;
		private var shipToUp:Boolean;
		private var shipToDown:Boolean;
		
		private var restartText:TextField;
		
		private var _gameMode:int;
		
		private var timeClock:Timer;
		private const SHOT_SPEED:int = 5;
		private var _shotIterator:int = 0;

		private var _onShot:Boolean = false;
		
		private var _timerPointsStart:Number;
		private var _timerPointsEnd:Number;

		
		/*private var scoreShoot:Object = { n: [10, 15, 6, 11, 12, 13, 4, 7, 15, 4, 6, 15, 15, 0, 12, 0], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
		private var boardID_Point:String = scoreShoot.f(0,"");
		
		private var scoreTime:Object = { n: [12, 9, 5, 8, 5, 5, 15, 1, 4, 2, 6, 6, 2, 9, 10, 8], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};

		private var boardID_Time:String = scoreTime.f(0,"");*/
		private var boardID_Point:String = "af6bcd47f46ff0c0";
		private var boardID_Time:String = "c95855f1426629a8";
		public function GameScene(container:Sprite) {
			_container = container;	
		}
		public function open():void {
			_container.stage.focus = _container; //установка фокуса на сцене, движение объекта работают сразу же
			//_container.alpha = 0.3;
			//_gameBkg = new BckgView as Sprite;
			//_gameBkg.cacheAsBitmap = true;
			//_container.addChild(_gameBkg);
			_matrixMap = new MatrixMap;
			//_matrixMap.x = _matrixMap.y = -60;
			_container.addChild(_matrixMap);
			createShip();
			createPointsBar();
			_bullets = new Vector.<Bullet>();
			_enemies = new Vector.<Enemy>();
			_blows = new Vector.<BlowView>();
			_timeAddEnemy = Math.random()*2000;
			_timerEnemy = new Timer(_timeAddEnemy);
			_timerEnemy.start();
			addClock();
			addSceneListeners();
			_timerPointsStart = getTimer();
		}
		public function remove():void {
			_container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, newGame);
			//_container.removeChild(_gameBkg);
			_container.removeChild(_matrixMap);
			_container.removeChild(_ship);
			_container.removeChild(_points);
			_container.removeChild(_resultWindow);
			removeArrays();
		}
		public function set gameMode(value:int):void { _gameMode = value; }
		
		/*Internal functions*/
		
		private function addSceneListeners():void {
			_container.stage.addEventListener(Event.ENTER_FRAME, updateMoving);
			_container.stage.addEventListener(KeyboardEvent.KEY_DOWN, shipMoving);
			_container.stage.addEventListener(KeyboardEvent.KEY_UP, shipStopMoving);
			_container.stage.addEventListener(MouseEvent.MOUSE_DOWN, onShot);
			_container.stage.addEventListener(MouseEvent.MOUSE_UP, offShot);
			_timerEnemy.addEventListener(TimerEvent.TIMER, addEnemy);
			timeClock.addEventListener(TimerEvent.TIMER, tick);
		}
		private function removeSceneListeners():void {
			_container.stage.removeEventListener(Event.ENTER_FRAME, updateMoving);
			_container.stage.removeEventListener(KeyboardEvent.KEY_DOWN, shipMoving);
			_container.stage.removeEventListener(KeyboardEvent.KEY_UP, shipStopMoving);
			_container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onShot);
			_container.stage.removeEventListener(MouseEvent.MOUSE_UP, offShot);
			_timerEnemy.removeEventListener(TimerEvent.TIMER, addEnemy);
			timeClock.removeEventListener(TimerEvent.TIMER, tick);
			offShot(null);
		}
		private function removeArrays():void {
			for each (var bullet:Bullet in _bullets) {
				if (_container.contains(bullet)) { _container.removeChild(bullet); }
			}
			for each (var enemy:Enemy in _enemies) {
				if (_container.contains(enemy)) { _container.removeChild(enemy); }
			}
			for each (var blow:BlowView in _blows) {
				if (_container.contains(blow)) { _container.removeChild(blow); }
			}
			_bullets.length = 0;
			_enemies.length = 0;
			_blows.length = 0;
		}
		
		/* SHIP */
		private function createShip():void {
			_ship = new Ship(_matrixMap);
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
			if (_onShot) {
				if (_shotIterator == SHOT_SPEED) { onShot(null); _shotIterator = 0; } else { _shotIterator++; }
			}
			_ship.updateShipMove();
			_ship.gunRotate(_container);
			bulletMove();
			enemyMove();
			hitTestShip();
		}
		private function shipStopMoving(event:KeyboardEvent):void {
			_ship.shipStopMove(event);
		}
		/* Bullet */
		private function onShot(event:MouseEvent):void {
			_onShot = true;
			_bullet = new Bullet(_ship._gun.rotation);
			_bullet.x = _ship.x + Math.cos(_ship._gun.rotation/180 * Math.PI)*_ship.gunWidth; 
			_bullet.y = _ship.y + Math.sin(_ship._gun.rotation/180 * Math.PI)*_ship.gunWidth;
			var speedX : Number = 0;
			var speedY : Number = 0;
			if (shipToRight) { speedX += 3; }
			if (shipToLeft)  { speedX -= 3; }
			if(shipToUp) 	 { speedY -= 3; }
			if(shipToDown) 	 { speedY += 3; }
			_bullet.speedBulletX = 10*Math.cos(_ship._gun.rotation/180 * Math.PI) + speedX;
			_bullet.speedBulletY = 10*Math.sin(_ship._gun.rotation/180 * Math.PI) + speedY;
			_container.addChild(_bullet);
			_bullets.push(_bullet);
		}
		private function offShot(event:MouseEvent):void
		{
			_onShot = false;
			_shotIterator = 0;
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
			if (_gameMode == GameModeID.RUN_GAME) { _timeAddEnemy = Math.random()*1200; }
			else if (_gameMode == GameModeID.SHOOT_GAME) { _timeAddEnemy = Math.random()*500; }
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
				if (_gameMode == 0) { _enemies[j].move(_ship.x, _ship.y); }
				else if (_gameMode == 1) { _enemies[j].simpleMove(); }
				_enemies[j].remove(_container, _enemies[j], _enemies);
			}
		}
		/* Hit Tests */
		private function hitTestShip():void {
			for each (var enemy:Enemy in _enemies) {
				if (Math.abs(enemy.x - _ship.x) <= 30 && Math.abs(enemy.y - _ship.y) <= 30)
				{
					if (enemy.hitTestObject(_ship)) {
						if (_ship.checkHit(enemy))
						{
							gameOver();
						}
					}
				}
			}
		}
		private function hitTestBullet(bullet:Bullet):void {
			for each (var enemy:Enemy in _enemies) {
				if (enemy.hitTestPoint(bullet.x, bullet.y,true)) {
					if (_points.clockSeconds <= 0) { _points.clockSeconds = 0; } else { _points.clockSeconds -= 1; }
					if (_points.clockMinutes > 0) { _points.clockMinutes -= 1; }
					_points.addPoint(1);
					const index:int = _enemies.indexOf(enemy);
					if (index >= 0) { _enemies.splice(index, 1); } 
					enemy.speedX = 0;
					enemy.speedY = 0;
					showBlow(enemy);
					
					bullet.x = 650; //TODO fast bug fix я понимаю что это не совсем правильно
				}
			}
		}
		private function showBlow(enemy:Enemy):void
		{
			var blow:BlowView = new BlowView;
			blow.scaleX = blow.scaleY = .7;
			blow.x = enemy.x;
			blow.y = enemy.y;
			_blows.push(blow);
			_container.addChild(blow);
			enemy.enemyView.gotoAndPlay(2);
			blow.addEventListener(Event.ENTER_FRAME, checkForRemoveBlow);
			enemy.addEventListener(Event.ENTER_FRAME, checkForRemoveEnemy);
		}
		private function checkForRemoveBlow(e:Event):void 
		{
			var blow:BlowView = e.currentTarget as BlowView;
			if (blow.currentFrame >= 14)
			{
				blow.removeEventListener(Event.ENTER_FRAME, checkForRemoveBlow);
				const indexB:int = _blows.indexOf(blow);
				if (indexB >= 0) { _blows.splice(indexB, 1); } 
				if (_container.contains(blow)) { _container.removeChild(blow); }
			}
		}
		private function checkForRemoveEnemy(e:Event):void 
		{
			var enemy:Enemy = e.currentTarget as Enemy;
			enemy.alpha -= .05;
			if (enemy.enemyView.currentFrame >= 17)
			{
				enemy.removeEventListener(Event.ENTER_FRAME, checkForRemoveEnemy);
				
				if (_container.contains(enemy)) { _container.removeChild(enemy); }
			}
		}
		/* Points */
		private function createPointsBar():void {
			_points = new Points();
			_points.barMode(_gameMode);
			_container.addChild(_points);
			_points.scaleX = _points.scaleY = 2;
			_points.x = 20;
			_points.y = 10;
		}
		private function addClock():void {
			timeClock = new Timer(100);
			timeClock.start();
		}
		private function tick(event:TimerEvent):void {
			_points.tick(event);
		}
		/* Game Over and Restart Game */
		private function gameOver():void {
			removeSceneListeners();
			_timerEnemy.stop();
			timeClock.stop();
			trace(_points.time);
			//TODO не выдает текстовое значение
			_timerPointsEnd = getTimer();
			var timerPoints:Number = _timerPointsEnd - _timerPointsStart - _points.points * 1000;
			if (timerPoints < 0) { timerPoints = 0; }
			//trace("TIMER POINTS " + timerPoints);
			//trace("START TIME " + _timerPointsStart);
			//trace("END TIME " + _timerPointsEnd);
			//trace(_points.points);
			//_container.stage.focus = MochiScores
			if (_gameMode == GameModeID.RUN_GAME) {
				MochiScores.showLeaderboard({
				boardID: boardID_Time,
				score: timerPoints,
				onClose: showEndWindow
				});
			}
			else if (_gameMode == GameModeID.SHOOT_GAME) {
				MochiScores.showLeaderboard({
				boardID: boardID_Point,
				score: _points.points,
				onClose: showEndWindow
				});
			}
			//showEndWindow();
		}
		private function showEndWindow():void
		{
			_timerEnemy.reset();
			timeClock.reset();
			_resultWindow = new ResultWindow;
			_resultWindow.x = 230;
			_resultWindow.y = 250;
			if (_gameMode == GameModeID.RUN_GAME) { _resultWindow.resultTxt = "   TIME:\n" + _points.timeResult; }
			else if (_gameMode == GameModeID.SHOOT_GAME) { _resultWindow.resultTxt = _points.pointsResult; }	
			_container.addChild(_resultWindow);
			_container.stage.addEventListener(MouseEvent.MOUSE_DOWN, newGame);
		}
		private function newGame(event:MouseEvent):void {
			dispatchEvent(new SceneEvent(SceneEvent.WANT_REMOVE));
		}
	}
}

package game.MapObjects {
	import com.greensock.plugins.BevelFilterPlugin;
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	
	public class Enemy extends MovieClip {
		private var _enemy:MovieClip;
		private var _enemySpeed:Number;
		private var _speedX:Number;
		private var _speedY:Number;
		private var _random:Number = Math.random();
		private var _rotSpeed:Number;
		private var _model:int;
		private var _arrModel:Array = [1, 1, 2, 1, 2, 1, 1, 2, 2, 2, 2, 1, 1, 2, 1, 2, 1, 1, 1, 1, 2, 2, 1, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 1, 1];
		
		public function Enemy() {
			
			var id:int = Math.round(Math.random() * (_arrModel.length - 1));
			_model = _arrModel[id];
			if (_model == 1) { _enemy = new EnemyView2 as MovieClip; }
			else if (_model == 2) { _enemy = new EnemyView_1 as MovieClip; }
			else { trace("MODEL>>>>> ",_model, id); }
			if (_enemy == null) { throw new Error("WTF Where's enemy???"); }
			this.cacheAsBitmap = true;
			_enemy.stop();
			super.addChild(_enemy);
			_enemySpeed = 2 + Math.random();
			this.cacheAsBitmap = true;  //улучшает производительность возможно //only for static sprites
		}
		public function get enemyView():MovieClip { return _enemy; }
		public function set speedX(value:int):void { _speedX = value; }
		public function set speedY(value:int):void { _speedY = value; }
		public function randomPosition(speedX:int, speedY:int):void {
			_random = Math.random();
			_rotSpeed = Math.random() * 10 - 5;
			if (_random < .25) {
				this.x = Math.random()*600;
				this.y = -20;
				_speedX = 0;
				_speedY = Math.random() * speedY;
			}
			if (_random > .25 && _random < .5) {
				this.x = Math.random()*600;
				this.y = 620;
				_speedX = 0;
				_speedY = -Math.random() * speedY;
			}
			if (_random > .5 && _random < .75) {
				this.x = -20;
				this.y = Math.random() * 600;
				_speedX = Math.random() * speedX;
				_speedY = 0;
			}
			if (_random > .75) {
				this.x = 620;
				this.y = Math.random() * 600;
				_speedX = -Math.random() * speedX;
				_speedY = 0;
			}
		}
		public function move(targetX:Number, targetY:Number):void {
			this.rotation += _rotSpeed;
			var dx : Number = targetX - this.x;
			var dy : Number = targetY - this.y;
			var d : Number = Math.sqrt(dx*dx+dy*dy);
			var vx : Number;
			var vy : Number;
			if (d==0){
				vx = 0;
				vy = 0;
			} else {
				vx = dx/d * _enemySpeed;
				vy = dy/d * _enemySpeed;
			}
			this.x += vx;
			this.y += vy;
		}
		
		public function simpleMove():void
		{
			this.rotation += _rotSpeed;
			this.x += _speedX;
			this.y += _speedY;
		}
		
		
		
		public function remove(container:Sprite, enemy:Enemy, enemies:Vector.<Enemy>):void {
			if (this.x > 630 || this.x < -30 || this.y > 630 || this.y < -30) {
				const index:int = enemies.indexOf(enemy);
				if (index >= 0) { enemies.splice(index, 1); } 
				if (container.contains(enemy)) { container.removeChild(enemy); }
			}
			/*if (this.x > 630) { this.x = -30; }
			if (this.x < -30) { this.x = 630; }
			if (this.y > 630) { this.y = -30; }
			if (this.y < -30) { this.y = 630; }*/
		}
	}
}

package game.MapObjects {
	import com.greensock.plugins.BevelFilterPlugin;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	
	public class Enemy extends Sprite {
		private var _enemy:Sprite;
		private var _enemySpeed:Number;
		private var _speedX:Number;
		private var _speedY:Number;
		private var _random:Number = Math.random();
		
		public function Enemy() {
			_enemy = new EnemyView as Sprite;
			addChild(_enemy);
			_enemySpeed = 2 + Math.random();
		}
		public function set speedX(value:int):void { _speedX = value; }
		public function set speedY(value:int):void { _speedY = value; }
		public function randomPosition(speedX:int, speedY:int):void {
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
			this.rotation +=4;
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
			this.rotation += Math.random() * 6;
			this.x += _speedX;
			this.y += _speedY;
		}
		
		
		
		public function remove(container:Sprite, enemy:Enemy, enemies:Vector.<Enemy>):void {
			if (this.x > 630 || this.x < -30 || this.y > 630 || this.y < -30) {
				const index:int = enemies.indexOf(enemy);
				if (index >= 0) { enemies.splice(index, 1); } 
				if (container.contains(enemy)) { container.removeChild(enemy); }
			}
		}
	}
}

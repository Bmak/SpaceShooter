package game.MapObjects {
	import flash.display.Sprite;

	public class Bullet extends Sprite {
		
		private var _bullet:Sprite;
		public var speedBulletX:Number;
		public var speedBulletY:Number;
		public function Bullet(angle:Number) {
			_bullet = new SimpleBulletView as Sprite;
			/*_bullet.graphics.beginFill(0x00FF00);
			_bullet.graphics.drawCircle(0, 0, 3);
			_bullet.graphics.endFill();*/
			_bullet.rotation =90 + angle;
			this.addChild(_bullet);
		}
		public function move():void {
			this.x += speedBulletX;
			this.y += speedBulletY;
		}
	}
}

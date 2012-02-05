package game.MapObjects {
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Sprite;
	
	import com.greensock.TweenMax;
	
	public class Ship extends Sprite {
		private var _ship:Sprite;
		public var _gun:Sprite;
		public var gunWidth:Number = 20;
		public var sheepSpeed:Number = 5;
		
		
		private var shipToLeft:Boolean;
		private var shipToRight:Boolean;
		private var shipToUp:Boolean;
		private var shipToDown:Boolean;
		
		
		public function Ship() {
			createShip();
		}
		private function createShip():void {
			_ship = new Sprite;
			_gun = new HeroView as Sprite;
			/*_gun.graphics.beginFill(0x000000);
			_gun.graphics.drawRect(-5, -1, 25, 2);
			_gun.graphics.endFill();*/
			_ship.addChildAt(_gun,0);
			addChild(_ship);
			addEventListener(Event.ADDED_TO_STAGE, glowShip);
			TweenMax.to(this, .0001, {blurFilter:{blurX:10, blurY:10}});
		}
		private function glowShip(event:Event):void {
			TweenMax.to(this, 2, {blurFilter:{blurX:0, blurY:0}});
		}
		
		public function shipMove(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.D) { shipToRight = true; }
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.A) { shipToLeft = true; }
			if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.S) { shipToDown = true; }
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.W) { shipToUp = true; }
		}
		public function updateShipMove():void {
			if (shipToRight) { this.x += sheepSpeed; }
			if (shipToLeft)  { this.x -= sheepSpeed; }
			if (shipToDown)  { this.y += sheepSpeed; }
			if (shipToUp)    { this.y -= sheepSpeed; }
			if (this.x < 10)  { this.x = 10; }
			if (this.x > 590) { this.x = 590; }
			if (this.y < 10)  { this.y = 10; }
			if (this.y > 590) { this.y = 590; }
		}
		public function shipStopMove(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.D) { shipToRight = false; }
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.A) { shipToLeft = false; }
			if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.S) { shipToDown = false; }
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.W) { shipToUp = false; }
		}
		public function gunRotate(container:Sprite, angle:Number):void {
			var dx:Number = this.x - container.mouseX;
			var dy:Number = this.y - container.mouseY;
			angle = Math.atan2(dy, dx)*180/Math.PI;
			_gun.rotation = 180 + angle;
		}
	}
}

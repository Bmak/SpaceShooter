package game.MapObjects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Sprite;
	
	import com.greensock.TweenMax;
	
	public class Ship extends MovieClip {
		private var _ship:MovieClip;
		private var _matrixMap:MatrixMap;
		public var _gun:MovieClip;
		public var gunWidth:Number = 20;
		public var sheepSpeed:Number = 5;
		
		
		private var shipToLeft:Boolean;
		private var shipToRight:Boolean;
		private var shipToUp:Boolean;
		private var shipToDown:Boolean;
		
		private var _onMove:Boolean = false;
		
		public function Ship(matrix:MatrixMap) {
			_matrixMap = matrix;
			createShip();
		}
		private function createShip():void {
			//_ship = new Sprite;
			_gun = new ShipView;
			/*_gun.graphics.beginFill(0x000000);
			_gun.graphics.drawRect(-5, -1, 25, 2);
			_gun.graphics.endFill();*/
			_gun.stop();
			super.addChild(_gun);
			//addChild(_ship);
			addEventListener(Event.ADDED_TO_STAGE, glowShip);
			TweenMax.to(this, .0001, {blurFilter:{blurX:10, blurY:10}});
		}
		private function glowShip(event:Event):void {
			TweenMax.to(this, 2, {blurFilter:{blurX:0, blurY:0}});
		}
		
		public function shipMove(event:KeyboardEvent):void {
			_onMove = true;
			showMove();
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.D) { shipToRight = true; }
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.A) { shipToLeft = true; }
			if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.S) { shipToDown = true; }
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.W) { shipToUp = true; }
		}
		//TODO доделать эффект скролла карты
		public function updateShipMove():void {
			if (_gun.currentFrame >= 10) { _gun.gotoAndPlay(2); }
			if (!shipToRight && !shipToLeft && !shipToDown && !shipToUp ) { _gun.gotoAndStop(1); }
			if (shipToRight) { this.x += sheepSpeed; /*_matrixMap.matrix.x -= 5; _matrixMap.addStar(2);*/ }
			if (shipToLeft)  { this.x -= sheepSpeed; /*_matrixMap.matrix.x += 5; _matrixMap.addStar(1);*/ }
			if (shipToDown)  { this.y += sheepSpeed; /*_matrixMap.matrix.y -= 5; _matrixMap.addStar(4);*/ }
			if (shipToUp)    { this.y -= sheepSpeed; /*_matrixMap.matrix.y += 5; _matrixMap.addStar(3);*/ }
			//_matrixMap.updateMatrix();
			if (this.x < 10)  { this.x = 10; }
			if (this.x > 590) { this.x = 590; }
			if (this.y < 10)  { this.y = 10; }
			if (this.y > 590) { this.y = 590; }
		}
		public function shipStopMove(event:KeyboardEvent):void {
			_onMove = false;
			if (event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.D) { shipToRight = false; }
			if (event.keyCode == Keyboard.LEFT || event.keyCode == Keyboard.A) { shipToLeft = false; }
			if (event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.S) { shipToDown = false; }
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.W) { shipToUp = false; }
		}
		public function gunRotate(container:Sprite):void {
			var dx:Number = this.x - container.mouseX;
			var dy:Number = this.y - container.mouseY;
			var angle:Number = Math.atan2(dy, dx)*180/Math.PI;
			_gun.rotation = 180 + angle;
		}
		public function checkHit(enemy:Enemy):Boolean
		{
			var result:Boolean = false;
			/*отрисовываем 2 битмапы и хиттестим их*/
			var bmpd1:BitmapData = new BitmapData(this.width, this.height, true, 0);
			//var bmp1:Bitmap = new Bitmap(bmpd1);
			
			var bmpd2:BitmapData = new BitmapData(enemy.width, enemy.height, true, 0);
			//var bmp2:Bitmap = new Bitmap(bmpd2);
			
			bmpd1.fillRect(bmpd1.rect, 0);
			bmpd2.fillRect(bmpd2.rect, 0);
 	
			bmpd1.draw(this, new Matrix(1, 0, 0, 1, 0, 0),null,null,null,true);
			bmpd2.draw(enemy, new Matrix(1, 0, 0, 1, 0, 0),null,null,null,true);
			
			if(bmpd1.hitTest(new Point(/*bmp1.x, bmp1.y*/), 0, bmpd2, new Point(/*bmp2.x, bmp2.y*/), 0))
			{
				result = true;
			}
			return result;
		}
		private function showMove():void
		{
			if (_onMove) { _gun.gotoAndPlay(2); }
		}
	}
}

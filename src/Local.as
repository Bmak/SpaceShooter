package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import game.MapObjects.MatrixMap;
	/**
	 * Модель движения корабля
	 * @author BigMac
	 */
	[SWF(width=600, height=600, frameRate=30)]
	public class Local extends Sprite
	{
		private var _ball:Sprite;
		private var _speedX:Number = 0;
		private var _speedY:Number = 0;
		private var _maxSpeed:int = 10;
		private var _minSpeed:int = 0;
		private var _acceleration:Number = .75;
		
		private var _onMove:Boolean = false;
		private var _revers:Boolean = false;
		
		private var left:Boolean = false;
		private var right:Boolean = false;
		private var up:Boolean = false;
		private var down:Boolean = false;
		
		private var speed:int = 5;
		
		public function Local() 
		{
			super();
			_ball = new Sprite;
			_ball.graphics.beginFill(0xFF8040);
			_ball.graphics.drawCircle(200, 200, 10);
			_ball.graphics.endFill();
			super.addChild(_ball);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		private function onEnterFrame(e:Event):void
		{
			_ball.x += _speedX;
			_ball.y += _speedY;
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT) {
				_speedX += _acceleration;
				if (_speedX >= _maxSpeed) { _speedX = _maxSpeed; }
			}
			if (e.keyCode == Keyboard.LEFT) {
				
			}
			if (e.keyCode == Keyboard.UP) {
				
			}
			if (e.keyCode == Keyboard.DOWN) {
				
			}
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT) { right = false; }
			if (e.keyCode == Keyboard.LEFT) { left = false; }
			if (e.keyCode == Keyboard.UP) { up = false; }
			if (e.keyCode == Keyboard.DOWN) { down = false; }
		}
	}

}
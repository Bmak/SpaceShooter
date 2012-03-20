package game.MapObjects {
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	
	public class Points extends Sprite {
		private var _pointSprite:Sprite;
		private var _points:int = 0;
		private var _pointText:TextField;
		public var _clockText:TextField;
		public var clockHours:Number = 0;
		public var clockMinutes:Number = 0;
		public var clockSeconds:Number = 0;
		public var clockMiliSeconds:Number = 0;
		
		public function Points () {
			_pointSprite = new Sprite();
			_clockText = new TextField();
			_clockText.selectable = false;
			_clockText.textColor = 0x00FF00;
			_clockText.text = "00 : 00 : 00 : 00";
			_pointSprite.addChild(_clockText);
			_pointText = new TextField();
			_pointText.x = 220;
			_pointText.type = TextFieldType.DYNAMIC;
			_pointText.selectable = false;
			_pointText.textColor = 0x00FF00;
			_pointText.text = "Points: " + _points.toString();
			_pointSprite.addChild(_pointText);
			addChild(_pointSprite);
		}
		public function get timeResult():String { return _clockText.text; }
		public function get pointsResult():String { return _pointText.text; }
		public function get points():Number { return _points; }
		public function get time():String { return _clockText.text; }
		
		public function barMode(mode:int):void
		{
			if (mode == 0) { _pointText.alpha = 0; _clockText.alpha = 1; }
			else if (mode == 1) { _pointText.alpha = 1; _clockText.alpha = 0; }
		}
		public function addPoint(point:int):void {
			_points += point;
			_pointText.text = "Points: " + _points.toString();
		}
		
		public function tick(event:TimerEvent):void {
			clockMiliSeconds +=1;
			if (clockMiliSeconds == 10) {
				clockSeconds += 1;
				clockMiliSeconds = 0;
			}
			if (clockSeconds == 60) {
				clockMinutes += 1;
				clockSeconds = 0;
			}
			if (clockMinutes == 60) {
				clockHours += 1;
				clockMinutes = 0;
			}
			_clockText.text = clockHours.toString() + " : " + clockMinutes.toString() + 
											" : " + clockSeconds.toString()+ " : " + clockMiliSeconds.toString();
		}
	}
}

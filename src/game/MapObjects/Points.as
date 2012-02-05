package game.MapObjects {
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.Sprite;
	
	public class Points extends Sprite {
		private var _pointSprite:Sprite;
		private var _point:int = 0;
		private var _pointText:TextField;
		public var clockText:TextField;
		public var clockHours:Number = 0;
		public var clockMinutes:Number = 0;
		public var clockSeconds:Number = 0;
		public var clockMiliSeconds:Number = 0;
		
		public function Points () {
			_pointSprite = new Sprite();
			clockText = new TextField();
			clockText.selectable = false;
			clockText.textColor = 0xFFFF00;
			clockText.text = "00 : 00 : 00 : 00";
			_pointSprite.addChild(clockText);
			_pointText = new TextField();
			_pointText.x = 220;
			_pointText.type = TextFieldType.DYNAMIC;
			_pointText.selectable = false;
			_pointText.textColor = 0xFFFF00;
			_pointText.text = "Points: " + _point.toString();
			_pointSprite.addChild(_pointText);
			addChild(_pointSprite);
		}
		public function addPoint(point:int):void {
			_point += point;
			_pointText.text = "Points: " + _point.toString();
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
			clockText.text = clockHours.toString() + " : " + clockMinutes.toString() + 
											" : " + clockSeconds.toString()+ " : " + clockMiliSeconds.toString();
		}
	}
}

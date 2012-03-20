package game.MapObjects 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * Окно Результатов
	 * @author ProBigi
	 */
	public class ResultWindow extends Sprite
	{
		private var _window:Sprite;
		private var _resultTxt:TextField;
		public function ResultWindow() 
		{
			_window = new Sprite;
			_window.graphics.beginFill(0xC0C0C0);
			_window.graphics.drawRoundRect(0, 0, 155, 70, 5, 5);
			_window.graphics.endFill();
			
			_resultTxt = new TextField;
			_resultTxt.selectable = false;
			_resultTxt.autoSize = TextFieldAutoSize.LEFT;
			_resultTxt.x = 40;
			_resultTxt.y = 20;
			_resultTxt.scaleX = _resultTxt.scaleY = 1.5;
			_window.addChild(_resultTxt);
			super.addChild(_window);
		}
		public function set resultTxt(value:String):void { _resultTxt.text = value; }
	}
}
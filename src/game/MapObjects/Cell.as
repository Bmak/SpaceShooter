package game.MapObjects 
{
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	/**
	 * Ячейка Фона
	 * @author ProBigi
	 */
	public class Cell extends Sprite
	{
		private var _square:Sprite;
		private var _stars:Vector.<Star>;
		public function Cell() 
		{
			super();
			createCell();
		}
		private function createCell():void
		{
			_square = new Sprite;
			//_square.graphics.lineStyle(1);
			_square.graphics.beginFill(0x000080);
			_square.graphics.drawRect(0, 0, 60, 60);
			_square.graphics.endFill();
			
			_stars = new Vector.<Star>;
			var len:int = Math.random() * 8;
			for (var i:int = 0; i < len; i++ )
			{
				var star:Star = new Star;
				star.x = Math.random() * 45 + 7;
				star.y = Math.random() * 45 + 7;
				_square.addChild(star);
				_stars.push(star);
			}
			//trace("W H: ", _square.width, _square.height);
			super.addChild(_square);
		}
	}

}
package game.MapObjects 
{
	import flash.display.Sprite;
	/**
	 * Звезда
	 * @author BigMac
	 */
	public class Star extends Sprite 
	{
		private var _star:Sprite;
		private var _arrStars:Array = [StarView1, StarView2, StarView3];
		public function Star() 
		{
			super();
			var _rnd:Number = Math.random() * .5;
			var id:int = Math.round(Math.random() * (_arrStars.length - 1));
			_star = new _arrStars[id] as Sprite;
			_star.rotation = Math.random() * 360;
			_star.scaleX = _star.scaleY = _rnd;
			/*_star.graphics.beginFill(0xFFFF00);
			_star.graphics.drawCircle(0, 0, _rnd);
			_star.graphics.endFill();*/
			super.addChild(_star);
		}
		
	}

}
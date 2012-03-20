package game.MapObjects 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * Отображение карты
	 * @author BigMac
	 */
	public class MatrixMap extends Sprite
	{
		private var _matrix:Sprite;
		private var _stars:Vector.<Star>;
		private var _planet1:Sprite;
		private var _planet2:Sprite;
		private var _fon:Sprite;
		private const numRow:int = 12;
		private const numCol:int = 12;
		
		private var _arr:Vector.<Star> = new Vector.<Star>;
		public function MatrixMap() 
		{
			super();
			//_fon = new Sprite;
			//_fon.graphics.beginFill(0x000080);
			//_fon.graphics.drawRect(0, 0, 600, 600);
			//_fon.graphics.endFill();
			//super.addChild(_fon);
			createGrid();
		}
		public function get matrix():Sprite { return _matrix; }
		public function updateMatrix():void
		{
			/*for each (var cell:Cell in _cells)
			{
				//var point:Point = cell.globalToLocal
				//trace("XY ", cell.localToGlobal(new Point( -60, -60)));
				var point:Point = cell.localToGlobal(new Point( -60, -60));
				if (point.x > 650) { addCell( -780, 0, cell); }
				else if (point.x < -120) { addCell(720, 0, cell); }
				else if (point.y > 650) { addCell(0, -720, cell); }
				else if (point.y < -120) { addCell(0, 720, cell); }
			}*/

			for each (var star:Star in _stars)
			{
				var point:Point = star.localToGlobal(new Point( 0, 0));
				if (point.x > 600 || point.x < 0 || point.y > 600 || point.y < 0)
				{
					_matrix.removeChild(star);
					var index:int = _stars.indexOf(star);
					_stars.splice(index, 1);
				}
			}
		}
		private function addCell(x:Number, y:Number, cell:Cell):void
		{
			var newCell:Cell = new Cell;
			newCell.x = cell.x + x;
			newCell.y = cell.y + y;
			_matrix.removeChild(cell);
			_matrix.addChild(newCell);
			var index:int = _stars.indexOf(cell);
			_stars.splice(index, 1);
			_stars.push(newCell);
		}
		//TODO Доделать эту херь
		public function addStar(dir:int):void
		{
			var star:Star = new Star;
			switch(dir)
			{
				case 1:
					star.x = -20 * Math.random() - 5;
					star.y = Math.random() * 600;
					break;
				case 2:
					star.x = 20 * Math.random() + 605;
					 star.y = Math.random() * 600;
					break;
				case 3:
					star.x = Math.random() * 600;
					star.y = -20 * Math.random() - 5;
					break;
				case 4:	
					star.x = Math.random() * 600;
					star.y = 20 * Math.random() + 605;
					break;
			}
			//var point:Point = star.globalToLocal(new Point(_matrix.x, _matrix.y));
			
			_matrix.addChild(star);
			_stars.push(star);
		}
		/*Creat Grid*/
		private function createGrid():void
		{
			_matrix = new Sprite;
			_stars = new Vector.<Star>;
			
			/*for (var i:int = 0; i < numCol; i++)
			{
				for (var j:int = 0; j < numRow; j++)
				{
					var cell:Cell = new Cell;
					cell.x = cell.width * j;
					cell.y = cell.height * i;
					_cells.push(cell);
					_matrix.addChild(cell);
				}
			}*/
			
			for (var i:int = 0; i < 100; i++)
			{
				var star:Star = new Star;
				star.x = Math.random() * 600;
				star.y = Math.random() * 600;
				star.cacheAsBitmap = true;
				_matrix.addChild(star);
				_stars.push(star);
			}
			_planet1 = new PlanetView as Sprite;
			_planet1.x = Math.random() * 600;
			_planet1.y = Math.random() * 300;
			_planet2 = new SaturnView as Sprite;
			_planet2.x = Math.random() * 600;
			_planet2.y = Math.random() * 300 + 300;
			_matrix.addChild(_planet1);
			_matrix.addChild(_planet2);
			
			_matrix.cacheAsBitmap = true;
			super.addChild(_matrix);
		}
	}

}
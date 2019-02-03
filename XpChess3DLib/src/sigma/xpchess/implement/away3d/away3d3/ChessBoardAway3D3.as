package sigma.xpchess.implement.away3d.away3d3
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Plane;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardPool;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManPos;
	
	internal class ChessBoardAway3D3 extends ObjectContainer3D implements IChessBoard
	{
		public static var BoardHeight: Number = 15;
		private var _boardType: int = -1;
		private var _mansLayer: ObjectContainer3D;
		protected var _boardRotation: Number = 0;
		
		public function ChessBoardAway3D3(boardType: int)
		{
			init(boardType);
		}
		
		public function get eventDispatcher(): IEventDispatcher
		{
			return this;
		}
		
		//--------------------------------------------------------------
		public function get boardType(): int
		{
			return _boardType;
		}
		
		public function reset(): void
		{
			this.boardRotation = 0;
			this.rotationX = 0;
			this.rotationY = 0;
			this.rotationZ = 0;
			this.x = 0;
			this.y = 0;
			this.z = 0;
		}
		
		//--------------------------------------------------------------
		public function clearChessMans(): void
		{
			for (var i: int = _mansLayer.children.length - 1; i >= 0; --i)
			{
				var chessMan: ChessManAway3D3 = _mansLayer.children[i] as ChessManAway3D3;
				if (chessMan != null)
				{
					_mansLayer.removeChild(chessMan);
					ChessPool.freeChessMan(chessMan);
				}
			}
		}
		
		public function addChessMan(man: IChessMan): void
		{
			var manObject: ObjectContainer3D = man as ObjectContainer3D;
			_mansLayer.addChild(manObject);
			manObject.rotationZ = manAngle(_boardRotation);
			manObject.rotationX = 90;
		}
		
		//--------------------------------------------------------------
		private function init(boardType: int): void
		{
			//add chessBoard
			var boardSprite: Sprite = ChessBoardPool.getChessBoard(boardType) as Sprite;
			if (boardSprite)
			{
				_boardType = boardType;
				createWithPlanes(boardSprite);
				ChessBoardPool.freeChessBoard(boardSprite);
			}
			else
				throw new Error("Invalid ChessBoard Type value");
			
			//add chessMansLayer
			_mansLayer = new ObjectContainer3D();
			_mansLayer.z = -BoardHeight / 2;
			_mansLayer.mouseEnabled = false;
			this.addChild(_mansLayer);
			
			reset();
		}
		
		private function createWithPlanes(boardSprite: Sprite): void
		{
			//board plane
			boardSprite.x = boardSprite.width / 2;
			boardSprite.y = boardSprite.height / 2;
			
			var topMaterial: BitmapMaterialEx = new BitmapMaterialEx(boardSprite);
			var topPlane: Plane = new Plane();
			topPlane.width = boardSprite.width;
			topPlane.height = boardSprite.height;
			topPlane.material = topMaterial;
			topPlane.rotationX = 90;
			topPlane.z = -BoardHeight / 2;
			
			//bottom plane
			var bmpData: BitmapData = topMaterial.bitmapData;
			var bmpData2: BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0xffaaaaaa);
			var rect: Rectangle = new Rectangle(0, 0, bmpData.width, bmpData.height);
			bmpData2.copyChannel(bmpData, rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var bottomMaterial: BitmapMaterialEx = new BitmapMaterialEx(bmpData2);
			var bottomPlane: Plane = new Plane();
			bottomPlane.width = boardSprite.width;
			bottomPlane.height = boardSprite.height;
			bottomPlane.material = bottomMaterial;
			bottomPlane.z = BoardHeight / 2;
			bottomPlane.rotationX = 270;
			
			//add planes
			this.addChild(topPlane);
			
			var sidesLayer: ObjectContainer3D = new ObjectContainer3D();
			sidesLayer.addChild(bottomPlane);
			sidesLayer.rotationZ = 180;
			this.addChild(sidesLayer);
			
			//side planes
			var sideMaterial: ColorMaterial = new ColorMaterial(0x555555);
			var cornerArray: Array = ChessBoardUtil.getCorner(_boardType);
			var n: int = cornerArray.length;
			for (var i: int = 0; i < n; i++)
			{
				var j: int = (i + 1) % n;
				var dx: Number = cornerArray[i].x - cornerArray[j].x;
				var dy: Number = cornerArray[i].y - cornerArray[j].y;
				var w: Number = Math.sqrt(dx * dx + dy * dy);
				var sidePlane: Plane = new Plane();
				sidePlane.width = w;
				sidePlane.height = BoardHeight;
				sidePlane.material = sideMaterial;
				sidePlane.x = (cornerArray[i].x + cornerArray[j].x) / 2;
				sidePlane.y = (cornerArray[i].y + cornerArray[j].y) / 2;
				sidePlane.rotationZ = Math.atan2(dy, dx) * 180 / Math.PI + 180;
				sidesLayer.addChild(sidePlane);
			}
			
			//add listener
			topPlane.mouseEnabled = true;
			topPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: MouseEvent3D): void
		{
			// how to get the localX, localY ???
			trace("scenePos:", e.sceneX, e.sceneY, "screenPos", e.screenX, e.screenY);
			
			var local: Vector3D = new Vector3D(e.screenX, e.screenY, e.screenZ);
			var transfrom: Matrix3D = this.transform.clone();
//			transform.rawData[0] = transform.rawData[5] = transform.rawData[10] = transform.rawData[15] = 1;
			local = transform.transformVector(local);
			
//			var local: Point = new Point(e.screenX, e.screenY);
//			var matrix: Matrix = new Matrix();
//			matrix.rotate(this.boardRotation / 180 * Math.PI);
//			local = matrix.transformPoint(local);
			
			var localX: Number = local.x;
			var localY: Number = local.y;
//			trace(localX, localY);
			this.dispatchEvent(new XpChessBoardEvent(XpChessBoardEvent.CLICK_BOARD, boardType, localX, localY));
		}
		
		//--------------------------------------------------------------
		public function set boardRotation(value: Number): void
		{
			if (_boardRotation != value)
			{
				var manRotation: Number = manAngle(value);
				for (var i: int = 0, n: int = _mansLayer.children.length; i < n; i++)
				{
					_mansLayer.children[i].rotationZ = manRotation;
				}
				
				var degrees: Number = (value - _boardRotation) * -1;
				var mat: Matrix3D = this.transform.clone();
				mat.prependRotation(degrees, Vector3D.Z_AXIS);
				this.transform = mat;
				
				_boardRotation = value;
			}
		}
		
		public function get boardRotation(): Number
		{
			return _boardRotation;
		}
		
		private static function manAngle(boardAngle: Number): Number
		{
			return boardAngle;
		}
		
		//--------------------------------------------------------------
		public function clearPrint(): void
		{
		}
		
		public function printMove(pos: ChessManPos, color: uint): void
		{
		}
	}
}
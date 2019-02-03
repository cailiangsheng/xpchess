package sigma.xpchess.implement.pv3d
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardPool;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManPos;
	
	internal class ChessBoardPV3D extends DisplayObject3D implements IChessBoard
	{
		public static var BoardHeight: Number = 15;
		private var _boardType: int = -1;
		private var _mansLayer: DisplayObject3D;
		protected var _boardRotation: Number = 0;
		
		public function ChessBoardPV3D(boardType: int)
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
				var chessMan: ChessManPV3D = _mansLayer.children[i] as ChessManPV3D;
				if (chessMan != null)
				{
					_mansLayer.removeChild(chessMan);
					ChessPool.freeChessMan(chessMan);
				}
			}
		}
		
		public function addChessMan(man: IChessMan): void
		{
			var manObject: DisplayObject3D = man as DisplayObject3D;
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
			_mansLayer = new DisplayObject3D();
			_mansLayer.z = -BoardHeight;
			_mansLayer.z -= 1;	// not too close to the board
			this.addChild(_mansLayer);
			
			reset();
		}
		
		private function createWithPlanes(boardSprite: Sprite): void
		{
			//board plane
			boardSprite.x = boardSprite.width / 2;
			boardSprite.y = boardSprite.height / 2;
			
			var topMaterial: BitmapMaterialEx = new BitmapMaterialEx(boardSprite);
			var topPlane: Plane = new Plane(topMaterial, boardSprite.width, boardSprite.height, 50, 50);
			topPlane.z = -BoardHeight / 2;
			
			//bottom plane
			var bmpData: BitmapData = topMaterial.bitmapData;
			var bmpData2: BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0xffaaaaaa);
			var rect: Rectangle = new Rectangle(0, 0, bmpData.width, bmpData.height);
			bmpData2.copyChannel(bmpData, rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var bottomMaterial: BitmapMaterialEx = new BitmapMaterialEx(bmpData2);
			var bottomPlane: Plane = new Plane(bottomMaterial, bmpData2.width, bmpData2.height, 50, 50);
			bottomPlane.z = BoardHeight / 2;
			bottomPlane.rotationX = 180;
			
			//add planes
			this.addChild(topPlane);
			
			var sidesLayer: DisplayObject3D = new DisplayObject3D();
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
				var sidePlane: Plane = new Plane(sideMaterial, w, BoardHeight);
				sidePlane.x = (cornerArray[i].x + cornerArray[j].x) / 2;
				sidePlane.y = (cornerArray[i].y + cornerArray[j].y) / 2;
				sidePlane.rotationX = -90;
				sidePlane.rotationZ = Math.atan2(dy, dx) * 180 / Math.PI;
				sidesLayer.addChild(sidePlane);
			}
			
			//add listener
			topPlane.material.interactive = true;
			topPlane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: InteractiveScene3DEvent): void
		{
			// to do test ...
			var localX: Number = e.x;
			var localY: Number = -e.y;
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
//				var mat: Matrix3D = this.transform.clone();
//				mat.prependRotation(degrees, Vector3D.Z_AXIS);
//				this.transform = mat;
				
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
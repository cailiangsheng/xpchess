package sigma.xpchess.implement.away3d.away3d4
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardPool;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManPos;
	
	internal class ChessBoardAway3D4 extends ObjectContainer3D implements IChessBoard
	{
		public static var BoardHeight: Number = 15;
		private var _boardType: int = -1;
		private var _mansLayer: ObjectContainer3D;
		protected var _boardRotation: Number = 0;
		
		public function ChessBoardAway3D4(boardType: int)
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
			for (var i: int = _mansLayer.numChildren - 1; i >= 0; --i)
			{
				var chessMan: ChessManAway3D4 = _mansLayer.getChildAt(i) as ChessManAway3D4;
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
			_mansLayer.mouseEnabled = _mansLayer.mouseChildren = false;
			this.addChild(_mansLayer);
			
			reset();
		}
		
		private function createWithPlanes(boardSprite: Sprite): void
		{
			//board plane
			boardSprite.x = boardSprite.width / 2;
			boardSprite.y = boardSprite.height / 2;
			
			var topMaterial: TextureMaterialEx = new TextureMaterialEx(boardSprite);
			var topPlane: Mesh = new Mesh(new PlaneGeometry(boardSprite.width, boardSprite.height, 1, 1, false));
			topPlane.material = topMaterial;
			topPlane.z = -BoardHeight / 2;
			
			//bottom plane
			var bmpData: BitmapData = topMaterial.bitmapData;
			var bmpData2: BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0xffaaaaaa);
			var rect: Rectangle = new Rectangle(0, 0, bmpData.width, bmpData.height);
			bmpData2.copyChannel(bmpData, rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var bottomMaterial: TextureMaterial = new TextureMaterialEx(bmpData2);
			var bottomPlane: Mesh = new Mesh(new PlaneGeometry(boardSprite.width, boardSprite.height, 1, 1, false));
			bottomPlane.material = bottomMaterial;
			bottomPlane.z = BoardHeight / 2;
			bottomPlane.rotationX = 180;
			
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
				var sidePlane: Mesh = new Mesh(new PlaneGeometry(w, BoardHeight, 1, 1));
				sidePlane.material = sideMaterial;
				sidePlane.x = (cornerArray[i].x + cornerArray[j].x) / 2;
				sidePlane.y = (cornerArray[i].y + cornerArray[j].y) / 2;
				sidePlane.rotationZ = Math.atan2(dy, dx) * 180 / Math.PI + 180;
				sidesLayer.addChild(sidePlane);
			}
			
			//add listener
			topPlane.mouseEnabled = topPlane.mouseChildren = true;
			topPlane.addEventListener(MouseEvent3D.MOUSE_DOWN, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: MouseEvent3D): void
		{
			var localX: Number = e.localPosition.x;
			var localY: Number = -e.localPosition.y;
			this.dispatchEvent(new XpChessBoardEvent(XpChessBoardEvent.CLICK_BOARD, boardType, localX, localY));
		}
		
		//--------------------------------------------------------------
		public function set boardRotation(value: Number): void
		{
			if (_boardRotation != value)
			{
				var manRotation: Number = manAngle(value);
				for (var i: int = 0, n: int = _mansLayer.numChildren; i < n; i++)
				{
					_mansLayer.getChildAt(i).rotationZ = manRotation;
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
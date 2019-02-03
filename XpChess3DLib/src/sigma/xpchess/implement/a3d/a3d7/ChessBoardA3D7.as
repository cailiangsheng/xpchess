package sigma.xpchess.implement.a3d.a3d7
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import alternativa.engine3d.core.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.core.Sorting;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Plane;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardPool;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManPos;

	internal class ChessBoardA3D7 extends Object3DContainer implements IChessBoard
	{
		public static var BoardHeight: Number = 15;
		private var _boardType: int = -1;
		private var _mansLayer: Object3DContainer;
		protected var _boardRotation: Number = 0;

		public function ChessBoardA3D7(boardType: int)
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
				var chessMan: ChessManA3D7 = _mansLayer.getChildAt(i) as ChessManA3D7;
				if (chessMan != null)
				{
					_mansLayer.removeChild(chessMan);
					ChessPool.freeChessMan(chessMan);
				}
			}
		}
		
		public function addChessMan(man: IChessMan): void
		{
			var manObject: Object3D = man as Object3D;
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
			_mansLayer = new Object3DContainer();
			_mansLayer.z = -BoardHeight / 2;
			_mansLayer.mouseEnabled = false;
			_mansLayer.mouseChildren = false;
			this.addChild(_mansLayer);
			
			reset();
		}
		
		private function createWithPlanes(boardSprite: Sprite): void
		{
			//board plane
			boardSprite.x = boardSprite.width / 2;
			boardSprite.y = boardSprite.height / 2;
			var bmpData: BitmapData = new BitmapData(boardSprite.width, boardSprite.height, true, 0);
			bmpData.draw(boardSprite, boardSprite.transform.matrix);
			
			var topMaterial: TextureMaterial = new TextureMaterial(bmpData);
			var topPlane: Plane = new Plane(boardSprite.width, boardSprite.height, 1, 1, false);
			topPlane.setMaterialToAllFaces(topMaterial);
			topPlane.rotationX = Math.PI;
			topPlane.z = -BoardHeight / 2;
			
			//bottom plane
			var bmpData2: BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0xffaaaaaa);
			var rect: Rectangle = new Rectangle(0, 0, bmpData.width, bmpData.height);
			bmpData2.copyChannel(bmpData, rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var bottomMaterial: TextureMaterial = new TextureMaterial(bmpData2);
			var bottomPlane: Plane = new Plane(boardSprite.width, boardSprite.height, 1, 1, false, true);
			bottomPlane.setMaterialToAllFaces(bottomMaterial);
			bottomPlane.z = BoardHeight / 2;
			bottomPlane.rotationX = Math.PI;
			
			//add planes
			topPlane.sorting = Sorting.DYNAMIC_BSP;
			bottomPlane.sorting = Sorting.DYNAMIC_BSP;
			this.addChild(topPlane);
			this.addChild(bottomPlane);
			
			//side planes
			var sideMaterial: FillMaterial = new FillMaterial(0x555555);
			var cornerArray: Array = ChessBoardUtil.getCorner(_boardType);
			var n: int = cornerArray.length;
			for (var i: int = 0; i < n; i++)
			{
				var j: int = (i + 1) % n;
				var dx: Number = cornerArray[i].x - cornerArray[j].x;
				var dy: Number = cornerArray[i].y - cornerArray[j].y;
				var w: Number = Math.sqrt(dx * dx + dy * dy);
				var sidePlane: Plane = new Plane(w, BoardHeight, 1, 1, false);
				sidePlane.setMaterialToAllFaces(sideMaterial);
				sidePlane.x = (cornerArray[i].x + cornerArray[j].x) / 2;
				sidePlane.y = (cornerArray[i].y + cornerArray[j].y) / 2;
				sidePlane.rotationX = Math.PI / 2;
				sidePlane.rotationZ = Math.atan2(dy, dx);
				sidePlane.sorting = Sorting.DYNAMIC_BSP;
				this.addChild(sidePlane);
			}
			
			//add listener
			this.addEventListener(MouseEvent3D.CLICK, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: MouseEvent3D): void
		{
			var boardPlane: Plane = Plane(e.target);
			var data: RayIntersectionData = boardPlane.intersectRay(e.localOrigin, e.localDirection);
			if (data)
			{
				var localX: Number = data.point.x;
				var localY: Number = -data.point.y;
				this.dispatchEvent(new XpChessBoardEvent(XpChessBoardEvent.CLICK_BOARD, boardType, localX, localY));
			}
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
				
				var degrees: Number = value - _boardRotation;
				var mat: Matrix3D = this.matrix.clone();
				mat.prependRotation(degrees, Vector3D.Z_AXIS);
				this.matrix = mat;
				
				_boardRotation = value;
			}
		}
		
		public function get boardRotation(): Number
		{
			return _boardRotation;
		}

		private static function manAngle(boardAngle: Number): Number
		{
			return Math.PI - boardAngle * Math.PI / 180;
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
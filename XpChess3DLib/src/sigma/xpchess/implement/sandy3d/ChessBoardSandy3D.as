package sigma.xpchess.implement.sandy3d
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sandy.core.data.Matrix4;
	import sandy.core.data.Point3D;
	import sandy.core.scenegraph.TransformGroup;
	import sandy.events.Shape3DEvent;
	import sandy.materials.Appearance;
	import sandy.materials.BitmapMaterial;
	import sandy.materials.ColorMaterial;
	import sandy.primitive.Cylinder;
	import sandy.primitive.Plane3D;
	
	import sigma.xpchess.event.XpChessBoardEvent;
	import sigma.xpchess.implement.common.ChessPool;
	import sigma.xpchess.implement.common.IChessBoard;
	import sigma.xpchess.implement.common.IChessMan;
	import sigma.xpchess.util.ChessBoardPool;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessManPos;

	internal class ChessBoardSandy3D extends TransformGroup implements IChessBoard
	{
		public static var BoardHeight: Number = 15;
		private var _boardType: int = -1;
		private var _mansLayer: TransformGroup;
		protected var _boardRotation: Number = 0;
		
		private var _eventDispatcher: IEventDispatcher;

		public function ChessBoardSandy3D(boardType: int)
		{
			init(boardType);
			
			_eventDispatcher = new EventDispatcher();
		}
		
		public function get eventDispatcher(): IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		//--------------------------------------------------------------
		public function get boardType(): int
		{
			return _boardType;
		}
		
		public function reset(): void
		{
			this.boardRotation = 0;
			this.rotateX = 0;
			this.rotateY = 0;
			this.rotateZ = 0;
			this.x = 0;
			this.y = 0;
			this.z = 0;
		}
		
		//--------------------------------------------------------------
		public function clearChessMans(): void
		{
			for (var i: int = _mansLayer.children.length - 1; i >= 0; --i)
			{
				var chessMan: ChessManSandy3D = _mansLayer.children[i] as ChessManSandy3D;
				if (chessMan != null)
				{
					_mansLayer.removeChildByName(chessMan.name);
					ChessPool.freeChessMan(chessMan);
				}
			}
		}
		
		public function addChessMan(man: IChessMan): void
		{
			var manObject: TransformGroup = man as TransformGroup;
			_mansLayer.addChild(manObject);
			manObject.rotateZ = manAngle(_boardRotation);
			
			manObject.useSingleContainer = false;
			manObject.enableEvents = true;
			manObject.enableInteractivity = false;
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
			_mansLayer = new TransformGroup();
			_mansLayer.z = -BoardHeight / 2;
//			_mansLayer.rotateZ = 180;
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
			
			var topMaterial: BitmapMaterial = new BitmapMaterial(bmpData);
			var topPlane: Plane3D = new Plane3D(null, bmpData.height, bmpData.width, bmpData.height / 50, bmpData.width / 50);
			topPlane.appearance = new Appearance(topMaterial);
			topPlane.z = -BoardHeight / 2;
			
			//bottom plane
			var bmpData2: BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0xffaaaaaa);
			var rect: Rectangle = new Rectangle(0, 0, bmpData.width, bmpData.height);
			bmpData2.copyChannel(bmpData, rect, new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			
			var bottomMaterial: BitmapMaterial = new BitmapMaterial(bmpData2);
			var bottomPlane: Plane3D = new Plane3D(null, bmpData2.height, bmpData2.width, bmpData2.height / 50, bmpData2.width / 50);
			bottomPlane.appearance = new Appearance(bottomMaterial);
			bottomPlane.z = BoardHeight / 2;
			bottomPlane.rotateX = 180;
			
			//add planes
			this.addChild(topPlane);
			
			var sidesLayer: TransformGroup = new TransformGroup();
			sidesLayer.addChild(bottomPlane);
			sidesLayer.rotateZ = 180;
			this.addChild(sidesLayer);
			
			//side planes
			var sideAppearance: Appearance = new Appearance(new ColorMaterial(0x555555));
			var cornerArray: Array = ChessBoardUtil.getCorner(_boardType);
			var n: int = cornerArray.length;
			for (var i: int = 0; i < n; i++)
			{
				var j: int = (i + 1) % n;
				var dx: Number = cornerArray[i].x - cornerArray[j].x;
				var dy: Number = cornerArray[i].y - cornerArray[j].y;
				var w: Number = Math.sqrt(dx * dx + dy * dy);
				var sidePlane: Plane3D = new Plane3D(null, BoardHeight, w, 1, 1);
				sidePlane.appearance = sideAppearance;
				sidePlane.x = (cornerArray[i].x + cornerArray[j].x) / 2;
				sidePlane.y = (cornerArray[i].y + cornerArray[j].y) / 2;
				sidePlane.rotateX = 90;
				sidePlane.rotateZ = Math.atan2(dy, dx) * 180 / Math.PI + 180;
				sidesLayer.addChild(sidePlane);
			}
			
			//add listener
			this.useSingleContainer = false;
			this.enableEvents = true;
			this.enableInteractivity = false;
			this.broadcaster.addEventListener(MouseEvent.CLICK, onChessBoardClick);
		}
		
		private function onChessBoardClick(e: Shape3DEvent): void
		{
			var localX: Number = 0;
			var localY: Number = 0;
			if (e.shape is Cylinder)
			{
				var man: ChessManSandy3D = e.shape.parent as ChessManSandy3D;
				localX = man.x;
				localY = -man.y;
			}
			else if (e.shape is Plane3D)
			{
				localX = e.point.x;
				localY = -e.point.y;
			}
			this.eventDispatcher.dispatchEvent(new XpChessBoardEvent(XpChessBoardEvent.CLICK_BOARD, boardType, localX, localY));
		}
		
		//--------------------------------------------------------------
		public function set boardRotation(value: Number): void
		{
			if (_boardRotation != value)
			{
				var manRotation: Number = manAngle(value);
				for (var i: int = 0, n: int = _mansLayer.children.length; i < n; i++)
				{
					_mansLayer.children[i].rotateZ = manRotation;
				}
				
				var degrees: Number = value - _boardRotation;
				
				this.updateTransform();
				var mat: Matrix4 = this.matrix.clone();
				var zAxis: Point3D = new Point3D(0, 0, 1);
				mat.transform(zAxis);
				mat.axisRotationPoint3D(zAxis, -degrees);
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
			return 180 + boardAngle;
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
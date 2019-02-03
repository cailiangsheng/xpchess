package sigma.xpchess.implement.a3d.a3d5
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.MovieClipMaterial;
	import alternativa.engine3d.materials.SpriteMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.WireMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Cone;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	
	import sigma.xpchess.define.IXpChessController;
	import sigma.xpchess.define.IXpChessModel;
	import sigma.xpchess.define.IXpChessView;
	import sigma.xpchess.implement.common.ViewTransformerBase;
	import sigma.xpchess.implement.common.XpChessViewHelper;
	import sigma.xpchess.util.ChessBoardUtil;
	import sigma.xpchess.util.ChessMan;
	import sigma.xpchess.util.ChessManData;
	import sigma.xpchess.util.ChessManPool;
	import sigma.xpchess.util.ChessManPos;
	import sigma.xpchess.util.ChessManUtil;
	
	public class XpChessViewA3D5 extends Sprite implements IXpChessView
	{
		private var _helper: XpChessViewHelper = null;
		private var _transformer: ViewTransformerBase;
		private var _view: View;
		private var _scene: Scene3D;
		
		public function XpChessViewA3D5()
		{
			super();
			
			setupChessBoard();
			setupView();
			
			_transformer = new ViewTransformerBase(this);//, 900, 45);
			_helper = new XpChessViewHelper(this, false);
		}
		
		//--------------------------------------------------------------
		private var chessBoard: Object3D = new Object3D();
		
		private function setupChessBoard(): void
		{
			var sprite: MovieClip = new MovieClip();
			var shape: Sprite = new ChessBoard2();
			shape.x = int(shape.width / 2);
			shape.y = int(shape.height / 2);
			sprite.addChild(shape);
			var bmpData: BitmapData = new BitmapData(sprite.width, sprite.height, true);
			bmpData.draw(sprite);
			var boardMaterial: TextureMaterial = new TextureMaterial(new Texture(bmpData));
//			var boardMaterial: MovieClipMaterial = new MovieClipMaterial(sprite, shape.width, shape.height);
			var backMaterial: FillMaterial = new FillMaterial(0xaaaaaa);
			var sideMaterial: FillMaterial = new FillMaterial(0x555555);
			
			var board: Box = new Box(shape.width, shape.height, 5, 3, 3, 1, false, true);
			board.cloneMaterialToAllSurfaces(sideMaterial);
			board.setMaterialToSurface(backMaterial, "top");
			board.setMaterialToSurface(boardMaterial, "bottom");
			chessBoard.addChild(board);
			chessBoard.rotationZ = Math.PI;
		}
		
		private function setupView(): void
		{
			_scene = new Scene3D();
			_scene.root = new Object3D();
			_scene.root.addChild(chessBoard);
			
			var camera: Camera3D = new Camera3D();
			camera.z = -1000;
			_scene.root.addChild(camera);
			
			_view = new View();
			_view.camera = camera;
			this.addChild(_view);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e: Event): void
		{
			_transformer.transform(chessBoard);
			_scene.calculate();
		}
		
		//--------------------------------------------------------------
		public function init(model: IXpChessModel, controller: IXpChessController): void
		{
			_helper.init(model, controller);
		}
		
		public function clearChessMans(): void
		{
		}
		
		public function loadChessMans(chessMans: Vector.<ChessManData>): void
		{
			//return;
//			var man: ChessManData = chessMans[0];
			clearChessMans();
			for each (var man: ChessManData in chessMans)
			{
				var manColor: uint = ChessManUtil.getColor(man.belong);
				var manLabel: String = ChessManUtil.getLabel(man.type, manColor == ChessManUtil.RED);
				var manPoint: Point = ChessBoardUtil.getPoint(gameType, man.pos.z, man.pos.y, man.pos.x);
				var chessMan: ChessMan = ChessManPool.getChessMan(manLabel, manColor);
				
				var sprite: MovieClip = new MovieClip();
				chessMan.x = chessMan.width / 2;
				chessMan.y = chessMan.height / 2;
				sprite.addChild(chessMan);
//				var bmpData: BitmapData = new BitmapData(sprite.width, sprite.height, true);
//				bmpData.draw(sprite);
//				var topMaterial: TextureMaterial = new TextureMaterial(new Texture(bmpData));
				var topMaterial: MovieClipMaterial = new MovieClipMaterial(sprite, sprite.width, sprite.height);
				
				var ringMaterial: FillMaterial = new FillMaterial(chessMan.color);
				var cylinder: Cone = new Cone(15, chessMan.width / 2, chessMan.width / 2, 1, 15, false, true);
				cylinder.cloneMaterialToAllSurfaces(ringMaterial);
				cylinder.setMaterialToSurface(topMaterial, "bottom");
				
				cylinder.x = manPoint.x;
				cylinder.y = manPoint.y;
				cylinder.z = -((15 + 5) / 2);
				chessBoard.addChild(cylinder);
			}
		}
		
		public function onContainerResize(containerWidth: Number, containerHeight: Number): void
		{
			_view.width = containerWidth;
			_view.height = containerHeight;
		}
		
		//--------------------------------------------------------------
		public function get autoRotate(): Boolean
		{
			return false;
		}
		
		public function set autoRotate(value: Boolean): void
		{
			
		}
		
		public function get boardRotation(): Number
		{
			return 0;
		}
		
		public function set boardRotation(value: Number): void
		{
		}
		
		public function get gameType(): int
		{
			return 2;
		}
		
		public function set gameType(value: int): void
		{
		}
		
		public function get view3d(): Boolean
		{
			return true;
		}
		
		public function set view3d(value: Boolean): void
		{
		}
		
		public function get autoResize(): Boolean
		{
			return false;
		}
		
		public function set autoResize(value: Boolean): void
		{
		}
		
		public function printMoveFrom(pos: ChessManPos): void
		{
			
		}
		
		public function printMoveTo(pos: ChessManPos): void
		{
		}
		
		public function clearPrint(): void
		{
		}
	}
}
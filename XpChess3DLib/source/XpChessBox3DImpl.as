// ActionScript file

import flash.display.DisplayObject;

import mx.core.mx_internal;
import mx.events.ResizeEvent;

import sigma.xpchess.define.IXpChessController;
import sigma.xpchess.define.IXpChessModel;
import sigma.xpchess.define.IXpChessView;
import sigma.xpchess.implement.common.XpChessController;
import sigma.xpchess.implement.common.XpChessModel;
import sigma.xpchess.implement.a3d.a3d5.XpChessViewA3D5;
//import sigma.xpchess.implement.a3d.a3d5.XpChessViewRotateA3D5;
import sigma.xpchess.implement.a3d.a3d7.XpChessViewRotateA3D7;
import sigma.xpchess.implement.a3d.a3d8.XpChessViewRotateA3D8;
import sigma.xpchess.implement.away3d.away3d3.XpChessViewRotateAway3D3;
import sigma.xpchess.implement.away3d.away3d4.XpChessViewRotateAway3D4;
import sigma.xpchess.implement.pv3d.XpChessViewRotatePV3D;
import sigma.xpchess.implement.sandy3d.XpChessViewRotateSandy3D;
import sigma.xpchess.xpchess_internal;

use namespace xpchess_internal;

//-----------------------------------------------------------
private var _model: IXpChessModel = new XpChessModel();
private var _controller: IXpChessController = new XpChessController();

public function get gameType(): int
{
	return _xpChessView.gameType;
}

public function set gameType(type: int): void
{
	callLater(function(): void
	{
		try
		{
			_model.startGame(type);
		}
		catch (e: Error)
		{
			trace(e.message);
		}
	});
}

xpchess_internal function get model(): IXpChessModel
{
	return _model;
}

//-----------------------------------------------------------
private var _xpChessView: IXpChessView = //new XpChessViewA3D5();			//bad: slowest (too hard to appear)
										//new XpChessViewRotateSandy3D();	//bad: slow and fucking event-system
										//new XpChessViewRotatePV3D();		//bad: faces missing and crash when mouse interacting
										//new XpChessViewRotateAway3D3();	//bad: little faces missing and no localPosition of MouseEvent3D
										//new XpChessViewRotateA3D8();		//bad: some plane meshes missing
										new XpChessViewRotateA3D7();		//good: no faces missing and fastest flash3d !!!
										//new XpChessViewRotateAway3D4();		//good: stage3d !!!

private var _autoResize: Boolean = true;

private function init(): void
{
	container.addChild(_xpChessView as DisplayObject);
	this.addEventListener(Event.RESIZE, onResize);
	
	_xpChessView.init(_model, _controller);
}

//-----------------------------------------------------------
public function get stage3d(): Boolean
{
	return _xpChessView.stage3d;
}

public function get view3d(): Boolean
{
	return _xpChessView.view3d;
}

public function set view3d(value: Boolean): void
{
	_xpChessView.view3d = value;
}

public function set boardRotation(r: Number): void
{
	_xpChessView.boardRotation = r;
}

public function set autoRotate(value: Boolean): void
{
	_xpChessView.autoRotate = value;
}

public function get boardRotation(): Number
{
	return _xpChessView.boardRotation;
}

public function get autoRotate(): Boolean
{
	return _xpChessView.autoRotate;
}

//-----------------------------------------------------------
public function set autoResize(value: Boolean): void
{
	if (_autoResize != value)
	{
		_autoResize = value;
		onResize(null);
	}
}

public function get autoResize(): Boolean
{
	return _autoResize && !view3d;
}

private function onResize(e: Event): void
{
	if (_autoResize && this.stage != null)
		_xpChessView.onContainerResize(this.width, this.height);
}
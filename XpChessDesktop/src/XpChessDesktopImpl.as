import flash.events.MouseEvent;

import mx.core.UIComponent;

import sigma.xpchess.component.XpChessGame;

protected function init(): void
{
	initWindow();
	initStatusBar();
	enableFullScreen();
}

private function initWindow(): void
{
	this.maximize();
	this.title = this.applicationID;
	this.setStyle("paddingTop", 0);
	this.setStyle("paddingBottom", 0);
	this.setStyle("paddingLeft", 0);
	this.setStyle("paddingRight", 0);
}

private function initStatusBar(): void
{
	this.statusText.setStyle("fontSize", 12);
	this.statusText.setStyle("color", 0x000000);
	this.statusText.setStyle("textAlign", "center");
	this.status = "棋盘变换: Q-逆旋 E-顺旋 A-左翻 D-右翻 W-上翻 S-下翻 R-推远 F-拉近 Z-重置  "
		+ "屏幕控制: X-全屏切换 C-透明切换 V-全屏透明切换 Esc-全屏退出";
}

private function get statusText(): UIComponent
{
	return this.statusBar;
}

private function enableFullScreen(): void
{
	if (this.transparent)
		this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	else
		throw new Error("transparent in AIR-app.xml should be set to true");
}

protected function get xpchess(): XpChessGame
{
	return this.getElementAt(0) as XpChessGame;
}

private function onAddedToStage(e: Event): void
{
	xpchess.xpChessBox.doubleClickEnabled = true;
	xpchess.xpChessBox.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
	this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
	this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
}

private function onDoubleClick(e: MouseEvent): void
{
	toggleWidget();
}

private function onKeyDown(e: KeyboardEvent): void
{
	switch (e.keyCode)
	{
		case Keyboard.X:
			toggleFullScreen();
			break;
		case Keyboard.C:
			toggleTransparent();
			break;
		case Keyboard.V:
			toggleWidget();
			break;
		case Keyboard.ESCAPE:
			if (isFullScreen)
				toggleFullScreen();
			break;
		default:
			trace("Mis-hanlded Key:", e.charCode);
			return;
	}
	if (e.cancelable)
		e.preventDefault();
}

private function onFullScreen(e: FullScreenEvent): void
{
	var showBars: Boolean = !e.fullScreen;
	this.setStyle("headerHeight", showBars ? 25 : 0);
	this.showStatusBar = xpchess.showController = showBars;
}

private function toggleFullScreen(): void
{
	if (!this.isTransparent)
	{
		this.isFullScreen = !this.isFullScreen;
	}
	else
		toggleWidget();
}

private function toggleTransparent(): void
{
	if (isFullScreen)
	{
		isTransparent = !isTransparent;
	}
	else
		toggleWidget();
}

private function toggleWidget(): void
{
	if (!isFullScreen || !isTransparent)
	{
		isFullScreen = true;
		isTransparent = true;
	}
	else
	{
		isFullScreen = false;
		isTransparent = false;
	}
}

private function get isFullScreen(): Boolean
{
	return this.stage.displayState != StageDisplayState.NORMAL;
}

private function set isFullScreen(value: Boolean): void
{
	this.stage.displayState = value ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
}

private function get isTransparent(): Boolean
{
	return !this.getStyle("backgroundAlpha");
}

private function set isTransparent(value: Boolean): void
{
	value = value || xpchess.stage3d;
	this.setStyle("backgroundAlpha", value ? 0 : 1);
}
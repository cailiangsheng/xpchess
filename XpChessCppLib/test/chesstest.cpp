#include "../src/chessgame.h"

int main()
{
	kChessGame *game = new kChessGame();
	game->Start(2);
	game->Show();
	delete game;
	return 0;
}

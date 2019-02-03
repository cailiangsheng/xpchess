/*
 * sharedlib.cpp
 *
 *  Created on: 2011-1-31
 *      Author: sigma
 */

#include "../src/chessbase.h"
#include "../src/chessgame.h"

//extern "C" int ccc = 123;

extern "C" kChessBase *create()
{
	return new kChessGame();
}

extern "C" void destroy(kChessBase *game)
{
	delete game;
}

//extern "C"
//{
//	extern kChessBase *create()
//	{
//		return new kChessGame();
//	}
//
//	extern void destroy(kChessBase *game)
//	{
//		delete game;
//	}
//}

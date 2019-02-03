#ifndef CHESSGAME_H_
#define CHESSGAME_H_

#include "chessbase.h"

//
//#define SHUAI	1
//#define SHI		2
//#define XIANG	3
//#define JU		4
//#define MA		5
//#define PAO		6
//#define BING	7
//
//
//typedef struct
//{
//	int x;		/// 横向；(0-8)
//	int y;		/// 竖向；(0-4)
//	int color;	/// 颜色，表示位置所属方的颜色；
//}Position;
//
//typedef struct
//{
//	int val;	/// 1：帅（将），2：士（仕），3：象（相），4：车，5：马，6：炮，7：兵（卒）；
//	int color;	/// 0：黑，1：红，2：蓝，3：绿；表示棋子所属方的颜色；
//	Position pos;
//}ChessMan;

typedef struct  
{
	ChessMan* piece[20][20];	/// 设置大一点，因为临时棋盘也可以用这个数据；
	int	nX;
	int nY;
}ChessBoard_Half;

class kChessGame : public kChessBase
{
public:
//	ChessMan* m_pChessMans;
	kChessGame();
	virtual ~kChessGame();
	virtual bool Start(int n);	/// 必须设置n，表示玩家个数；（2，3，4）；
	virtual bool Stop();	/// no write over;
	virtual bool Move(Position pos1, Position pos2);	/// 表示从pos1移动棋子到pos2；先调用判断函数，然后调用move_done函数移动；
	virtual int  ScanChessBoard();	/// 返回棋子数，同时给静态数组赋值。
	virtual bool Show();
	virtual bool Regret();
	virtual int	 GetCurPlayer();	/// 返回轮到当前的玩家走棋。
	virtual bool GiveUp(int color);	/// 认输调用。
private:
	int m_nPlayerNum;	/// 玩家数。
	int m_nCurPlayer;	/// 当前玩家。
	int m_nX;	/// 棋盘横向大小。
	int m_nY;	/// 棋盘纵向大小。
	bool* m_pPlayerExist;	/// true：玩家还存在；false：此颜色的玩家挂啦。
	bool  m_bGameOver;
	ChessMan** m_ppAllChessMans;	/// 保存所有棋子对象的引用。为释放内存保存。
	int		   m_nAllChessManNums; /// 初始化棋盘时，所创建的棋子数。
	ChessBoard_Half* m_pBoard;		/// 
	ChessBoard_Half* m_pTempBoard;	///

	Position m_tPosFrom;	/// 替代位置；因为用了临时棋盘，所以移动棋子的位置的表示也要改变一下。
	Position m_tPosTo;		/// 替代位置；因为用了临时棋盘，所以移动棋子的位置的表示也要改变一下。

	//////////////////////////////////////////////////////////////////////////
	bool WriteLog(const char* str);	/// 输出，可以写入文件，或者标准输出；
	bool Move_done(Position pos1, Position pos2);	/// 要先判断好，是否能这样移动；
	bool Init();
	bool InitBoard(int color);	/// 初始化某一颜色的半边棋盘；
	bool CreateTmpBoard(Position pos1, Position pos2);	/// 构造一个临时棋盘；为了好控制走棋；
	bool SetChessMan(ChessMan** pChessM, int color, int val, int x, int y);	/// 设置一颗棋子；
	bool SetNextPlayerColor();		/// 设置玩家颜色。当成功走棋后.
	bool ChangeColor(int fromColor, int toColor);	/// 改变棋子颜色，当其老王被吃掉后；
	bool ReleaseBuf();	/// 游戏退出时调用释放buf。

	//////////////////////////////////////////////////////////////////////////
	/// 下面的函数都是产生的替代数据进行操作。
	bool Move_shuai();
	bool Move_shi();
	bool Move_xiang();
	bool Move_ju();
	bool Move_ma();
	bool Move_pao();
	bool Move_bing();

	//////////////////////////////////////////////////////////////////////////
	bool isNeighbor();
	bool isOnLine();
	int	 NChessManInSeg();	/// 两位置之间的棋子数，不包含两端；
};

#endif

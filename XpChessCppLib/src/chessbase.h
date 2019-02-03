#ifndef CHESSBASE_H_
#define CHESSBASE_H_

#define SHUAI	1
#define SHI		2
#define XIANG	3
#define JU		4
#define MA		5
#define PAO		6
#define BING	7

typedef struct 
{
	int x;		/// 横向；(0-8)
	int y;		/// 竖向；(0-4)
	int color;	/// 颜色，表示位置所属方的颜色；
}Position;

typedef struct
{
	int val;	/// 1：帅（将），2：士（仕），3：象（相），4：车，5：马，6：炮，7：兵（卒）；
	int color;	/// 0：黑，1：红，2：蓝，3：绿；表示棋子所属方的颜色；
	Position pos;
}ChessMan;

class kChessBase
{
public:
	virtual ~kChessBase() {}

	ChessMan* m_pChessMans;
	virtual bool Start(int n) = 0;	/// 必须设置n，表示玩家个数；（2，3，4）；
	virtual bool Stop() = 0;	/// no write over;
	virtual bool Move(Position pos1, Position pos2) = 0;	/// 表示从pos1移动棋子到pos2；先调用判断函数，然后调用move_done函数移动；
	virtual int  ScanChessBoard() = 0;	/// 返回棋子数，同时给静态数组赋值。
	virtual bool Show() = 0;
	virtual bool Regret() = 0;
	virtual int	 GetCurPlayer() = 0;	/// 返回轮到当前的玩家走棋。
	virtual bool GiveUp(int color) = 0;	/// 认输调用。
};

#endif

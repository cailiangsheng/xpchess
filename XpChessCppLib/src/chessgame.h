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
//	int x;		/// ����(0-8)
//	int y;		/// ����(0-4)
//	int color;	/// ��ɫ����ʾλ������������ɫ��
//}Position;
//
//typedef struct
//{
//	int val;	/// 1��˧��������2��ʿ���ˣ���3�����ࣩ��4������5����6���ڣ�7�������䣩��
//	int color;	/// 0���ڣ�1���죬2������3���̣���ʾ��������������ɫ��
//	Position pos;
//}ChessMan;

typedef struct  
{
	ChessMan* piece[20][20];	/// ���ô�һ�㣬��Ϊ��ʱ����Ҳ������������ݣ�
	int	nX;
	int nY;
}ChessBoard_Half;

class kChessGame : public kChessBase
{
public:
//	ChessMan* m_pChessMans;
	kChessGame();
	virtual ~kChessGame();
	virtual bool Start(int n);	/// ��������n����ʾ��Ҹ�������2��3��4����
	virtual bool Stop();	/// no write over;
	virtual bool Move(Position pos1, Position pos2);	/// ��ʾ��pos1�ƶ����ӵ�pos2���ȵ����жϺ�����Ȼ�����move_done�����ƶ���
	virtual int  ScanChessBoard();	/// ������������ͬʱ����̬���鸳ֵ��
	virtual bool Show();
	virtual bool Regret();
	virtual int	 GetCurPlayer();	/// �����ֵ���ǰ��������塣
	virtual bool GiveUp(int color);	/// ������á�
private:
	int m_nPlayerNum;	/// �������
	int m_nCurPlayer;	/// ��ǰ��ҡ�
	int m_nX;	/// ���̺����С��
	int m_nY;	/// ���������С��
	bool* m_pPlayerExist;	/// true����һ����ڣ�false������ɫ����ҹ�����
	bool  m_bGameOver;
	ChessMan** m_ppAllChessMans;	/// �����������Ӷ�������á�Ϊ�ͷ��ڴ汣�档
	int		   m_nAllChessManNums; /// ��ʼ������ʱ������������������
	ChessBoard_Half* m_pBoard;		/// 
	ChessBoard_Half* m_pTempBoard;	///

	Position m_tPosFrom;	/// ���λ�ã���Ϊ������ʱ���̣������ƶ����ӵ�λ�õı�ʾҲҪ�ı�һ�¡�
	Position m_tPosTo;		/// ���λ�ã���Ϊ������ʱ���̣������ƶ����ӵ�λ�õı�ʾҲҪ�ı�һ�¡�

	//////////////////////////////////////////////////////////////////////////
	bool WriteLog(const char* str);	/// ���������д���ļ������߱�׼�����
	bool Move_done(Position pos1, Position pos2);	/// Ҫ���жϺã��Ƿ��������ƶ���
	bool Init();
	bool InitBoard(int color);	/// ��ʼ��ĳһ��ɫ�İ�����̣�
	bool CreateTmpBoard(Position pos1, Position pos2);	/// ����һ����ʱ���̣�Ϊ�˺ÿ������壻
	bool SetChessMan(ChessMan** pChessM, int color, int val, int x, int y);	/// ����һ�����ӣ�
	bool SetNextPlayerColor();		/// ���������ɫ�����ɹ������.
	bool ChangeColor(int fromColor, int toColor);	/// �ı�������ɫ�������������Ե���
	bool ReleaseBuf();	/// ��Ϸ�˳�ʱ�����ͷ�buf��

	//////////////////////////////////////////////////////////////////////////
	/// ����ĺ������ǲ�����������ݽ��в�����
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
	int	 NChessManInSeg();	/// ��λ��֮��������������������ˣ�
};

#endif

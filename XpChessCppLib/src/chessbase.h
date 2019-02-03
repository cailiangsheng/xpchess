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
	int x;		/// ����(0-8)
	int y;		/// ����(0-4)
	int color;	/// ��ɫ����ʾλ������������ɫ��
}Position;

typedef struct
{
	int val;	/// 1��˧��������2��ʿ���ˣ���3�����ࣩ��4������5����6���ڣ�7�������䣩��
	int color;	/// 0���ڣ�1���죬2������3���̣���ʾ��������������ɫ��
	Position pos;
}ChessMan;

class kChessBase
{
public:
	virtual ~kChessBase() {}

	ChessMan* m_pChessMans;
	virtual bool Start(int n) = 0;	/// ��������n����ʾ��Ҹ�������2��3��4����
	virtual bool Stop() = 0;	/// no write over;
	virtual bool Move(Position pos1, Position pos2) = 0;	/// ��ʾ��pos1�ƶ����ӵ�pos2���ȵ����жϺ�����Ȼ�����move_done�����ƶ���
	virtual int  ScanChessBoard() = 0;	/// ������������ͬʱ����̬���鸳ֵ��
	virtual bool Show() = 0;
	virtual bool Regret() = 0;
	virtual int	 GetCurPlayer() = 0;	/// �����ֵ���ǰ��������塣
	virtual bool GiveUp(int color) = 0;	/// ������á�
};

#endif

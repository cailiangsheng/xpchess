
#include <stdio.h>
#include <assert.h>
#include "chessgame.h"

int DistanceInt(int a, int b);	/// ����������֮��ľ���ֵ��

kChessGame::kChessGame()
{
	m_nPlayerNum = -1; 
	m_nCurPlayer = 1;
	m_pBoard = NULL;
	m_nX = 9; m_nY = 5;
	m_pTempBoard = NULL;
	m_pChessMans = NULL;
	m_pPlayerExist = NULL;
	m_ppAllChessMans = NULL;
	m_bGameOver = true;
}

kChessGame::~kChessGame()
{
	ReleaseBuf();
}

bool kChessGame::ReleaseBuf()
{
	if (m_pChessMans)
	{
		delete m_pChessMans;
		m_pChessMans = NULL;
	}
	if (m_pTempBoard)
	{
		delete m_pTempBoard;
		m_pTempBoard = NULL;
	}
	if (*m_ppAllChessMans)
	{	/// release all chessmans;
		delete *m_ppAllChessMans;
		m_ppAllChessMans = NULL;	
	}
	if (m_pBoard)
	{
		delete m_pBoard;
		m_pBoard = NULL;
	}
	if (m_pPlayerExist)
	{
		delete m_pPlayerExist;
		m_pPlayerExist = NULL;
	}
	return true;
}

bool kChessGame::Start(int n)
{
	m_nPlayerNum = n;
	m_bGameOver = false;
	m_pTempBoard = new ChessBoard_Half;
	assert(m_pTempBoard);
	m_pChessMans = new ChessMan[16 * n];
	assert(m_pChessMans);
	m_ppAllChessMans = new ChessMan*[16 * n];
	assert(m_ppAllChessMans);
	Init();
	return true;
}

bool kChessGame::Stop()
{
	ReleaseBuf();
	return true;
}

bool kChessGame::Regret()
{
	return false;
}

int kChessGame::GetCurPlayer()
{
	return m_nCurPlayer;
}

bool kChessGame::GiveUp(int color)
{
	int i = 0;
	int j = 0;
	int k = 0;
	for (i = 0; i < m_nPlayerNum; ++i)
	{
		for (j = 0; j < m_nX; ++j)
		{
			for (k = 0; k < m_nY; ++k)
			{
				if (m_pBoard[i].piece[j][k] &&
					m_pBoard[i].piece[j][k]->color == color)
				{
					m_pBoard[i].piece[j][k] = NULL;
				}
			}
		}
	}
	m_pPlayerExist[color] = false;
	if (color == m_nCurPlayer)
	{
		SetNextPlayerColor();
	}
	return true;
}

bool kChessGame::Move(Position pos1, Position pos2)
{
	FILE *f = fopen("c:\\move_step.txt", "a");
	fprintf(f, "pos_move_from: color = %d, x = %d, y = %d;\n", pos1.color, pos1.x, pos1.y);
	fprintf(f, "pos_move_to: color = %d, x = %d, y = %d.\n\n", pos2.color, pos2.x, pos2.y);
	fclose(f);
	if (pos1.color >= m_nPlayerNum || pos1.color < 0 ||
		pos1.x < 0 || pos1.x >= m_nX ||
		pos1.y < 0 || pos1.y >= m_nY)
	{
		WriteLog("ԭʼλ������\n");
		return false;
	}
	if (pos2.color >= m_nPlayerNum || pos2.color < 0 ||
		pos2.x < 0 || pos2.x >= m_nX ||
		pos2.y < 0 || pos2.y >= m_nY)
	{
		WriteLog("Ŀ��λ������\n");
		return false;
	}
	if (pos1.color == pos2.color && pos1.x == pos2.x && pos1.y == pos2.y)
	{
		WriteLog("�ƶ�ǰ��λ����ͬ���޷��ƶ���\n");
		return false;
	}
	if (NULL == m_pBoard[pos1.color].piece[pos1.x][pos1.y])	/// ԭʼλ��û��ʱ��
	{
		WriteLog("ԭʼλ�����ӣ�����\n");
		return false;
	}
	if (m_nCurPlayer != m_pBoard[pos1.color].piece[pos1.x][pos1.y]->color)	/// ԭʼλ��û��ʱ��
	{
		WriteLog("���������壬�����������ӡ�\n");
		return false;
	}
	if (m_pBoard[pos2.color].piece[pos2.x][pos2.y] &&
		m_pBoard[pos1.color].piece[pos1.x][pos1.y]->color == 
		m_pBoard[pos2.color].piece[pos2.x][pos2.y]->color)	/// ���ܳ��Լ����ӣ�
	{
		WriteLog("Ŀ��λ�����Լ������ӣ�����\n");
		return false;
	}
	if (!CreateTmpBoard(pos1, pos2))
	{
		WriteLog("ԭλ����Ŀ��λ�ò���ͬһ������£���������������\n");
		return false;
	}
	bool bMove = false;
	switch(m_pBoard[pos1.color].piece[pos1.x][pos1.y]->val)
	{
	case SHUAI:
		bMove = Move_shuai();
		break;
	case SHI:
		bMove = Move_shi();
		break;
	case XIANG:
		bMove = Move_xiang();
	    break;
	case JU:
		bMove = Move_ju();
	    break;
	case MA:
		bMove = Move_ma();
		break;
	case PAO:
		bMove = Move_pao();
		break;
	case BING:
		bMove = Move_bing();
	    break;	
	default:
	    break;
	}
	if (bMove)
	{
		Move_done(pos1, pos2);
		SetNextPlayerColor();
		return true;
	}
	return false;
}

int  kChessGame::ScanChessBoard()
{
	int nums = 0;
	for (int i = 0; i < m_nPlayerNum; ++i)
	{
		for (int j = 0; j < m_nX; ++j)
		{
			for (int k = 0; k < m_nY; ++k)
			{
				if (NULL != m_pBoard[i].piece[j][k])
				{
					m_pChessMans[nums++] = *(m_pBoard[i].piece[j][k]);
				}
			}
		}
	}
	return nums;
}

void ForTestShow(int val)
{
	switch(val)
	{
	case 0:
		printf("--");
		break;
	case SHUAI:
		printf("˧");
		break;
	case SHI:
		printf("ʿ");
	    break;
	case XIANG:
		printf("��");
	    break;
	case JU:
		printf("��");
		break;
	case MA:
		printf("��");
		break;
	case PAO:
		printf("��");
	    break;
	case BING:
		printf("��");
	    break;
	default:
		printf("  ");
	    break;
	}
}

bool kChessGame::Show()
{
	if (2 != m_nPlayerNum)
	{
		printf("�޷���ʾ���������Ϊ����\n");
		return false;	
	}
	int i = 0;
	int j = 0;
	for (i = 0; i < m_nY; ++i)
	{
		for (j = m_nX - 1; j >= 0; --j)	/// ���������
		{
			if (m_pBoard[0].piece[j][i])
			{
				ForTestShow(m_pBoard[0].piece[j][i]->val);
			}
			else ForTestShow(0);
			ForTestShow(0);
		}
		printf("\n");
		if (i < m_nY - 1)
		{
			printf("\n");
		}
	}
	printf("\n");
	for (i = m_nY - 1; i >= 0; --i)
	{
		for (j = 0; j < m_nX; ++j)	/// ���������
		{
			if (m_pBoard[1].piece[j][i])
			{
				ForTestShow(m_pBoard[1].piece[j][i]->val);
			}
			else ForTestShow(0);
			ForTestShow(0);
		}
		printf("\n");
		if (i > 0)
		{
			printf("\n");
		}
	}
	return true;
}

//////////////////////////////////////////////////////////////////////////


bool kChessGame::Init()
{
	m_nCurPlayer = 1;	/// �Ӻ�ɫ���ֿ�ʼ��
	m_pBoard = new ChessBoard_Half[m_nPlayerNum];
	if (NULL == m_pBoard)
	{
		m_pBoard = new ChessBoard_Half[m_nPlayerNum];
		assert(m_pBoard);
		if (NULL == m_pBoard)
		{
			return false;
		}
	}
	m_pPlayerExist = new bool[m_nPlayerNum];
	assert(m_pPlayerExist);
	m_nAllChessManNums = 0;	/// from "0";
	for (int i = 0; i < m_nPlayerNum; ++i)
	{
		m_pPlayerExist[i] = true;
		InitBoard(i);
	}
	return true;
}

bool kChessGame::InitBoard(int color)
{
	ChessBoard_Half* board = NULL;
	board = &(m_pBoard[color]);
	assert(board);
	int i = 0;
	int j = 0;
	for (i = 0; i < m_nX; ++i)
	{
		for (j = 0; j < m_nY; ++j)
		{
			board->piece[i][j] = NULL;
		}
	}
	SetChessMan(&(board->piece[0][0]), color, JU, 0, 0);
	SetChessMan(&(board->piece[8][0]), color, JU, 8, 0);
	SetChessMan(&(board->piece[1][0]), color, MA, 1, 0);
	SetChessMan(&(board->piece[7][0]), color, MA, 7, 0);
	SetChessMan(&(board->piece[2][0]), color, XIANG, 2, 0);
	SetChessMan(&(board->piece[6][0]), color, XIANG, 6, 0);
	SetChessMan(&(board->piece[3][0]), color, SHI, 3, 0);
	SetChessMan(&(board->piece[5][0]), color, SHI, 5, 0);
	SetChessMan(&(board->piece[4][0]), color, SHUAI, 4, 0);
	SetChessMan(&(board->piece[1][2]), color, PAO, 1, 2);
	SetChessMan(&(board->piece[7][2]), color, PAO, 7, 2);
	SetChessMan(&(board->piece[0][3]), color, BING, 0, 3);
	SetChessMan(&(board->piece[2][3]), color, BING, 2, 3);
	SetChessMan(&(board->piece[4][3]), color, BING, 4, 3);
	SetChessMan(&(board->piece[6][3]), color, BING, 6, 3);
	SetChessMan(&(board->piece[8][3]), color, BING, 8, 3);
	return true;
}

bool kChessGame::CreateTmpBoard(Position pos1, Position pos2)
{
	int i = 0;
	int j = 0;
	m_tPosFrom.color = pos1.color;
	m_tPosTo.color = pos2.color;
	if (pos1.color == pos2.color)	/// ��λ������ͬһ��ʱ��
	{
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j < m_nX; ++j)
			{
				m_pTempBoard->piece[j][i] = m_pBoard[pos1.color].piece[j][i];
			}
		}
		m_pTempBoard->nX = m_nX;
		m_pTempBoard->nY = m_nY;
		m_tPosFrom = pos1;
		m_tPosTo = pos2;
		return true;
	}
	/// ֮�����λ�þͲ�����ͬһ��������ɫ��ͬ�ˣ���
	if (2 == m_nPlayerNum)	/// �������������̵�ȫ�����ݣ���Ϊ��ʱ����߷��Ϳ��Կ��������ˡ�
	{
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j < m_nX; ++j)
			{
				m_pTempBoard->piece[j][i] = m_pBoard[pos1.color].piece[j][i];
			}
		}
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j < m_nX; ++j)
			{
				m_pTempBoard->piece[j][m_nY + i] = m_pBoard[pos2.color].piece[m_nX -1 - j][m_nY - 1 - i];
			}
		}
		m_pTempBoard->nX = m_nX;
		m_pTempBoard->nY = m_nY + m_nY;
		m_tPosFrom = pos1;
		m_tPosTo.x = m_nX - 1 - pos2.x;
		m_tPosTo.y = m_nY + m_nY - 1 - pos2.y;
		return true;
	}
	if (1 != DistanceInt(pos1.color, pos2.color) &&
		m_nPlayerNum - 1 != DistanceInt(pos1.color, pos2.color))	/// ������������ɫ�������
	{
		return false;
	}

	if (pos1.x >= m_nX / 2 && pos2.x <= m_nX / 2)
	{	/// ԭλ�����ұߣ�Ŀ��λ������ߣ�
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j <= m_nX / 2; ++j)
			{
				m_pTempBoard->piece[j][i] = m_pBoard[pos1.color].piece[m_nX / 2 + j][i];
			}
		}
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j <= m_nX / 2; ++j)
			{
				m_pTempBoard->piece[j][m_nY + i] = m_pBoard[pos2.color].piece[m_nX / 2 - j][m_nY - 1 - i];
			}
		}
		m_pTempBoard->nX = m_nX / 2 + 1;
		m_pTempBoard->nY = m_nY + m_nY;
		m_tPosFrom.x = pos1.x - m_nX / 2;
		m_tPosFrom.y = pos1.y;
		m_tPosTo.x = m_nX / 2 - pos2.x;
		m_tPosTo.y = m_nY + m_nY - 1 - pos2.y;
		return true;
	}
	if (pos1.x <= m_nX / 2 && pos2.x >= m_nX / 2)
	{	/// ԭλ������ߣ�Ŀ��λ�����ұߣ�
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j <= m_nX / 2; ++j)
			{
				m_pTempBoard->piece[j][i] = m_pBoard[pos2.color].piece[m_nX / 2 + j][i];
			}
		}
		for (i = 0; i < m_nY; ++i)
		{
			for (j = 0; j <= m_nX / 2; ++j)
			{
				m_pTempBoard->piece[j][m_nY + i] = m_pBoard[pos1.color].piece[m_nX / 2 - j][m_nY - 1 - i];
			}
		}
		m_pTempBoard->nX = m_nX / 2 + 1;
		m_pTempBoard->nY = m_nY + m_nY;
		m_tPosFrom.x = m_nX / 2 - pos1.x;
		m_tPosFrom.y = m_nY + m_nY - 1 - pos1.y;
		m_tPosTo.x = pos2.x - m_nX / 2;
		m_tPosTo.y = pos2.y;
		return true;
	}
	return false;
}

bool kChessGame::SetChessMan(ChessMan** pChessM, int color, int val, int x, int y)
{
	assert(pChessM);
	ChessMan* p = new ChessMan;
	assert(p);
	*pChessM = p;
	p->color = color;
	p->val = val;
	p->pos.color = color;
	p->pos.x = x;
	p->pos.y = y;
	m_ppAllChessMans[m_nAllChessManNums++] = p;	/// �����������Ժ�һ���ͷš�
	return true;
}

bool kChessGame::Move_done(Position pos1, Position pos2)
{
	ChessMan* pcm = m_pBoard[pos1.color].piece[pos1.x][pos1.y];
	if (NULL != m_pBoard[pos2.color].piece[pos2.x][pos2.y])
	{
		int tColor = m_pBoard[pos2.color].piece[pos2.x][pos2.y]->color;
		if (SHUAI == m_pBoard[pos2.color].piece[pos2.x][pos2.y]->val)
		{
			m_pPlayerExist[tColor] = false;
			ChangeColor(tColor, m_nCurPlayer);
		}
	}
	m_pBoard[pos1.color].piece[pos1.x][pos1.y] = NULL;	/// ��ʾ���Ӵ������߿��ˣ�
	m_pBoard[pos2.color].piece[pos2.x][pos2.y] = NULL;	/// ����������ڣ����ʾ���Ե���buff problem;
	m_pBoard[pos2.color].piece[pos2.x][pos2.y] = pcm;	/// ��ʾ�����ߵ������
	pcm->pos.x = pos2.x;
	pcm->pos.y = pos2.y;
	pcm->pos.color = pos2.color;
	return true;
}

bool kChessGame::WriteLog(const char* str)
{
	printf("%s", str);
	return true;
}

//////////////////////////////////////////////////////////////////////////

bool kChessGame::Move_shuai()
{
	if (0 == NChessManInSeg() &&
		m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y] &&
		SHUAI == m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y]->val)
	{	/// �ԶԶ����������
		return true;
	}
	if (m_tPosFrom.color != m_tPosTo.color || m_tPosTo.y < 0 || m_tPosTo.y > 2 || m_tPosTo.x < 3 || m_tPosTo.x > 5)
	{
		WriteLog("���������ܳ��硣\n");
		return false;
	}
	if (!isNeighbor())
	{
		WriteLog("��λ�ò�����\n");
		return false;
	}
	return true;
}

bool kChessGame::Move_shi()
{
	if (m_tPosTo.color != m_tPosFrom.color || 
		1 != DistanceInt(m_tPosTo.x, m_tPosFrom.x) ||
		1 != DistanceInt(m_tPosTo.y, m_tPosFrom.y))
	{	
		WriteLog("ʿ�ߵ�·�߲��ԡ�\n");
		return false;
	}
	if (m_tPosTo.x < 3 || m_tPosTo.x > 5 || m_tPosTo.y < 0 || m_tPosTo.y > 2)
	{
		WriteLog("ʿ�����߳��߽硣\n");
		return false;
	}
	return true;
}

bool kChessGame::Move_xiang()
{
	if (m_tPosTo.color != m_tPosFrom.color || 
		2 != DistanceInt(m_tPosTo.x, m_tPosFrom.x) ||
		2 != DistanceInt(m_tPosTo.y, m_tPosFrom.y))
	{	
		WriteLog("���ߵ�·�߲��ԡ�\n");
		return false;
	}
	if (m_pTempBoard->piece[(m_tPosTo.x + m_tPosFrom.x) / 2][(m_tPosTo.y + m_tPosFrom.y) / 2])
	{
		WriteLog("�������ӣ��������塣\n");
		return false;
	}
	return true;
}

bool kChessGame::Move_ju()
{
	if (!isOnLine())
	{
		WriteLog("����λ�ò���ͬһֱ���ϣ��������塣\n");
		return false;
	}
	if (NChessManInSeg() > 0)
	{
		WriteLog("����λ��֮���������Ӹ��ţ��������塣\n");
		return false;
	}
	return true;
}

bool kChessGame::Move_ma()
{
	if (!((2 == DistanceInt(m_tPosFrom.x, m_tPosTo.x) && 1 == DistanceInt(m_tPosFrom.y, m_tPosTo.y)) ||
		  (1 == DistanceInt(m_tPosFrom.x, m_tPosTo.x) && 2 == DistanceInt(m_tPosFrom.y, m_tPosTo.y))))
	{
	    WriteLog("��λ�ò��ǡ��ա��֣��������壡\n");
		return false;
	}
	if (2 == DistanceInt(m_tPosFrom.x, m_tPosTo.x) && 
		m_pTempBoard->piece[(m_tPosFrom.x + m_tPosTo.x) /2][m_tPosFrom.y])
	{
		WriteLog("�����������ߣ�\n");
		return false;
	}
	if (2 == DistanceInt(m_tPosFrom.y, m_tPosTo.y) && 
		m_pTempBoard->piece[m_tPosFrom.x][(m_tPosFrom.y + m_tPosTo.y) /2])
	{
		WriteLog("�����������ߣ�\n");
		return false;
	}
	return true;
}

bool kChessGame::Move_pao()
{
	if (!isOnLine())
	{
		WriteLog("����λ�ò���ͬһֱ���ϣ��������塣\n");
		return false;
	}
	int numsInSeg = NChessManInSeg();
	if (0 == numsInSeg && m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y])
	{
		WriteLog("û����̨���ڲ�����ô�ߣ�\n");
		return false;	
	}
	if (0 == numsInSeg && !m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y])
	{
		return true;
	}
	if (1 == numsInSeg && m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y] && 
		m_pTempBoard->piece[m_tPosFrom.x][m_tPosFrom.y]->color !=
		m_pTempBoard->piece[m_tPosTo.x][m_tPosTo.y]->color)
	{	/// ����̨��Ŀ��λ�����ӣ�Ŀ�겻���Լ���
		return true;
	}
	WriteLog("�ڲ��������ߣ�\n");
	return false;
}

bool kChessGame::Move_bing()
{
	if (!isNeighbor())
	{
		WriteLog("�����������ߣ���Ϊ�����ھӡ�\n");
		return false;
	}
	if (m_tPosFrom.color == m_tPosTo.color)
	{
		if (m_tPosTo.color == m_pTempBoard->piece[m_tPosFrom.x][m_tPosFrom.y]->color)
		{
			if (m_tPosTo.y == m_tPosFrom.y + 1)
			{
				return true;
			}
			WriteLog("����û���ӣ����ܺ������壬Ҳ���ܺ��ˡ�\n");
			return false;
		}
		else 
		{
			if (m_tPosTo.y  - 1 == m_tPosFrom.y)
			{
				WriteLog("���Ѿ����ӣ����ܺ��ˣ�\n");
				return false;
			}
			return true;
		}
	}
	else /// ����ͬһ�����̣��϶����Ǳ߽�������
	{
		if (m_tPosFrom.color == m_pTempBoard->piece[m_tPosFrom.x][m_tPosFrom.y]->color)
		{	/// ���ݱ�ֻ������һ�Σ�
			return true;
		}
		WriteLog("�����ܶ�ι��ӣ�\n");
		return false;
	}
	return false;
}

//////////////////////////////////////////////////////////////////////////

int DistanceInt(int a, int b)
{
	if (a > b)
	{
		return a - b;
	}
	return b - a;
}

bool kChessGame::isNeighbor()
{
	if ((1 == DistanceInt(m_tPosFrom.x, m_tPosTo.x) && 0 == DistanceInt(m_tPosFrom.y, m_tPosTo.y)) ||
		(0 == DistanceInt(m_tPosFrom.x, m_tPosTo.x) && 1 == DistanceInt(m_tPosFrom.y, m_tPosTo.y)))
	{
		return true;
	}
	return false;
}

bool kChessGame::isOnLine()
{
	return (m_tPosFrom.x == m_tPosTo.x || m_tPosFrom.y == m_tPosTo.y);
}

int	 kChessGame::NChessManInSeg()
{
	if (!isOnLine())
	{
		return -1;
	}
	int nums = 0;
	if (m_tPosFrom.x == m_tPosTo.x)
	{
		int mmm = (m_tPosFrom.y > m_tPosTo.y) ? m_tPosFrom.y : m_tPosTo.y;
		int mii = m_tPosFrom.y + m_tPosTo.y - mmm;
		for (++mii; mii < mmm; ++mii)
		{
			if (m_pTempBoard->piece[m_tPosFrom.x][mii])
			{
				++nums;
			}
		}
	}
	else
	{
		int mmm = (m_tPosFrom.x > m_tPosTo.x) ? m_tPosFrom.x : m_tPosTo.x;
		int mii = m_tPosFrom.x + m_tPosTo.x - mmm;
		for (++mii; mii < mmm; ++mii)
		{
			if (m_pTempBoard->piece[mii][m_tPosFrom.y])
			{
				++nums;
			}
		}
	}
	return nums;
}

bool kChessGame::SetNextPlayerColor()
{
	int i = 0;
	for (i = m_nCurPlayer + 1; i % m_nPlayerNum != m_nCurPlayer && !m_pPlayerExist[i % m_nPlayerNum]; ++i);
	if (i % m_nPlayerNum == m_nCurPlayer)
	{
		m_bGameOver = true;
	}
	m_nCurPlayer = i % m_nPlayerNum;
	return true;
}

bool kChessGame::ChangeColor( int fromColor, int toColor )
{
	int i = 0;
	int j = 0;
	int k = 0;
	for (i = 0; i < m_nPlayerNum; ++i)
	{
		for (j = 0; j < m_nX; ++j)
		{
			for (k = 0; k < m_nY; ++k)
			{
				if (m_pBoard[i].piece[j][k] &&
					m_pBoard[i].piece[j][k]->color == fromColor)
				{
					m_pBoard[i].piece[j][k]->color = toColor;
				}
			}
		}
	}
	return true;
}

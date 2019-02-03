package sigma.xpchess.util
{
	public class ChessManUtil
	{
		public static const JU1:String = "俥";
		public static const JU2:String = "車";
		public static const MA1:String = "傌";
		public static const MA2:String = "馬";
		public static const XIANG1:String = "相";
		public static const XIANG2:String = "象";
		public static const SHI1:String = "仕";
		public static const SHI2:String = "士";
		public static const SHUAI:String = "帥";
		public static const JIANG:String = "將";
		public static const PAO1:String = "炮";
		public static const PAO2:String = "砲";
		public static const BING:String = "兵";
		public static const ZU:String = "卒";
		
		public static const JU0:String = "车";
		public static const MA0:String = "马";
		public static const SHUAI0:String = "帅";
		public static const JIANG0:String = "将";
		public static const NONAME:String = "";
		
		public static function getLabel(type: int, bRed: Boolean): String
		{
			switch (type)
			{
				case 1:
					return bRed ? SHUAI : JIANG;
				case 2:
					return bRed ? SHI1 : SHI2;
				case 3:
					return bRed ? XIANG1 : XIANG2;
				case 4:
					return bRed ? JU1 : JU2;
				case 5:
					return bRed ? MA1 : MA2;
				case 6:
					return bRed ? PAO1 : PAO2;
				case 7:
					return bRed ? BING : ZU;
			}
			return NONAME;
		}
		
		public static function getType(label: String): int
		{
			switch (label)
			{
				case SHUAI0:
				case JIANG0:
				case SHUAI:
				case JIANG:
					return 1;
				case SHI1:
				case SHI2:
					return 2;
				case XIANG1:
				case XIANG2:
					return 3;
				case JU0:
				case JU1:
				case JU2:
					return 4;
				case MA0:
				case MA1:
				case MA2:
					return 5;
				case PAO1:
				case PAO2:
					return 6;
				case BING:
				case ZU:
					return 7;
			}
			return -1;
		}
		
		public static const RED:uint = 0xff0000;
		public static const BLACK:uint = 0x000000;
		public static const GREEN:uint = 0x006600;
		public static const BLUE:uint = 0x0000cc;
		public static const NONE:uint = 0xffffff;
		
		public static function getColor(role: int): uint
		{
			switch (role)
			{
				case 0:
					return BLACK;
				case 1:
					return RED;
				case 2:
					return BLUE;
				case 3:
					return GREEN;
			}
			return NONE;
		}
		
		public static function getRole(color: uint): int
		{
			switch (color)
			{
				case BLACK:
					return 0;
				case RED:
					return 1;
				case BLUE:
					return 2;
				case GREEN:
					return 3;
			}
			return -1;
		}
	}
}
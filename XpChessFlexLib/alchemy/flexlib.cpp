#include <AS3.h>
#include "chessgame.h"
#include "stdio.h"

/*----------------------------------------------*/
AS3_Val kChessGame_GetCurPlayer(void* self, AS3_Val args)
{
	int result = ((kChessGame*)self)->GetCurPlayer();
	return AS3_Int(result);
}

AS3_Val kChessGame_Start(void* self, AS3_Val args)
{
    int n;
	AS3_ArrayValue(args, "IntType", &n);
	bool result = ((kChessGame*)self)->Start(n);
	return AS3_Int(result);
}

AS3_Val kChessGame_Stop(void* self, AS3_Val args)
{
    bool result = ((kChessGame*)self)->Stop();
	return AS3_Int(result);
}

AS3_Val kChessGame_Move(void* self, AS3_Val args)
{
    Position pos1, pos2;
    
    AS3_Val p1, p2;
	AS3_ArrayValue(args, "AS3ValType, AS3ValType", &p1, &p2);
	AS3_ObjectValue(p1, "x:IntType, y:IntType, color:IntType", &pos1.x, &pos1.y, &pos1.color);
	AS3_ObjectValue(p2, "x:IntType, y:IntType, color:IntType", &pos2.x, &pos2.y, &pos2.color);
	AS3_Release( p1 );
	AS3_Release( p2 );
	
	int result = ((kChessGame*)self)->Move(pos1, pos2);
	return AS3_Int(result);
}

AS3_Val kChessGame_Regret(void* self, AS3_Val args)
{
    bool result = ((kChessGame*)self)->Regret();
	return AS3_Int(result);
}

AS3_Val kChessGame_ChessMans(void* self, AS3_Val args)
{
    int nums = ((kChessGame*)self)->ScanChessBoard();
    ChessMan* chessmans = ((kChessGame*)self)->m_pChessMans;

    //AS3_Val top_namespace = AS3_String("");
    //AS3_Val array_class = AS3_NSGetS(top_namespace, "Array");
    //AS3_Val emptyParams = AS3_Array("");
    //AS3_Val arrChessMan = AS3_New(array_class, emptyParams);
    //AS3_Release(array_class);
    //AS3_Release(top_namespace);
    AS3_Val arrChessMan = AS3_Array("");
    
    AS3_Val pushMethod = AS3_GetS(arrChessMan, "push");
    for (int i = 0; i < nums; ++i)
    {
	    AS3_Val chessman_pos = AS3_Object("x:IntType, y:IntType, color:IntType",
	                                      chessmans[i].pos.x, chessmans[i].pos.y, chessmans[i].pos.color);
        AS3_Val chessman = AS3_Object("val:IntType, color:IntType, pos:AS3ValType",
                                      chessmans[i].val, chessmans[i].color, chessman_pos);
        AS3_Release(chessman_pos);

        AS3_Val arrayParams = AS3_Array("AS3ValType", chessman);
        AS3_Release(chessman);
        
        AS3_Call(pushMethod, arrChessMan, arrayParams);
        //AS3_CallS("push", arrChessMan, arrayParams);
        AS3_Release(arrayParams);
    }
    AS3_Release(pushMethod);
    
    return arrChessMan;
}

AS3_Val kChessGame_Release(void* self, AS3_Val args)
{
    delete (kChessGame*)self;
    return AS3_Null();
}

/*----------------------------------------------*/
AS3_Val CreateChess(void* self, AS3_Val args)
{
    void *pChess = (void*)new kChessGame();
    
	/* define the methods exposed to ActionScript */
	/* typed as an ActionScript Function instance */
    AS3_Val GetCurPlayerMethod = AS3_Function( pChess, kChessGame_GetCurPlayer );
 	AS3_Val StartMethod = AS3_Function( pChess, kChessGame_Start );
	AS3_Val StopMethod = AS3_Function( pChess, kChessGame_Stop );
	AS3_Val MoveMethod = AS3_Function( pChess, kChessGame_Move );
	AS3_Val RegretMethod = AS3_Function( pChess, kChessGame_Regret );
    AS3_Val ChessMansMethod = AS3_Function( pChess, kChessGame_ChessMans );
    AS3_Val ReleaseMethod = AS3_Function( pChess, kChessGame_Release );

	/* construct an object that holds references to the functions */
	AS3_Val result = AS3_Object( "GetCurPlayer: AS3ValType, Start: AS3ValType, Stop: AS3ValType, Move: AS3ValType, Regret:AS3ValType, ChessMans:AS3ValType, Release:AS3ValType",
                                 GetCurPlayerMethod, StartMethod, StopMethod, MoveMethod, RegretMethod, ChessMansMethod, ReleaseMethod );

	/* Release */
	AS3_Release( GetCurPlayerMethod );
	AS3_Release( StartMethod );
	AS3_Release( StopMethod );
	AS3_Release( MoveMethod );
	AS3_Release( RegretMethod );
	AS3_Release( ChessMansMethod );
	AS3_Release( ReleaseMethod );
	
    return result;
}

/*----------------------------------------------*/
/*entry point for code*/
int main()
{
	/* define the methods exposed to ActionScript */
	/* typed as an ActionScript Function instance */
    AS3_Val createMethod = AS3_Function(NULL, CreateChess);
    
	/* construct an object that holds references to the functions */
	
    AS3_Val result = AS3_Object("create: AS3ValType", createMethod);
    
	/* Release */
    AS3_Release(createMethod);
    
	/* notify that we initialized -- THIS DOES NOT RETURN! */
	AS3_LibInit( result );

	/* should never get here! */
	return 0;
}


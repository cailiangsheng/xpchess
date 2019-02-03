/*
 * sotest.cpp
 *
 *  Created on: 2011-1-31
 *      Author: sigma
 */

#include "../src/chessbase.h"
#include "dlfcn.h"

typedef kChessBase *create_t();
typedef void destroy_t(kChessBase *);

void test()
{
	void *handle = dlopen("/home/sigma/projects/xpchess/XpChessCppLib/DShared/libXpChessCppLib.so", RTLD_NOW);
	if (!handle)
		return;

	kChessBase *chess = 0;

	create_t* create = (create_t*)dlsym(handle, "create");
	if (create)
		chess = create();

	if (chess)
	{
		chess->Start(2);
		chess->Show();
	}

	destroy_t* destroy = (destroy_t*)dlsym(handle, "destroy");
	if (destroy)
		destroy(chess);

	dlclose(handle);
}

int main()
{
	test();
	return 0;
}

//
//  LD_LuaInterface.c
//  Ludo
//
//  Created by Sid on 03/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "lua/include/lua.h"
#import "lua/include/lualib.h"
#import "lua/include/lauxlib.h"

lua_State *L;

static int average() {
 /* get number of arguments */
 int n = lua_gettop(L);
 double sum = 0.0;

 /* loop through args */
 for (int i = 1; i <=n; i++) {
  sum += lua_tonumber(L, i);
 }

 lua_pushnumber(L, sum/n);	/* push average */
 lua_pushnumber(L, sum);	/* push sum */

 return 2;	/* return num of results*/
}

static int Add(int x, int y) {
 int sum;

 /* the function name */
 lua_getglobal(L, "add");
 /* pass args */
 lua_pushnumber(L, x);
 lua_pushnumber(L, y);
 /* call function with 2 args and 1 return */
 lua_call(L, 2, 1);
 /* get result */
 sum = lua_tointeger(L, -1);
 lua_pop(L, 1);
 return sum;
}

static void LuaInit() {
/* initialze lua */
 L = luaL_newstate();

 /* load lua libs */
 luaL_openlibs(L);

 /* register function, will be called from lua */
 lua_register(L, "average", average);

 /* run script that calls C function from Lua */
 NSString *script_path = [[NSBundle mainBundle] pathForResource:@"avg" ofType:@"lua"];
 luaL_dofile(L, [script_path UTF8String]);

 /* run script that calls Lua function from C */
 script_path = [[NSBundle mainBundle] pathForResource:@"add" ofType:@"lua"];
 luaL_dofile(L, [script_path UTF8String]);
 printf("sum = %d,",Add(10,20));

 /* cleanup lua */
 lua_close(L);

}


//
//  LD_GameContext.m
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#include "LD_Context.h"

static Context *g_CurrentContext = NULL;

Context *BindContext(Context *some_context) {
 g_CurrentContext = some_context;
 return g_CurrentContext;
}

void UnbindContext() {
 g_CurrentContext = NULL;
}

Context *CurrentContext() {
 return g_CurrentContext;
}

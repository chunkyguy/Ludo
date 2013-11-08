//
//  LD_GameContext.m
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_GameContext.h"

static GameContext *g_CurrentContext = NULL;

GameContext *BindContext(GameContext *some_context) {
 g_CurrentContext = some_context;
 return g_CurrentContext;
}

void UnbindContext() {
 g_CurrentContext = NULL;
}

GameContext *CurrentContext() {
 return g_CurrentContext;
}

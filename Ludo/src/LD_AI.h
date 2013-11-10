//
//  LD_AI.h
//  Ludo
//
//  Created by Sid on 10/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_AI_h
#define LD_AI_h

#include "LD_Types.h"


/**  Search for any moves pending. 
 	Call this function whenever required.
 This function should be called for simulating response delay
 */
void PlayAIAll();

/* Call this function for active game */
bool PlayAI(Game *game);
#endif

//
//  LD_GameContext.h
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_GameContext_h
#define LD_GameContext_h

#include "LD_Types.h"

/** Initialize the global context with the provided context.
 The caller has to keep the responsibility to keep the context alive in memory
  Returns the context if all goes well, else NULL
 */
Context *BindContext(Context *some_context);

/** Since no memory allocation is done for the context
 This call just sets the internal pointer to global context as NULL
 Release the context if it has been created in heap in the appropriate place,
 */
void UnbindContext();

/** Get current context reference */
Context *CurrentContext();

#endif

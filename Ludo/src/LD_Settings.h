//
//  LD_Settings.h
//  Ludo
//
//  Created by Sid on 07/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_Settings_h
#define LD_Settings_h
#include "LD_Types.h"

/************************************************************************
 MARK: SystemEnv
 ***********************************************************************/
void InitSystemEnv(SystemEnv *sys_env);

/** The number of game types possible */
int GameTypeCount(const SystemEnv *sys_env);


#endif
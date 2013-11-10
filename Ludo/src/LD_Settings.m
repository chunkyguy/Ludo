//
//  LD_Settings.m
//  Ludo
//
//  Created by Sid on 07/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#include "LD_Settings.h"

/************************************************************************
 MARK: SystemEnv
 ***********************************************************************/
void InitSystemEnv(SystemEnv *sys_env) {
 
}

int GameTypeCount(const SystemEnv *sys_env) {
 UInt32 gt[] = {
  kGameType_local,
  kGameType_online
 };
 
 int count = 0;
 int t_gt = sizeof(gt) / sizeof(gt[0]);
 for (int i = 0; i < t_gt; ++i) {
  if (sys_env->game_types & gt[i]) {
   count++;
  }
 }
 
 return count;
}

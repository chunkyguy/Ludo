//
//  LD_Utilities.m
//  Ludo
//
//  Created by Sid on 09/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#include "LD_Utilities.h"

/************************************************************************
 MARK: Utility
 ***********************************************************************/
static char flags[] = {'r', 'b', 'y', 'g'};

int FlagToIndex(const char flag) {
 int index = 0;
 
 while ((flags[index++] != flag)){
  assert(index < 4);
 }
 
 return index;
}

char IndexToFlag(int index) {
 return flags[index];
}

int PPIToTag(const ID playerID, const ID pieceID) {
 return playerID * 10 + pieceID;
}

void TagtoPPI(ID *playerID, ID *pieceID, int tag) {
 *playerID = tag/10;
 *pieceID = tag%10;
}

/** Get the color for a flag value
 @param color An array of 4 floats.
 @param flag The flag {rgby}
 */
float *FlagToColor(float color[], const char flag) {
 color[0] = 0.0f;
 color[1] = 0.0f;
 color[2] = 0.0f;
 color[3] = 1.0f;
 
 switch (flag) {
  case 'r': color[0] = 1.0f;   break;
  case 'g': color[1] = 1.0f;   break;
  case 'b': color[2] = 1.0f;   break;
  case 'y': color[0] = 1.0f; color[1] = 1.0f;   break;
 }
 return color;
}

/* The center point where the pieces stand at the beginning */
CGPoint *FlagToOrigin(CGPoint *origin, const char flag, int offset_index) {
 
 switch (flag) {
  case 'r': origin->x = 600.0f; origin->y = 200.0f;   break;
  case 'g': origin->x = 100.0f; origin->y = 200.0f;   break;
  case 'b': origin->x = 600.0f; origin->y = 800.0f;   break;
  case 'y': origin->x = 100.0f; origin->y = 800.0f;   break;
 }
 
 CGPoint center_offset[] = {
  {-50, -50},
  {50, -50},
  {-50, 50},
  {50, 50}
 };
 origin->x += center_offset[offset_index].x;
 origin->y += center_offset[offset_index].y;
 
 return origin;
}

/* 	Call some action after delay */
void DispatchEvent(float delay_secs, DispatchEventAction action) {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_secs * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  action();
 });
}

/** Returns a value in set [1.6] */
int RollDice() {
 return rand() % 6 + 1;
}

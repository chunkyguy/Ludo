//
//  LD_Utilities.h
//  Ludo
//
//  Created by Sid on 09/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#ifndef LD_Utilities_h
#define LD_Utilities_h
#include "LD_Types.h"

/************************************************************************
 MARK: Utility
 ***********************************************************************/
/** Get the color for a flag value
 @param color An array of 4 floats.
 @param flag The flag {rgby}
 */
float *FlagToColor(float color[], const char flag);

/* The center point where the pieces stand at the beginning */
CGPoint *FlagToOrigin(CGPoint *origin, const char flag, int offset_index);

typedef void(^DispatchEventAction)(void);

/* 	Call some action after delay */
void DispatchEvent(float delay_secs, DispatchEventAction action);

/* Single point for flag to index mapping */
int FlagToIndex(const char flag);
char IndexToFlag(int index);

/* Use the tag to assign to a view or as ID */
int PPIToTag(const ID playerID, const ID pieceID);
void TagtoPPI(ID *playerID, ID *pieceID, int tag);

/** Returns a value in set [1.6] */
int RollDice();

#endif
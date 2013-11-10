//
//  LD_File.h
//  Ludo
//
//  Created by Sid on 10/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_File_h
#define LD_File_h
#include "LD_Types.h"

/** Total available games. 
 Optionally, fetch their gameIDs, for things like refreshing the list screen.
 Provide a sufficient buffer for gameIDs.
 
 Or call this method twice, like:
 
 int sg = TotalSavedGames(NULL);
 ID gIDs = (ID*)malloc(sizeof(ID) * sg);
 TotalSavedGames(gIDs);
 */
int TotalSavedGames(ID *gameIDs);

/** Load game from file */
Game *LoadGameFromFile(Game *buffer, ID gameID);

/** Store game to file */
bool StoreGameToFile(Game *game);
#endif

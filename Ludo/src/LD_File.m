//
//  LD_File.m
//  Ludo
//
//  Created by Sid on 10/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#include "LD_File.h"

#include <dirent.h>

#include "he/he_Utilities.h"
#include "he/he_Constants.h"


/* Get the filename for game-id */
static char *gameID_to_filename(char *buffer, ID gameid) {
 sprintf(buffer, "%ld.game",gameid);
 return buffer;
}


int TotalSavedGames(ID *gameIDs) {
 /* iterate through the directory */
 char fn_buf[kBuffer1K];
 char fp_buf[kBuffer1K];
 DIR *dp = opendir(DocumentPath(fp_buf, NULL));
 struct dirent *ep;
 int count = 0;
 
 while ((ep = readdir(dp)) != NULL) {
  if (ep->d_type == DT_REG) {
   gameIDs[count++] = atol(strcpy(fn_buf, ep->d_name));
  }
 }
 closedir(dp);
 return count;
}

/** Load game from file */
Game *LoadGameFromFile(Game *buffer, ID gameID) {
 char fn_buf[kBuffer256];
 char fp_buf[kBuffer1K];
 
 ReadFile((char*)buffer, DocumentPath(fp_buf, gameID_to_filename(fn_buf, gameID)));
 return buffer;
}

/** Store game to file */
bool StoreGameToFile(Game *game) {
 char fn_buf[kBuffer256];
 char fp_buf[kBuffer1K];

 return WriteFile(DocumentPath(fp_buf, gameID_to_filename(fn_buf, game->gameID)), (char*)game, sizeof(Game));
}

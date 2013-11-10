//
//  LD_AI.m
//  Ludo
//
//  Created by Sid on 10/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#include "LD_AI.h"
#include "LD_MoveQueue.h"
#include "LD_File.h"

/** Look for any AI pending move.
 If yes, make a move.
 Make__Move() will push the moves to the MoveQueue.
 The MoveQueue will test if any of the pushed move's game is active.
 */
void PlayAIAll() {

 ID gameIDs[256];
 Game game;
 
 /* Iterate all saved games */
 int gc = TotalSavedGames(gameIDs);
 for (int g = 0; g < gc; ++g) {
  
  /* Load game */
  LoadGameFromFile(&game, gameIDs[g]);

  /* Save the file if modified */
  if (PlayAI(&game)) {
   StoreGameToFile(&game);
  }
 }
}

bool PlayAI(Game *game) {
 MakeDiceMove(game);
 MakeRandomPieceMove(game, game->playerID);
 return true;
 
// Move moves[256];
// bool file_mod = false;
//
// /* Look for any AI pending move */
// for (ID p = 0; p < 4; ++p) {
//  if (game->player[p].intel == kIntelligence_AI) {
//   
//   /* Search any pending moves for that AI player */
//   int mc = StoredMoves(moves, game->gameID, p);
//   for (int m = 0; m < mc; ++m) {
//    
//    /* Make the move */
//    MakeDiceMove(game);
//    MakeRandomPieceMove(game, p);
//    
//    /* Delete it from MoveQueue */
//    DeleteMove(moves[m].moveID);
//    file_mod = true;
//   }
//  }
// }
// 
// return file_mod;
}


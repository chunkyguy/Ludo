//
//  LD_Game.h
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_Game_H
#define LD_Game_H

#include "LD_Types.h"

/************************************************************************
 MARK: Game
 ***********************************************************************/
/** Init the game state. */
void GenGame(Game *game);

/* Release any resources occupied at GenGame */
void DeleteGame(Game *game);

/** Current game state */
kGameState GameState(const Game *game);

/* Returns the index of the current player 
 Use the game->playerID instead
 */
//int CurrentPlayerIndex(const Game *game);

/************************************************************************
 MARK: Execute moves
 ***********************************************************************/
/* Interpret the move and step game.
 Under usual scenario, this method shouldn't be called explicitly 
 Call the ForwardAndStore() instead, it indirectly calls this.
 */
void StepGame(Game *game, Move *move);
void SyncGame(Game *game);
/************************************************************************
 MARK: Push moves
 ***********************************************************************/
/** Roll the dice, update the UI
 If no move is possible with the dice value, automatically step game forward.
 Invoked when a human touches the dice.
 */
void MakeDiceMove(Game *game);

/** Called when a piece is touched */
void MakePieceMove(Game *game, const ID playerID, const ID pieceID);

/** Called from AI */
void MakeRandomPieceMove(Game *game, ID playerID);
#endif
/* EOF */

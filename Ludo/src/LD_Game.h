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
 MARK: SystemEnv
 ***********************************************************************/
void InitSystemEnv(SystemEnv *sys_env);

/** The number of game types possible */
int GameTypeCount(const SystemEnv *sys_env);


/************************************************************************
 MARK: Game
 ***********************************************************************/
/** Init the game state. */
void GenGame(Game *game);

/* Release any resources occupied at GenGame */
void DeleteGame(Game *game);

/* Get the filename for game-id */
char *GameIDToFilename(char *buffer, gameID gameid);

/* Save the current state of game to the associated file */
bool SaveGame(Game *game);

/* Load a saved game from file.
 Fill in the game's gameid before calling this function.
 The file should exist */
Game *LoadGame(Game *game);

/** Current game state */
kGameState GameState(const Game *game);

/* Returns the index of the current player */
int CurrentPlayerIndex(const Game *game);

/* Step game with move.
 Under usual scenario, this method shouldn't be called explicitly 
 Call the ForwardAndStore() instead, it indirectly calls this.
 */
void StepGame(Game *game, Move *move);

/************************************************************************
 MARK: Touch Events
 ***********************************************************************/
/** Called when a piece is touched */
void HandlePieceTouchEvent(Game *game, const Set2i *ppi);

/** Called when the dice is touched */
void HandleDiceTouchEvent(Game *game);


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
int PPIToTag(const Set2i *ppi);
void TagtoPPI(Set2i *ppi, int tag);

#endif
/* EOF */

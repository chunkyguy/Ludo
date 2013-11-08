//
//  LD_Game.h
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_Game_H
#define LD_Game_H

#define kGameType_local (1 << 0)
#define kGameType_online (1 << 1)

#define TILE_MAX 15
#define MOVE_MAX 57

/************************************************************************
 MARK: Types
 ***********************************************************************/
typedef struct {
 UInt32 game_types; /* The types of games available */
} SystemEnv;

@class LD_PieceView;
typedef struct {
 LD_PieceView *view;
 int step_index; /* map to g_PathMap to get the point on screen */
} Piece;

typedef enum {
 kIntelligence_Human,
 kIntelligence_AI
} kIntelligence;

typedef struct {
 Piece piece[4];
 char flag;
 kIntelligence intel;
} Player;

typedef struct {
 int one;
 int two;
} Set2i;

typedef struct  {
 CGPoint point;
} Tile;

typedef unsigned long gameID;

typedef struct {
 gameID gID;
 Set2i ppi;
 int steps;
} Move;

@class LD_RootViewController;
typedef struct {
 gameID ID;
 int turn;
 Player player[4];
 int dice_val;
 Tile map[TILE_MAX][TILE_MAX];
 LD_RootViewController *gui;
} Game;

/** Ordering matters. It's in the order the player's play */
typedef enum {
 kGameState_RedWins,
 kGameState_BlueWins,
 kGameState_YellowWins,
 kGameState_GreenWins,
 kGameState_None
} kGameState;

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

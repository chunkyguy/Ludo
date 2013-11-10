//
//  LD_Type.h
//  Ludo
//
//  Created by Sid on 09/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#ifndef Ludo_LD_Type_h
#define Ludo_LD_Type_h
#include "LD_Constants.h"

/************************************************************************
 MARK: Types
 ***********************************************************************/

@class LD_PieceView;
typedef struct {
 LD_PieceView *view;
 int step_index; /* map to g_PathMap to get the point on screen */
} Piece;

typedef enum {
 kIntelligence_Human,
 kIntelligence_AI
} kIntelligence;

typedef unsigned long ID;

typedef struct {
 ID playerID;
 Piece piece[4];
 char flag;
 kIntelligence intel;
} Player;

typedef struct  {
 CGPoint point;
} Tile;

typedef enum {
 kMoveType_Birth, /* Bring a piece to life */
 kMoveType_Roll, /* Roll the dice */
 kMoveType_Step, /* Update the piece forward */
 kMoveType_Death /* Start a new piece */
} kMoveType;

typedef struct {
 ID moveID; /* Move number */
 kMoveType type; /* Move type */
 ID gameID; /* The game */
 ID recvID; /* receiver player */
 ID senderID; /* sender player */
 ID pieceID; /* sender's piece */
 int steps; /* For kMoveType_Fwd holds either the moves for the piece
             in case of kMoveType_Dice fills the dice value */
} Move;

@class LD_RootViewController;
typedef struct {
 ID gameID;
 ID playerID;
 ID moveID;
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

typedef struct {
 UInt32 game_types; /* The types of games available */
 //Move moves_buffer[MOVES_BUFFER]; /* Max moves that can be stored */
} SystemEnv;

/* The one object for all global entities */
typedef struct {
 SystemEnv sysenv;
 Game game;
} Context;

#endif

//
//  LD_Type.h
//  Ludo
//
//  Created by Sid on 09/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#ifndef Ludo_LD_Type_h
#define Ludo_LD_Type_h

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


#endif

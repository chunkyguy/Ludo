//
//  LD_Game.m
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#include "LD_Game.h"

#include "Prototype/LD_PieceView.h"
#include "Prototype/LD_RootViewController.h"

#include "he/he_Constants.h"
#import "he/he_Utilities.h"

#include "LD_MoveQueue.h"
#include "LD_Utilities.h"
#include "LD_AI.h"
#include "LD_File.h"

/************************************************************************
 MARK: Private interface
 ***********************************************************************/
/* fill init tilemap */
static void gen_tilemap(Tile map[][TILE_MAX]);

/* Search for player-piece set at given index
 Store the results in set. The set should have enough space to hold the data.
 Typically for 16 pieces, it should not exceed 15
 Return number of sets found.
 */
static int search_playerpieces_at_tile_index(ID *playerIDs, ID *pieceIDs, Game *game, int tile_index);

/** number of moves possible for the player
 The moves should be an array for all the moves possible (less than 8)
 Returns number of moves possible.
 */
static int calc_possible_moves(Move *moves, ID playerID, Game *game);

/** Updates the UI with the current game state.
 */
static void step_game_forward(Game *game);


/************************************************************************
 MARK: Game
 ***********************************************************************/
//static void PrintTilemap(Tile map[][TILE_MAX]) {
// for (int i = 0; i < TILE_MAX; ++i) {
//  for (int j = 0; j < TILE_MAX; ++j) {
//   printf("[%d,%d] = {%.2f,%.2f}\n", i, j,map[i][j].point.x, map[i][j].point.y);
//  }
//  printf("\n");
// }
//}

/* fill init tilemap */
void gen_tilemap(Tile map[][TILE_MAX]) {
 CGFloat minx = 20.0f;
 CGFloat miny = 20.0f;
 CGFloat maxx = 800.0f;
 CGFloat maxy = 1080.0f;
 CGFloat dx = (maxx - minx)/TILE_MAX;
 CGFloat dy = (maxy - miny)/TILE_MAX;
 
 for (int i = 0; i < TILE_MAX; ++i) {
  for (int j = 0; j < TILE_MAX; ++j) {
   map[i][j].point = CGPointMake(minx + (j*dx), miny + (i*dy));
  }
 }
 //PrintTilemap(map);
}

/** Init the game state. */
void GenGame(Game *game) {
 
 /* create tilemap */
 gen_tilemap(game->map);
 
 /* create players */
 CGPoint origin;
 CGPoint center_offset[] = {
  {-50, -50},
  {50, -50},
  {-50, 50},
  {50, 50}
 };

 for (int i = 0; i < 4; ++i) {
  char flag = IndexToFlag(i);
  game->player[i].flag = flag;
  for (int j = 0; j < 4; ++j) {
   FlagToOrigin(&origin, flag, j);
   game->player[i].piece[j].view =
   [[LD_PieceView alloc] initWithFrame:CGRectMake(origin.x, origin.y + center_offset[j].y, 50, 50)
                              playerID:i
                               pieceID:j];
   game->player[i].piece[j].view.tag = PPIToTag(i, j);
   game->player[i].piece[j].step_index = -1;
  }
 }
 
 game->gameID = time(NULL);
 game->moveID = 0;
 game->playerID = 0;
 game->dice_val = 0;
}

/* Release any resources occupied at GenGame */
void DeleteGame(Game *game) {
 /* delete players */
 for (int i = 0; i < 4; ++i) {
  for (int j = 0; j < 4; ++j) {
   [game->player[i].piece[j].view release];
  }
 }
}

///* Returns the index of the current player */
//int CurrentPlayerIndex(const Game *game) {
// return game->turn % 4;
//}


/** Current game state */
kGameState GameState(const Game *game) {
 kGameState states[] = {
  kGameState_RedWins,
  kGameState_BlueWins,
  kGameState_YellowWins,
  kGameState_GreenWins,
 };
 
 for (int i = 0; i < 4; ++i) {
  int players_home = 0;
  for (int j = 0; j < 4; ++j) {
   if (game->player[i].piece[j].step_index == MOVE_MAX-1) {
    players_home++;
   }
  }
  if (players_home == 4) {
   return states[i];
  }
 }
 return kGameState_None;
}


/************************************************************************
 MARK: Globals
 ***********************************************************************/
/** Path map: maps to all the possible location any piece can have
 If you watch closely, you can see a pattern.
 I was just being lazy, to calculate it programatically.
 */
static int g_PathMap[4][MOVE_MAX] = {
 /* red */
 {
  //8,
  23,38,53,68,83,99,100,101,102,103,104,119,
  
  134,
  133,132,131,130,129,143,158,173,188,203,218,217,
  
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  
  22,37,52,67,82,97
 },
 
 /* blue */
 {
  //134,
  133,132,131,130,129,143,158,173,188,203,218,217,
  
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  
  8,
  23,38,53,68,83,99,100,101,102,103,104,119,
  
  118,117,116,115,114,113
 },
 
 /* yellow */
 {
  //216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  
  8,
  23,38,53,68,83,99,100,101,102,103,104,119,
  
  134,
  133,132,131,130,129,143,158,173,188,203,218,217,
  
  202,187,172,157,142,127
 },
 
 /* green */
 {
  //90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  
  8,
  23,38,53,68,83,99,100,101,102,103,104,119,
  
  134,
  133,132,131,130,129,143,158,173,188,203,218,217,
  
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  
  106,107,108,109,110,111
 }
};

/************************************************************************
 MARK: Execute moves
 ***********************************************************************/
/** Updates the UI with the current game state.
 */
void step_game_forward(Game *game) {
 /* Update the game state*/
 kGameState state = GameState(game);
 
 /* After all animations are over, move to next player */
 game->playerID++;
 if (game->playerID >= MAX_PLAYERS) {
  game->playerID = 0;
 }
 
 /* Update the GUI */
 [game->gui updatePieces:game state:state];
 
 /* Inform the next player about the turn */
// int npi = game->playerID;
// if (game->player[npi].intel == kIntelligence_AI) {
//  auto_step_player(npi, game);
// }
 
 SyncGame(game);
}

static void move_type_dice(Game *game, Move *move) {
 int dice_val = move->steps;
 game->dice_val = dice_val;
 /* animate the dice and update the view */
 [game->gui updateDice:game];
 
 /* test if dice value is not playable, else move forward with the game */
 Move moves[8];
 int movesc = calc_possible_moves(moves, game->playerID, game);
 if (movesc == 0) {
  step_game_forward(game);
 }
}

/* Search for player-piece set at given index
 Store the results in set. The set should have enough space to hold the data.
 Typically for 16 pieces, it should not exceed 15
 Return number of sets found.
 */
int search_playerpieces_at_tile_index(ID *playerIDs, ID *pieceIDs, Game *game, int tile_index) {
 int count = 0;
 for (int playerid = 0; playerid < 4; ++playerid) {
  for (int pieceid = 0; pieceid < 4; ++pieceid) {
   int si = game->player[playerid].piece[pieceid].step_index;
   if (g_PathMap[playerid][si] == tile_index) {
    playerIDs[count] = playerid;
    pieceIDs[count] = pieceid;
    count++;
   }
  }
 }
 
 return count;
}

/** Move a give piece forward steps
 @param playerpiece_index The set of {player_index, piece_index}
 @param steps Number of steps to be moved forward.
 @note If steps < 0, then moves to the home tile i.e. step # 0.
 */
static void move_type_steps(Game *game, Move *move, int next_si) {
 Player *player = &game->player[move->senderID];

 if (next_si < 0) {
  next_si = 0;
 }
 
 int tile_index = g_PathMap[move->senderID][next_si];
 Tile tile = game->map[tile_index/15][tile_index%15];
 
 /* test if there is something already at that tile
  Otherwise, it dies it and goes back to where it came from.
  Except for the same flag pieces.
  */
 ID old_playerIDs[15];
 ID old_pieceIDs[15];
 int count = search_playerpieces_at_tile_index(old_playerIDs, old_pieceIDs, game, tile_index);
 for (int i = 0; i < count; ++i) {
  char old_flag = game->player[old_playerIDs[i]].flag;
  if (player->flag != old_flag) {
   CGPoint p_origin;
   FlagToOrigin(&p_origin, old_flag, old_pieceIDs[i]);
   Piece *old_piece = &game->player[old_playerIDs[i]].piece[old_pieceIDs[i]];
   old_piece->view.center = p_origin;
   old_piece->step_index = -1;
  }
 }
 
 /* Move the piece */
 [player->piece[move->pieceID].view setCenter:tile.point];
 player->piece[move->pieceID].step_index = next_si;
 
 step_game_forward(game);
}

static void move_type_base(Game *game, Move *move) {
 move_type_steps(game, move, 0);
}

static void move_type_home(Game *game, Move *move) {
 char flag = game->player[game->playerID].flag;
 CGPoint p_origin;
 FlagToOrigin(&p_origin, flag, move->pieceID);
 Piece *piece = &game->player[game->playerID].piece[move->pieceID];
 piece->view.center = p_origin;
 piece->step_index = -1;
 
 step_game_forward(game);
}

static void move_type_forward(Game *game, Move *move) {
 Player *player = &game->player[move->senderID];
 int next_si = player->piece[move->pieceID].step_index + move->steps;
 move_type_steps(game, move, next_si);
}

void StepGame(Game *game, Move *move){
 
 switch (move->type) {
  case kMoveType_Roll: move_type_dice(game, move); break;
  case kMoveType_Birth: move_type_base(game, move); break;
  case kMoveType_Death: move_type_home(game, move); break;
  case kMoveType_Step: move_type_forward(game, move);  break;
 }
}


/* Get moves from MoveQueue
 If new moves are found update the game,
 Delete the moves from the MoveQueue
 Save the game to file.
 */
void SyncGame(Game *game) {
 bool modified = false;
 
 /* TODO: Look for new moves from GameCenter */
 
 /* Look for new moves from AI */
 if (game->player[game->playerID].intel == kIntelligence_AI) {
  modified = PlayAI(game);
 }
 
 /* TODO: Remove the moves for human players from the Queue */
 
 if (modified) {
  StoreGameToFile(game);
 }
}


/************************************************************************
 MARK: Push moves
 ***********************************************************************/

/** Roll the dice, update the UI
 If no move is possible with the dice value, automatically step game forward.
 Invoked when a human touches the dice.
 */
void MakeDiceMove(Game *game) {
 /* Create a dice move */
 Move dice_move;
 dice_move.moveID = game->moveID++;
 dice_move.type = kMoveType_Roll;
 dice_move.gameID = game->gameID;
 dice_move.senderID = game->playerID;
 dice_move.recvID = game->playerID;
 dice_move.pieceID = -1;
 dice_move.steps = RollDice();
 
 /* Send the move to the queue */
 StepGame(game, &dice_move);
 // StoreAndForwardMove(&dice_move);
}

/** number of moves possible for the player
 Fills for each pieceIDs and steps it can take.
 The moves should be an array for all the moves possible
 Returns number of moves possible.
 */
int calc_possible_moves(Move *moves, ID playerID, Game *game) {
 Player *player = &game->player[playerID];
 int dice_val = game->dice_val;
 int move_count = 0;
 
 for (ID piecei = 0; piecei < 4; ++piecei) {
  int si = player->piece[piecei].step_index;

  if (si < 0 && dice_val == 6) {  /* if 6, launch a new piece move */
   moves[move_count].pieceID = piecei;
   moves[move_count].type = kMoveType_Birth;
   move_count++;
  } else if (si >= 0 && (si + dice_val) < MOVE_MAX) {  /* else move */
   moves[move_count].pieceID = piecei;
   moves[move_count].type = kMoveType_Step;
   move_count++;
  }
 }
 
 return move_count;
}

/* Invoked when a human touches a piece */
void MakePieceMove(Game *game, const ID playerID, const ID pieceID) {
 /* test if the player is legal   */
 if (game->playerID != playerID) {
  return;
 }
 
 /* Search for a move with requested playerID & pieceID */
 Move moves[4];
 int moves_count = calc_possible_moves(moves, game->playerID, game);
 if (!moves_count) {
  return; /* no moves */
 }

 Move *selected_mv = NULL;
 for (int i = 0; i < moves_count; ++i) {
  if (moves[i].pieceID == pieceID) {
   selected_mv = &moves[i];
   break;
  }
 }
 /* Fill the missing data */
 selected_mv->moveID = game->moveID++;
 //selected_mv->type = kMoveType_Roll;
 selected_mv->gameID = game->gameID;
 selected_mv->senderID = game->playerID;
 selected_mv->recvID = (playerID+1)%4;
 //selected_mv->pieceID = -1;
 selected_mv->steps = game->dice_val;

 StepGame(game, selected_mv);
 //StoreAndForwardMove(selected_mv);
 
 // Move m;
 // m.ppi.one = ppi->one;
 // m.ppi.two = ppi->two;
 // m.steps = game->dice_val;
 //
 // move(game, &m);
 // step_player(cpi, game);
 
 
 // step_game_forward(game);
}

void MakeRandomPieceMove(Game *game, ID playerID) {

 Move moves[4];
 int moves_count = calc_possible_moves(moves, playerID, game);
 if (!moves_count) {
  return; /* no moves */
 }
 
 /* Play the move at random */
 Move *selected_mv = &moves[rand()%moves_count];
 
 /* Fill the missing data */
 selected_mv->moveID = game->moveID++;
 //selected_mv->type = kMoveType_Roll;
 selected_mv->gameID = game->gameID;
 selected_mv->senderID = game->playerID;
 selected_mv->recvID = (playerID+1)%4;
 //selected_mv->pieceID = -1;
 selected_mv->steps = game->dice_val;

 StepGame(game, selected_mv);
 //StoreAndForwardMove(selected_mv);
}


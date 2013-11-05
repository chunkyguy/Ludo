//
//  LD_Game.m
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_Game.h"
#import "Prototype/LD_PieceView.h"
#import "Prototype/LD_RootViewController.h"

/************************************************************************
 MARK: SystemEnv
 ***********************************************************************/
void InitSystemEnv(SystemEnv *sys_env) {
 
}

int GameTypeCount(const SystemEnv *sys_env) {
 UInt32 gt[] = {
  kGameType_local,
  kGameType_online
 };
 
 int count = 0;
 int t_gt = sizeof(gt) / sizeof(gt[0]);
 for (int i = 0; i < t_gt; ++i) {
  if (sys_env->game_types & gt[i]) {
   count++;
  }
 }
 
 return count;
}



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
static void gen_tilemap(Tile map[][TILE_MAX]) {
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
   Set2i ppi = {i, j};
   game->player[i].piece[j].view =
   [[LD_PieceView alloc] initWithFrame:CGRectMake(origin.x, origin.y + center_offset[j].y, 50, 50)
                            playerPieceIndex:&ppi];
   game->player[i].piece[j].view.tag = PPIToTag(&ppi);
   game->player[i].piece[j].step_index = -1;
  }
 }
 
 game->turn = 0;
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

/* Returns the index of the current player */
int CurrentPlayerIndex(const Game *game) {
 return game->turn % 4;
}


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
 MARK: Utility
 ***********************************************************************/
static char flags[] = {'r', 'b', 'y', 'g'};

int FlagToIndex(const char flag) {
 int index = 0;

 while ((flags[index++] != flag)){
  assert(index < 4);
 }
 
 return index;
}

char IndexToFlag(int index) {
 return flags[index];
}

int PPIToTag(const Set2i *ppi) {
 return ppi->one * 10 + ppi->two;
}

void TagtoPPI(Set2i *ppi, int tag) {
 ppi->one = tag/10;
 ppi->two = tag%10;
}

/** Get the color for a flag value
 @param color An array of 4 floats.
 @param flag The flag {rgby}
 */
float *FlagToColor(float color[], const char flag) {
 color[0] = 0.0f;
 color[1] = 0.0f;
 color[2] = 0.0f;
 color[3] = 1.0f;
 
 switch (flag) {
  case 'r': color[0] = 1.0f;   break;
  case 'g': color[1] = 1.0f;   break;
  case 'b': color[2] = 1.0f;   break;
  case 'y': color[0] = 1.0f; color[1] = 1.0f;   break;
 }
 return color;
}

/* The center point where the pieces stand at the beginning */
CGPoint *FlagToOrigin(CGPoint *origin, const char flag, int offset_index) {
 
 switch (flag) {
  case 'r': origin->x = 600.0f; origin->y = 200.0f;   break;
  case 'g': origin->x = 100.0f; origin->y = 200.0f;   break;
  case 'b': origin->x = 600.0f; origin->y = 800.0f;   break;
  case 'y': origin->x = 100.0f; origin->y = 800.0f;   break;
 }
 
 CGPoint center_offset[] = {
  {-50, -50},
  {50, -50},
  {-50, 50},
  {50, 50}
 };
 origin->x += center_offset[offset_index].x;
 origin->y += center_offset[offset_index].y;
 
 return origin;
}

/* 	Call some action after delay */
void DispatchEvent(float delay_secs, DispatchEventAction action) {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_secs * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  action();
 });
}

/** Returns a value in set [1.6] */
static int roll_dice() {
 return rand() % 6 + 1;
}



/************************************************************************
 MARK: Moves
 ***********************************************************************/
/** Path map: maps to all the possible location any piece can have
 If you watch closely, you can see a pattern.
 I was just being lazy, to calculate it programatically.
 */
int g_PathMap[4][MOVE_MAX] = {
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

/* Search for player-piece set at given index
 Store the results in set. The set should have enough space to hold the data.
 Typically for 16 pieces, it should not exceed 15
 Return number of sets found.
 */
static int SearchPlayerPiecesAtTileIndex(Set2i *set, Game *game, int tile_index) {
 int count = 0;
 for (int player_index = 0; player_index < 4; ++player_index) {
  for (int piece_index = 0; piece_index < 4; ++piece_index) {
   int si = game->player[player_index].piece[piece_index].step_index;
   if (g_PathMap[player_index][si] == tile_index) {
    set[count].one = player_index;
    set[count].two = piece_index;
    count++;
   }
  }
 }
 
 return count;
}

typedef struct {
 Set2i ppi;
 int steps;
} Move;

/** Move a give piece forward steps
 @param playerpiece_index The set of {player_index, piece_index}
 @param steps Number of steps to be moved forward.
 @note If steps < 0, then moves to the home tile i.e. step # 0.
 */
static void move(Game *game, Move *move) {

 Player *player = &game->player[move->ppi.one];
 int next_si = player->piece[move->ppi.two].step_index + move->steps;
 if (move->steps < 0) {
  next_si = 0;
 }
 int tile_index = g_PathMap[move->ppi.one][next_si];
 Tile tile = game->map[tile_index/15][tile_index%15];
 
 /* test if there is something already at that tile
  Otherwise, it dies it and goes back to where it came from.
  Except for the same flag pieces.
  */
 Set2i old_ppi[15];
 int old_ppi_count = SearchPlayerPiecesAtTileIndex(old_ppi, game, tile_index);
 for (int i = 0; i < old_ppi_count; ++i) {
  char old_flag = game->player[old_ppi[i].one].flag;
  if (player->flag != old_flag) {
   CGPoint p_origin;
   FlagToOrigin(&p_origin, old_flag, old_ppi[i].two);
   Piece *old_piece = &game->player[old_ppi[i].one].piece[old_ppi[i].two];
   old_piece->view.center = p_origin;
   old_piece->step_index = -1;
  }
 }
 
 /* Move the piece */
 [player->piece[move->ppi.two].view setCenter:tile.point];
 player->piece[move->ppi.two].step_index = next_si;
}

/** number of moves possible for the player 
  The moves should be an array for all the moves possible (less than 8)
  Returns number of moves possible.
 */
static int calc_possible_moves(Move *moves, int player_index, Game *game) {
 Player *player = &game->player[player_index];
 int dice_val = game->dice_val;
 int move_count = 0;
 
 /* if 6, launch a new piece move */
 if (dice_val == 6) {
  for (int piecei = 0; piecei < 4; ++piecei) {
   int si = player->piece[piecei].step_index;
   if (si < 0) {
    moves[move_count].ppi.one = player_index;
    moves[move_count].ppi.two = piecei;
    moves[move_count].steps = -1;
    move_count++;
   }
  }
 }
 
 /* else move */
 for (int piecei = 0; piecei < 4; ++piecei) {
  int si = player->piece[piecei].step_index;
  if (si >= 0 && (si + dice_val) < MOVE_MAX) {
   moves[move_count].ppi.one = player_index;
   moves[move_count].ppi.two = piecei;
   moves[move_count].steps = dice_val;
   move_count++;
  }
 }
 
 return move_count;
}

/** Step the player. Used by the AI */
static void step_player(int player_index, Game *game) {
 Move moves[8];
 int moves_count = calc_possible_moves(moves, player_index, game);

 /* Play the first move possible */
 for (int i = 0; i < moves_count; ++i) {
  move(game, &moves[i]);
  break;
 }
}

static void step_game_forward(Game *game) {
 /* Update the game state*/
 kGameState state = GameState(game);

 /* After all animations are over, move to next player */
 game->turn++;
 
 /* Update the GUI */
 [game->gui updatePieces:game state:state];
}

static void step_game_dice(Game *game, int dice_val) {
 game->dice_val = dice_val;
 /* animate the dice and update the view */
 [game->gui updateDice:game];
 
 /* test if dice value is not playable, else move forward with the game */
 Move moves[8];
 int movesc = calc_possible_moves(moves, CurrentPlayerIndex(game), game);
 if (movesc == 0) {
  step_game_forward(game);
 }
}


/************************************************************************
 MARK: Touch Events
 ***********************************************************************/
void HandlePieceTouchEvent(Game *game, const Set2i *ppi) {
 /* test if the player is legal   */
 int cpi = CurrentPlayerIndex(game);
 if (cpi != ppi->one) {
  return;
 }
 
 /* step the game. By this time the dice should have the value.
  Update UI
  */
 step_player(cpi, game);
 

 step_game_forward(game);
}

void HandleDiceTouchEvent(Game *game) {
 step_game_dice(game, roll_dice());
}




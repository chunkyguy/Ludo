//
//  LD_RootViewController.m
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_RootViewController.h"

#define kCheatcode_autoplay
#define kCheatcode_dice

#define TILE_MAX 15
#define MOVE_MAX 57
/************************************************************************
 MARK: pathmap
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

/************************************************************************
 MARK: Utility
 ***********************************************************************/
/** Get the color for a flag value 
@param color An array of 4 floats.
 @param flag The flag {rgby}
 */
static float *flag_to_color(float color[], const char flag) {
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
static CGPoint *flag_to_origin(CGPoint *origin, const char flag, int offset_index) {
 
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

typedef void(^DispatchEventAction)(void);
/* 	Call some action after delay */
static void DispatchEvent(float delay_secs, DispatchEventAction action) {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay_secs * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  action();
 });
}

/** Returns a value in set [1.6] */
static int RollDice() {
 return rand() % 6 + 1;
}

/************************************************************************
 MARK: Piece
 ***********************************************************************/
@interface LD_PieceView : UIView
@property (nonatomic, assign) char flag;
@end

@implementation LD_PieceView
@synthesize flag;

-(void) drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGFloat color[4];
 CGContextSetFillColor(context, flag_to_color(color, self.flag));
 CGContextFillEllipseInRect(context, self.bounds);
}
@end

typedef struct {
 LD_PieceView *view;
 int step_index; /* map to g_PathMap to get the point on screen */
} Piece;


/************************************************************************
 MARK: Game
 ***********************************************************************/
typedef struct {
 Piece piece[4];
 char flag;
} Player;

typedef struct {
 int one;
 int two;
} Set2i;

typedef struct  {
 CGPoint point;
} Tile;

typedef struct {
 int turn;
 Player player[4];
 int dice_val;
 Tile map[TILE_MAX][TILE_MAX];
} Game;

//static void PrintTilemap(Tile map[][TILE_MAX]) {
// for (int i = 0; i < TILE_MAX; ++i) {
//  for (int j = 0; j < TILE_MAX; ++j) {
//   printf("[%d,%d] = {%.2f,%.2f}\n", i, j,map[i][j].point.x, map[i][j].point.y);
//  }
//  printf("\n");
// }
//}

/* fill init tilemap */
static void GenTilemap(Tile map[][TILE_MAX]) {
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
static void GenGame(Game *game) {
 char flags[] = {
  'r', 'b', 'y', 'g'
 };

 /* create tilemap */
 GenTilemap(game->map);

 /* create players */
 CGPoint origin;
 CGPoint center_offset[] = {
  {-50, -50},
  {50, -50},
  {-50, 50},
  {50, 50}
 };
 for (int i = 0; i < 4; ++i) {
  game->player[i].flag = flags[i];
  for (int j = 0; j < 4; ++j) {
   flag_to_origin(&origin, flags[i], j);
   game->player[i].piece[j].view = [[LD_PieceView alloc] initWithFrame:CGRectMake(origin.x, origin.y + center_offset[j].y, 50, 50)];
   game->player[i].piece[j].step_index = -1;
   game->player[i].piece[j].view.flag = flags[i];
  }
 }
 
 game->turn = 0;
}

/* Release any resources occupied at GenGame */
static void DeleteGame(Game *game) {
 /* delete players */
 for (int i = 0; i < 4; ++i) {
  for (int j = 0; j < 4; ++j) {
   [game->player[i].piece[j].view release];
  }
 }
}

/* Search for player-piece set at given index
 Store the result in set.
 Return false, if not found.
 */
static bool SearchPlayerPieceAtTileIndex(Set2i *set, Game *game, int tile_index) {
 for (set->one = 0; set->one < 4; ++set->one) {
  for (set->two = 0; set->two < 4; ++set->two) {
   int si = game->player[set->one].piece[set->two].step_index;
   if (g_PathMap[set->one][si] == tile_index) {
     return true;
   }
  }
 }
 
 return false;
}

/** Move a give piece forward steps 
  @param playerpiece_index The set of {player_index, piece_index}
  @param steps Number of steps to be moved forward. 
  @note If steps < 0, then moves to the home tile i.e. step # 0.
 */
static void MovePlayerPiece(Game *game, Set2i *playerpiece_index, int steps) {
 Player *player = &game->player[playerpiece_index->one];
 int next_si = player->piece[playerpiece_index->two].step_index + steps;
 if (steps < 0) {
  next_si = 0;
 }
 int tile_index = g_PathMap[playerpiece_index->one][next_si];
 Tile tile = game->map[tile_index/15][tile_index%15];
 
 /* test if there is something already at that tile
  	Otherwise, it dies it and goes back to where it came from.
  */
 Set2i old_ppi;
 if (SearchPlayerPieceAtTileIndex(&old_ppi, game, tile_index)) {
  char old_flag = game->player[old_ppi.one].flag;
  if (player->flag != old_flag) {
   CGPoint p_origin;
   flag_to_origin(&p_origin, old_flag, old_ppi.two);
   Piece *old_piece = &game->player[old_ppi.one].piece[old_ppi.two];
   old_piece->view.center = p_origin;
   old_piece->step_index = -1;
  }
 }
 
 /* Move the piece */
 [player->piece[playerpiece_index->two].view setCenter:tile.point];
 player->piece[playerpiece_index->two].step_index = next_si;
}

/** Step the player */
static void StepPlayer(int player_index, Game *game) {
 Player *player = &game->player[player_index];
 int dice_val = game->dice_val;
 Set2i playerpiece_set = {
  player_index,
  0
 };
 
 /* if 6, launch a new piece */
 if (dice_val == 6) {
  for (playerpiece_set.two = 0; playerpiece_set.two < 4; ++playerpiece_set.two) {
   int si = player->piece[playerpiece_set.two].step_index;
   if (si < 0) {
    MovePlayerPiece(game, &playerpiece_set, -1);
    return;
   }
  }
 }

 /* else move first piece visible */
 for (playerpiece_set.two = 0; playerpiece_set.two < 4; ++playerpiece_set.two) {
  int si = player->piece[playerpiece_set.two].step_index;
  if (si >= 0 && (si + dice_val) < MOVE_MAX) {
   MovePlayerPiece(game, &playerpiece_set, dice_val);
   return;
  }
 }
}


/** Move game one step further. Expect the dice value to be already filled and in range [1,6]
  The turn also advances forward.
 */
static void StepGame(Game *game) {
 int player_index = game->turn%4;
 StepPlayer(player_index, game);
 game->turn++;
}

/** Ordering matters. It's in the order the player's play */
typedef enum {
 kGameState_RedWins,
 kGameState_GreenWins,
 kGameState_YellowWins,
 kGameState_BlueWins,
 kGameState_None
} kGameState;

/** Current game state */
static kGameState GameState(const Game *game) {
 kGameState states[] = {
  kGameState_RedWins,
  kGameState_GreenWins,
  kGameState_YellowWins,
  kGameState_BlueWins,
  kGameState_None
};
 
 for (int i = 0; i < 4; ++i) {
  int players_home = 0;
  for (int j = 0; j < 4; ++j) {
   if (game->player[i].piece[j].step_index == MOVE_MAX-1) {
    players_home++;
   }
  }
  if (players_home == 3) {
   return states[i];
  }
 }
 return kGameState_None;
}

/************************************************************************
MARK: LD_CellView
 ***********************************************************************/
/** The view that has grid drawn to it */
@interface LD_CellView ()
@end

@implementation LD_CellView
/** Draw the grid */
-(void)drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 if (self.bounds.size.width > self.bounds.size.height) {
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  CGFloat dx = width/6;
  CGFloat dy = height/3;
  CGPoint points[] = {
   //rows
   {0,dy}, {width, dy},
   {0,dy*2}, {width, dy*2},
   //cols
   {dx, 0}, {dx, height},
   {dx*2, 0}, {dx*2, height},
   {dx*3, 0}, {dx*3, height},
   {dx*4, 0}, {dx*4, height},
   {dx*5, 0}, {dx*5, height},
  };
  CGContextStrokeLineSegments(context, points, sizeof(points)/sizeof(points[0]));
 } else {
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  CGFloat dx = width/3;
  CGFloat dy = height/6;
  CGPoint points[] = {
   //rows
   {0,dy}, {width, dy},
   {0,dy*2}, {width, dy*2},
   {0,dy*3}, {width, dy*3},
   {0,dy*4}, {width, dy*4},
   {0,dy*5}, {width, dy*5},
   //cols
   {dx, 0}, {dx, height},
   {dx*2, 0}, {dx*2, height},
  };
  CGContextStrokeLineSegments(context, points, sizeof(points)/sizeof(points[0]));
 }
}
@end

/************************************************************************
 MARK: LD_RootViewController
 ***********************************************************************/
@interface LD_RootViewController () {
 BOOL isPaused;
 NSMutableArray *games;
 Game game;
#if defined (kCheatcode_dice)
 int cheat_value;
#endif
}
-(NSString *) saveFilePath;
-(BOOL) saveData;
@end

@implementation LD_RootViewController

-(NSString *) saveFilePath {
 return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"game.plist"];
}

-(BOOL) saveData {
 return [games writeToFile:[self saveFilePath] atomically:YES];
}

-(void) dealloc {
 [games release];
 DeleteGame(&game);
 [_diceView release];
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];
 //LuaInit();
 isPaused = NO;
 if ([[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePath]]) {
  games = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
 } else {
  games = [[NSMutableArray alloc] init];
 }

 GenGame(&game);
 [self updateBackground];
}

-(void) viewDidAppear:(BOOL)animated {
 [super viewDidAppear:YES];
 for (int i = 0; i < 4; ++i) {
  for (int j = 0; j < 4; ++j) {
   [self.view addSubview: game.player[i].piece[j].view];
  }
 }
 
#if defined (kCheatcode_autoplay)
 [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoplay:) userInfo:nil repeats:YES];
#endif
}

#if defined (kCheatcode_autoplay)
-(void) autoplay:(NSTimer *) timer {
 [self next];
 if (GameState(&game) != kGameState_None) {
  [timer invalidate];
 }
}
#endif


- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

- (IBAction)pause:(UIButton *)sender {
 if (isPaused) {
  isPaused = NO;
  [self.pauseView setHidden:YES];
 } else {
  isPaused = YES;
  [self.pauseView setHidden:NO];
 }
}

- (IBAction)newGame:(UISegmentedControl *)sender {
 switch (sender.selectedSegmentIndex) {
  case 0: // local (bluetooth/wifi)
   break;
   
  case 1: // online
   break;
   
  case 2: // computer
   break;
  default:
   break;
 }
}

- (IBAction)cheatDice:(UISegmentedControl *)sender {
#if defined (kCheatcode_dice)
 cheat_value = sender.selectedSegmentIndex + 1;
#endif
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return [games count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
 if (!cell) {
  cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GameCell"] autorelease];
 }
 return cell;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 CGPoint touch_pt = [touch locationInView:nil];
 if (CGRectContainsPoint(self.diceView.frame, touch_pt)) {
  [self next];
 }
}

/** Step forward the game.
  Roll the dice and update the game state + UI 
 */
-(void) next {
 if (GameState(&game) != kGameState_None) {
  NSString *msg = @"";
  switch (GameState(&game)) {
   case kGameState_RedWins: 	msg = @"Red Wins"; break;
   case kGameState_BlueWins: 	msg = @"Blue Wins"; break;
   case kGameState_YellowWins: 	msg = @"Yellow Wins"; break;
   case kGameState_GreenWins: 	msg = @"Green Wins"; break;
   case kGameState_None: break;
  }
  UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Game Over" message:msg delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
  [alrt show];
  [alrt release];
 }
 

 game.dice_val = RollDice();
#if defined (kCheatcode_dice)
 game.dice_val = cheat_value;
#endif
 [self.diceView setText:[NSString stringWithFormat:@"%d",game.dice_val]];
 
 DispatchEvent(0.5f, ^{
  StepGame(&game);
  DispatchEvent(1.0f, ^{
   [self updateBackground];
  });
 });
 
}

-(void) updateBackground {
 char flags[] = {'r','b','y','g'};
 float color[4];
 flag_to_color(color, flags[game.turn%4]);
 [self.view setBackgroundColor:[UIColor colorWithRed:color[0] green:color[1] blue:color[2] alpha:0.5]];
 self.diceView.text = @"-";
}

@end

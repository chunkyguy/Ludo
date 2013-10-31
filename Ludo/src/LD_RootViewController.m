//
//  LD_RootViewController.m
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_RootViewController.h"

#import "lua/include/lua.h"
#import "lua/include/lualib.h"
#import "lua/include/lauxlib.h"

//lua_State *L;
//
//static int average() {
// /* get number of arguments */
// int n = lua_gettop(L);
// double sum = 0.0;
// 
// /* loop through args */
// for (int i = 1; i <=n; i++) {
//  sum += lua_tonumber(L, i);
// }
// 
// lua_pushnumber(L, sum/n);	/* push average */
// lua_pushnumber(L, sum);	/* push sum */
// 
// return 2;	/* return num of results*/
//}
//
//static int Add(int x, int y) {
// int sum;
// 
// /* the function name */
// lua_getglobal(L, "add");
// /* pass args */
// lua_pushnumber(L, x);
// lua_pushnumber(L, y);
// /* call function with 2 args and 1 return */
// lua_call(L, 2, 1);
// /* get result */
// sum = lua_tointeger(L, -1);
// lua_pop(L, 1);
// return sum;
//}
//
//static void LuaInit() {
///* initialze lua */
// L = luaL_newstate();
//
// /* load lua libs */
// luaL_openlibs(L);
// 
// /* register function, will be called from lua */
// lua_register(L, "average", average);
// 
// /* run script that calls C function from Lua */
// NSString *script_path = [[NSBundle mainBundle] pathForResource:@"avg" ofType:@"lua"];
// luaL_dofile(L, [script_path UTF8String]);
// 
// /* run script that calls Lua function from C */
// script_path = [[NSBundle mainBundle] pathForResource:@"add" ofType:@"lua"];
// luaL_dofile(L, [script_path UTF8String]);
// printf("sum = %d,",Add(10,20));
// 
// /* cleanup lua */
// lua_close(L);
// 
//}

#define TILE_MAX 15
#define MOVE_MAX 56
/************************************************************************
 MARK: Tilemap
 ***********************************************************************/
typedef struct  {
 CGPoint point;
 char flag;
} Tile;

Tile g_Tilemap[TILE_MAX][TILE_MAX];

int g_PathMap[4][MOVE_MAX] = {
 /* red */
 {
  23,38,53,68,83,99,101,102,103,104,119,
  134,
  133,132,131,130,129,143,158,173,188, 203,218,217,
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  22,37,5267,82
 },
 
 /* blue */
 {
  133,132,131,130,129,143,158,173,188, 203,218,217,
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  8,
  23,38,53,68,83,99,101,102,103,104,119,
  118,117,116,115,114
 },
 
 /* yellow */
 {
  201,186,171,156,141,125,124,123,122,121,120,105,
  90,
  91,92,93,94,95,81,66,51,36,21,6,7,
  8,
  23,38,53,68,83,99,101,102,103,104,119,
  134,
  133,132,131,130,129,143,158,173,188, 203,218,217,
  202,187,172,157,142
 },
 
 /* green */
 {
  91,92,93,94,95,81,66,51,36,21,6,7,
  8,
  23,38,53,68,83,99,101,102,103,104,119,
  134,
  133,132,131,130,129,143,158,173,188, 203,218,217,
  216,
  201,186,171,156,141,125,124,123,122,121,120,105,
  106,107,108,109,110
 }
};

void GenTilemap() {
 CGFloat minx = 20.0f;
 CGFloat miny = 20.0f;
 CGFloat maxx = 800.0f;
 CGFloat maxy = 1080.0f;
 CGFloat dx = (maxx - minx)/TILE_MAX;
 CGFloat dy = (maxy - miny)/TILE_MAX;
 char *map =
 "xxxxxx000xxxxxx"
 "xxxxxx0r0xxxxxx"
 "xxxxxx0r0xxxxxx"
 "xxxxxx0r0xxxxxx"
 "xxxxxx0r0xxxxxx"
 "xxxxxx0r0xxxxxx"
 "000000hhh000000"
 "0ggggghhhbbbbb0"
 "000000hhh000000"
 "xxxxxx0y0xxxxxx"
 "xxxxxx0y0xxxxxx"
 "xxxxxx0y0xxxxxx"
 "xxxxxx0y0xxxxxx"
 "xxxxxx0y0xxxxxx"
 "xxxxxx000xxxxxx"
 ;
 
 for (int i = 0; i < TILE_MAX; ++i) {
  for (int j = 0; j < TILE_MAX; ++j) {
   g_Tilemap[i][j].point = CGPointMake(minx + (j*dx), miny + (i*dy));
   g_Tilemap[i][j].flag = map[i+TILE_MAX*j];
  }
 }
}

/************************************************************************
 MARK: Utility
 ***********************************************************************/
static float *flag_to_color(float *color, const char flag) {
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
 int turn;
 Player player[4];
} Game;

static void GenGame(Game *game) {
 char flags[] = {
  'r', 'b', 'y', 'g'
 };

 /* create players */
 for (int i = 0; i < 4; ++i) {
  game->player[i].flag = flags[i];
  for (int j = 0; j < 4; ++j) {
   game->player[i].piece[j].step_index = -1;
   game->player[i].piece[j].view = [[LD_PieceView alloc] initWithFrame:CGRectMake(-100, 0, 50, 50)];
   game->player[i].piece[j].view.flag = flags[i];
  }
 }
 
 game->turn = 0;
}

static void DeleteGame(Game *game) {
 /* delete players */
 for (int i = 0; i < 4; ++i) {
  for (int j = 0; j < 4; ++j) {
   [game->player[i].piece[j].view release];
  }
 }
}

static void DrawPiece(Piece *p, int player_index) {
 int tile_index = g_PathMap[player_index][p->step_index];
 Tile tile = g_Tilemap[tile_index/15][tile_index%15];
 [p->view setCenter:tile.point];
}

static void StepPlayer(Player *p, int player_index, int roll) {
/* if 6, launch a new piece
 dumb strategy, move first piece visible */
 bool moved = false;
 for (int i = 0; i < 4 && !moved; ++i) {
  if ((p->piece[i].step_index >= 0) && (p->piece[i].step_index + roll < MOVE_MAX)) {
   p->piece[i].step_index += roll;
   DrawPiece(&p->piece[i], player_index);
   moved = true;
  } else if (roll == 6) {
   p->piece[i].step_index = 0;
   DrawPiece(&p->piece[i], player_index);
   moved = true;
  }
 }
}


/**
 	Move game one step further. Return the current dice value [1,6]
 */
static int StepGame(Game *game) {
 int dice_val = rand()%6 + 1;
 int player_index = game->turn%4;
 StepPlayer(&game->player[player_index], player_index, dice_val);
 game->turn++;
 return dice_val;
}


/************************************************************************
MARK: LD_CellView
 ***********************************************************************/
@interface LD_CellView ()
@end

@implementation LD_CellView
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

 GenTilemap();
 GenGame(&game);
 
 [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
}

-(void) viewDidAppear:(BOOL)animated {
 [super viewDidAppear:YES];
 for (int i = 0; i < 4; ++i) {
  for (int j = 0; j < 4; ++j) {
   [self.view addSubview: game.player[i].piece[j].view];
  }
 }
}

- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

-(void) update:(NSTimer *)timer {
 /* update */
 int dv = StepGame(&game);
 [self.diceView setText:[NSString stringWithFormat:@"%d",dv]];
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
@end

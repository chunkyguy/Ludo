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
 MARK: pathmap
 ***********************************************************************/
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

/************************************************************************
 MARK: Utility
 ***********************************************************************/
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
static CGPoint *flag_to_origin(CGPoint *center, const char flag) {
 
 switch (flag) {
  case 'r': center->x = 600.0f; center->y = 200.0f;   break;
  case 'g': center->x = 100.0f; 	center->y = 200.0f;   break;
  case 'b': center->x = 600.0f; center->y = 800.0f;   break;
  case 'y': center->x = 100.0f; 	center->y = 800.0f;   break;
 }
 
 return center;
}

typedef void(^DispatchEventAction)(void);
void DispatchEvent(float secs, DispatchEventAction action) {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){action();});
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

typedef struct  {
 CGPoint point;
 char flag;
} Tile;

typedef struct {
 int turn;
 Player player[4];
 int dice_val;
 Tile map[TILE_MAX][TILE_MAX];
} Game;

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
   map[i][j].flag = 'x';
  }
 }
}

static void GenGame(Game *game) {
 char flags[] = {
  'r', 'b', 'y', 'g'
 };

 /* create tilemap */
 GenTilemap(game->map);

 /* create players */
 CGPoint center;
 CGPoint center_offset[] = {
  {-50, -50},
  {50, -50},
  {-50, 50},
  {50, 50}
 };
 for (int i = 0; i < 4; ++i) {
  game->player[i].flag = flags[i];
  flag_to_origin(&center, flags[i]);
  for (int j = 0; j < 4; ++j) {
   game->player[i].piece[j].step_index = -1;
   game->player[i].piece[j].view = [[LD_PieceView alloc] initWithFrame:CGRectMake(center.x + center_offset[j].x, center.y + center_offset[j].y, 50, 50)];
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

static void StepPlayer(int player_index, Game *game) {
 Player *player = &game->player[player_index];
 int dice_val = game->dice_val;
 bool can_move = false;
 Piece *piece = NULL;
 
 /* if 6, launch a new piece
  dumb strategy, move first piece visible */
 for (int i = 0; i < 4 && !can_move; ++i) {
  piece = &player->piece[i];
  
  if ((piece->step_index >= 0) && (piece->step_index + dice_val < MOVE_MAX)) {
   piece->step_index += dice_val;
   can_move = true;
  } else if (dice_val == 6) {
   piece->step_index = 0;
   can_move = true;
  }
 }

 /* update state */
 if (can_move && piece) {
  int tile_index = g_PathMap[player_index][piece->step_index];
  Tile tile = game->map[tile_index/15][tile_index%15];
  tile.flag = player->flag;
  [piece->view setCenter:tile.point];
 }
}


/**
 	Move game one step further. Expect the dice value in range [1,6]
 */
static void StepGame(Game *game) {
 int player_index = game->turn%4;
 StepPlayer(player_index, game);
 game->turn++;
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
}

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

  game.dice_val = rand()%6 + 1;
  [self.diceView setText:[NSString stringWithFormat:@"%d",game.dice_val]];

  DispatchEvent(0.5f, ^{
   StepGame(&game);
   DispatchEvent(1.0f, ^{
    [self updateBackground];
   });
  });
 }
}

-(void) updateBackground {
 char flags[] = {'r','b','y','g'};
 float color[4];
 flag_to_color(color, flags[game.turn%4]);
 [self.view setBackgroundColor:[UIColor colorWithRed:color[0] green:color[1] blue:color[2] alpha:0.5]];
 self.diceView.text = @"-";
}

@end

//
//  LD_MenuController.m
//  Ludo
//
//  Created by Sid on 04/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_MenuController.h"

#import <GameKit/GameKit.h>

#import "../LD_File.h"
#import "../LD_Settings.h"
#import "../LD_Context.h"
#import "../LD_Constants.h"
#import "../LD_MoveQueue.h"

#import "LD_RootViewController.h"

#define MAX_GAMES 256	/* Assuming a big enough number of number of games the user might be playing */

typedef struct {
 int pending_moves; /* pending moves per game */
 /* Other details like game name, users, timestamp, .. here  */
} GameInfo;

@interface LD_MenuController () {
 int game_count;
 ID gameIDs[MAX_GAMES];
 GameInfo games[MAX_GAMES];
}
@property (nonatomic, retain) NSTimer *fetchgames_timer;
@end

@implementation LD_MenuController
@synthesize fetchgames_timer;

-(void) dealloc {
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];
 [self init_game_center];
}

-(void) viewWillAppear:(BOOL)animated {
 [super viewWillAppear:YES];
 
 self.fetchgames_timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(refreshGameList) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:YES];
 [self.fetchgames_timer invalidate];
 self.fetchgames_timer = nil;
}

- (void)didReceiveMemoryWarning
{
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return game_count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameCell"];
 if (!cell) {
  cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GameCell"] autorelease];
 }
 cell.textLabel.text = [NSString stringWithFormat:@"Game: %ld",gameIDs[indexPath.row]];
 cell.detailTextLabel.text = [NSString stringWithFormat:@"Pending: %d",games[indexPath.row].pending_moves];
 return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/* Load game and update context */
 ID gid = gameIDs[indexPath.row];
 Game game;
 memcpy(&(CurrentContext()->game), LoadGameFromFile(&game, gid), sizeof(game));

 LD_RootViewController *game_ctrl = [[LD_RootViewController alloc] initWithNibName:nil bundle:nil];
 [self.navigationController presentViewController:game_ctrl animated:YES completion:NULL];
 [game_ctrl release];
}

-(void) refreshGameList {
 game_count = TotalSavedGames(gameIDs);
// for (int g = 0; g < game_count; ++g) {
//  Move moves[10];
//  int mc = 0;
//  for (ID pid = 0; pid < 4; ++pid) {
//   mc += StoredMoves(moves, gameIDs[g], pid);
//  }
//  games[g].pending_moves = mc;
// }
}

#pragma mark - Game center
-(void) init_game_center {
 
 GKLocalPlayer *player = [GKLocalPlayer localPlayer];
 [player setAuthenticateHandler:^(UIViewController *controller, NSError *error) {
  Context *c = CurrentContext();

  c->sysenv.game_types = kGameType_local;

  if (controller) {
   [self.navigationController presentViewController:controller animated:YES completion:NULL];
  } else if (player.isAuthenticated) {
   /* Player authenticated. Continue */
   c->sysenv.game_types |= kGameType_online;
  } else {
   /* GameCenter disabled */
  }
 }];
}
@end




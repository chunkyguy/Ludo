//
//  LD_MenuController.m
//  Ludo
//
//  Created by Sid on 04/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_MenuController.h"
#import <GameKit/GameKit.h>
#import "LD_GameContext.h"

@interface LD_MenuController () {
 NSMutableArray *games;
 GameContext context;
}
-(NSString *) save_file_path;
-(BOOL) save_data;
@end

@implementation LD_MenuController

-(void) dealloc {
 UnbindContext();
 [games release];
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];

 BindContext(&context);
 
 [self init_game_center];
 
 if ([[NSFileManager defaultManager] fileExistsAtPath:[self save_file_path]]) {
  games = [[NSMutableArray alloc] initWithContentsOfFile:[self save_file_path]];
 } else {
  games = [[NSMutableArray alloc] init];
 }
}

- (void)didReceiveMemoryWarning
{
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
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

#pragma mark - Save game
-(NSString *) save_file_path {
 return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"game.plist"];
}

-(BOOL) save_data {
 return [games writeToFile:[self save_file_path] atomically:YES];
}

#pragma mark - Game center
-(void) init_game_center {
 
 GKLocalPlayer *player = [GKLocalPlayer localPlayer];
 [player setAuthenticateHandler:^(UIViewController *controller, NSError *error) {
  GameContext *c = CurrentContext();

  c->sysenv.game_types = kGameType_local;

  if (controller) {
   [self.navigationController presentViewController:controller animated:YES completion:NULL];
  } else if (player.isAuthenticated) {
   /* Player authenticated. Continue */
   c->sysenv.game_types |= kGameType_online;
  } else {
   /* GameCenter disabled */
  }
  
  InitSystemEnv(&c->sysenv);
 }];
}
@end




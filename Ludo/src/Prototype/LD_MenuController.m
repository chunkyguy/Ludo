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
#import "LD_Prototype.h"
#import "LD_MoveQueue.h"

@interface LD_MenuController () {
 GameContext context;
 Move moves_buffer[256];
}
@end

@implementation LD_MenuController

-(void) dealloc {
 UnbindContext();
 UnbindMoveQueueBuffer();
 [LD_Prototype Destroy];
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];

 BindContext(&context);
 BindMoveQueueBuffer(moves_buffer, sizeof(moves_buffer));
 [self init_game_center];

 [LD_Prototype Create];
}

- (void)didReceiveMemoryWarning
{
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return [LD_Prototype gamesCount];
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




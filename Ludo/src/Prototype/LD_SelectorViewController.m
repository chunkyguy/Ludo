//
//  LD_SelectorViewController.m
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_SelectorViewController.h"
#import "LD_Prototype.h"

#import "../LD_Context.h"
#import "../LD_Constants.h"
#import "../LD_File.h"

/* Maps with the segment titles in the xib/storuboard */
static kIntelligence index_to_intelligence(int index) {
 kIntelligence intel;
 
 switch (index) {
  case 0: intel = kIntelligence_Human; break;
  case 1: intel = kIntelligence_AI; break;
  default: assert(0); break; /* No intelligence found! */
 }
 
 return intel;
}

static Game *finalize_players(Game *game, int intelindex[MAX_PLAYERS]) {
 /* Assign intelligence */
 for (int i = 0; i < MAX_PLAYERS; ++i) {
	 game->player[i].intel = index_to_intelligence(intelindex[i]);
 }
 
 /* Could run some tests to check if the context is in valid state
  and return NO  */
 return game;
}

@interface LD_SelectorViewController ()
@end

@implementation LD_SelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
 [_redSelector release];
 [_blueSelector release];
 [_yellowSelector release];
 [_greenSelector release];
 [super dealloc];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
 if ([identifier isEqualToString:kSegue_displayGameController]) {

  Game new_game;
  int intelindex[MAX_PLAYERS] = {
   _redSelector.selectedSegmentIndex,
   _blueSelector.selectedSegmentIndex,
   _yellowSelector.selectedSegmentIndex,
   _greenSelector.selectedSegmentIndex,
  };
  
  finalize_players(&new_game, intelindex);

  /* Update the context */
  Context *context = CurrentContext();
  memcpy(&context->game, &new_game, sizeof(new_game));
 }
 return YES;
}

@end

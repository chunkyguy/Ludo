//
//  LD_SelectorViewController.m
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_SelectorViewController.h"
#import "LD_Prototype.h"
#import "LD_GameContext.h"

/* Maps with the segment titles in the xib/storuboard */
static kIntelligence segment_to_intelligence(NSInteger seg_index) {
 kIntelligence intel;
 
 switch (seg_index) {
  case 0: intel = kIntelligence_Human; break;
  case 1: intel = kIntelligence_AI; break;
  default: assert(0); break; /* No intelligence found! */
 }
 
 return intel;
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
  GameContext *context = CurrentContext();
  
  /* Assign intelligence */
  context->game.player[0].intel = segment_to_intelligence(_redSelector.selectedSegmentIndex);
  context->game.player[1].intel = segment_to_intelligence(_blueSelector.selectedSegmentIndex);
  context->game.player[2].intel = segment_to_intelligence(_yellowSelector.selectedSegmentIndex);
  context->game.player[3].intel = segment_to_intelligence(_greenSelector.selectedSegmentIndex);

  /* Could run some tests to check if the context is in valid state 
    and return NO  */
 }
 return YES;
}

@end

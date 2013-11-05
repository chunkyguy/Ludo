//
//  LD_RootViewController.m
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_RootViewController.h"
#import "LD_PieceView.h"

//#define kCheatcode_autoplay
//#define kCheatcode_dice

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
 Game game;
#if defined (kCheatcode_dice)
 int cheat_value;
#endif
}
-(void) updateBackground:(const Game *)gp;
-(void) testGameState:(kGameState) state;
@end

@implementation LD_RootViewController

-(void) dealloc {
 DeleteGame(&game);
 [_diceView release];
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];
 //LuaInit();

 game.gui = self;
 GenGame(&game);
 [self updateBackground:&game];
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
 
#if defined (kCheatcode_dice)
 cheat_value = 6;
#endif
}

#if defined (kCheatcode_autoplay)
-(void) autoplay:(NSTimer *) timer {
 if (GameState(&game) != kGameState_None) {
  [timer invalidate];
 } else {
  [self next];
 }
}
#endif


- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

- (IBAction)pause:(UIButton *)sender {
 [self dismissViewControllerAnimated:YES completion:^{
  // save game
 }];
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

/** Step forward the game.
 Roll the dice and update the game state + UI
 */
//-(void) next {
// 
// game.dice_val = RollDice();
//#if defined (kCheatcode_dice)
// game.dice_val = cheat_value;
//#endif
// [self.diceView setText:[NSString stringWithFormat:@"%d",game.dice_val]];
// 
// DispatchEvent(0.5f, ^{
//  StepGame(&game);
//  DispatchEvent(1.0f, ^{
//   [self updateBackground];
//   [self testGameState];
//  });
// });
// 
//}

-(void) updateDice:(const Game *)gp {
 [self.diceView setText:[NSString stringWithFormat:@"%d",gp->dice_val]];
}


-(void) updatePieces:(const Game *)gp state:(kGameState) state {
 [self updateBackground:gp];
 [self testGameState:state];
}

-(void) updateBackground:(const Game *)gp {
 char flags[] = {'r','b','y','g'};
 float color[4];
 int cpi = CurrentPlayerIndex(gp);
 FlagToColor(color, flags[cpi]);
 [self.view setBackgroundColor:[UIColor colorWithRed:color[0] green:color[1] blue:color[2] alpha:0.5]];
 //self.diceView.text = @"-";
}

-(void) testGameState:(kGameState) state {
 if (state != kGameState_None) {
  NSString *msg = @"";
  switch (state) {
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
}

#pragma mark - Read touch
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 UITouch *touch = [touches anyObject];
 CGPoint touch_pt = [touch locationInView:nil];
 
 /* Test for dice */
 if (CGRectContainsPoint(self.diceView.frame, touch_pt)) {
  HandleDiceTouchEvent(&game);
  return;
 }

 /* Test for pieces */
 Set2i ppi;
 for (ppi.one = 0; ppi.one < 4; ++ppi.one) {
  for (ppi.two = 0; ppi.two < 4; ++ppi.two) {
   LD_PieceView *piece_vw = game.player[ppi.one].piece[ppi.two].view;
   if (CGRectContainsPoint(piece_vw.frame, touch_pt)) {
    HandlePieceTouchEvent(&game, &ppi);
    return;
   }
  }
 }
}
@end


/* EOF */
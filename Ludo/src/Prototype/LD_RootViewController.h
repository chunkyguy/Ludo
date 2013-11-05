//
//  LD_RootViewController.h
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../LD_Game.h"

@interface LD_CellView : UIView
@end

@interface LD_RootViewController : UIViewController
@property (nonatomic, assign) IBOutlet LD_CellView *redView;
@property (nonatomic, assign) IBOutlet LD_CellView *blueView;
@property (nonatomic, assign) IBOutlet LD_CellView *greenView;
@property (nonatomic, assign) IBOutlet LD_CellView *yellowView;
@property (retain, nonatomic) IBOutlet UILabel *diceView;

- (IBAction)pause:(UIButton *)sender;
- (IBAction)newGame:(UISegmentedControl *)sender;
- (IBAction)cheatDice:(UISegmentedControl *)sender;

/* Update the GUI */
-(void) updateDice:(const Game *)gp;
-(void) updatePieces:(const Game *)gp state:(kGameState) state;
@end

//
//  LD_RootViewController.h
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LD_PauseView : UIView

@end

@interface LD_CellView : UIView
@end

@interface LD_RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) IBOutlet LD_PauseView *pauseView;

@property (nonatomic, assign) IBOutlet LD_CellView *redView;
@property (nonatomic, assign) IBOutlet LD_CellView *blueView;
@property (nonatomic, assign) IBOutlet LD_CellView *greenView;
@property (nonatomic, assign) IBOutlet LD_CellView *yellowView;

- (IBAction)pause:(UIButton *)sender;
- (IBAction)newGame:(UISegmentedControl *)sender;

@end

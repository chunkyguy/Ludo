//
//  LD_SelectorViewController.h
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LD_SelectorViewController : UIViewController
@property (retain, nonatomic) IBOutlet UISegmentedControl *redSelector;
@property (retain, nonatomic) IBOutlet UISegmentedControl *blueSelector;
@property (retain, nonatomic) IBOutlet UISegmentedControl *yellowSelector;
@property (retain, nonatomic) IBOutlet UISegmentedControl *greenSelector;

@end

//
//  LD_RootViewController.h
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LD_CellView : UIView
@end

@interface LD_RootViewController : UIViewController
@property (weak, nonatomic) IBOutlet LD_CellView *redView;
@property (weak, nonatomic) IBOutlet LD_CellView *blueView;
@property (weak, nonatomic) IBOutlet LD_CellView *greenView;
@property (weak, nonatomic) IBOutlet LD_CellView *yellowView;

@end

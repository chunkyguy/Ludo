//
//  LD_RootViewController.m
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_RootViewController.h"
/************************************************************************
MARK: LD_CellView
 ***********************************************************************/
@interface LD_CellView ()
@end

@implementation LD_CellView
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
@interface LD_RootViewController ()
@end

@implementation LD_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 }
 return self;
}

- (void)viewDidLoad {
 [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

@end

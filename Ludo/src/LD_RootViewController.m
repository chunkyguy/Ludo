//
//  LD_RootViewController.m
//  Ludo
//
//  Created by Sid on 27/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_RootViewController.h"
typedef struct {

} Piece;

typedef struct {
 Piece piece[4];
 float color[4];
} Player;

/************************************************************************
 MARK: LD_CellView
 ***********************************************************************/
@interface LD_PieceView : UIView
@end

@implementation LD_PieceView

-(void) drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextFillEllipseInRect(context, self.bounds);
}

@end
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
@interface LD_RootViewController () {
 BOOL isPaused;
 NSMutableArray *games;
}
-(NSString *) saveFilePath;
-(BOOL) saveData;
@end

@implementation LD_RootViewController

-(NSString *) saveFilePath {
 return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"game.plist"];
}

-(BOOL) saveData {
 return [games writeToFile:[self saveFilePath] atomically:YES];
}

-(void) dealloc {
 [games release];
 [super dealloc];
}

- (void)viewDidLoad {
 [super viewDidLoad];
 isPaused = NO;
 if ([[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePath]]) {
  games = [[NSMutableArray alloc] initWithContentsOfFile:[self saveFilePath]];
 } else {
  games = [[NSMutableArray alloc] init];
 }
}

-(void) viewDidAppear:(BOOL)animated {
 [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

- (IBAction)pause:(UIButton *)sender {
 if (isPaused) {
  isPaused = NO;
  [self.pauseView setHidden:YES];
 } else {
  isPaused = YES;
  [self.pauseView setHidden:NO];
 }
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
@end

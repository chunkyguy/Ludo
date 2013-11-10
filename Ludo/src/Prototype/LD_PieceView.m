//
//  LD_PieceView.m
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_PieceView.h"
#import "../LD_Game.h"
#import "../LD_Utilities.h"

@interface LD_PieceView () {
 ID playerID;
 ID pieceID;
}
@end

@implementation LD_PieceView

-(id) initWithFrame:(CGRect)frame playerID:(const ID) in_playerID pieceID:(const ID) in_pieceID {
 self = [super initWithFrame:frame];
 if (self) {

  playerID = in_playerID;
  pieceID = in_pieceID;

  char cname[3];
  cname[0] = IndexToFlag(playerID);
  cname[1] = 'A'+pieceID;
  cname[2] = '\0';

  NSString *name = [[NSString alloc] initWithCString:cname encoding:NSASCIIStringEncoding];
  [self setText:name];
  [self setTextAlignment:NSTextAlignmentCenter];
  [name release];
 }
 return self;
}

-(void) dealloc {
 [super dealloc];
}

-(void) drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGFloat color[4];
 CGContextSetFillColor(context, FlagToColor(color, IndexToFlag(playerID)));
 CGFloat strok_clr[4] = {1.0f};
 CGContextSetStrokeColor(context, strok_clr);
 CGContextFillEllipseInRect(context, self.bounds);
 
 [super drawRect:rect];
}
@end

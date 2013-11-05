//
//  LD_PieceView.m
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_PieceView.h"
#import "../LD_Game.h"

@interface LD_PieceView () {
 Set2i ppi_;
}
@end

@implementation LD_PieceView

-(id) initWithFrame:(CGRect)frame playerPieceIndex:(const Set2i *)ppi {
 self = [super initWithFrame:frame];
 if (self) {

  memcpy(&ppi_, ppi, sizeof(ppi_));

  char cname[3];
  cname[0] = IndexToFlag(ppi->one);
  cname[1] = 'A'+ppi->two;
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
 CGContextSetFillColor(context, FlagToColor(color, IndexToFlag(ppi_.one)));
 CGFloat strok_clr[4] = {1.0f};
 CGContextSetStrokeColor(context, strok_clr);
 CGContextFillEllipseInRect(context, self.bounds);
 
 [super drawRect:rect];
}
@end

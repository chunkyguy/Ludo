//
//  LD_PieceView.h
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../LD_Game.h"


@interface LD_PieceView : UILabel
-(id) initWithFrame:(CGRect)frame playerPieceIndex:(const Set2i *)ppi;
@end


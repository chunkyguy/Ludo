//
//  LD_PieceView.h
//  Ludo
//
//  Created by Sid on 05/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../LD_Types.h"


@interface LD_PieceView : UILabel
-(id) initWithFrame:(CGRect)frame playerID:(const ID) playerID pieceID:(const ID)pieceID;
@end


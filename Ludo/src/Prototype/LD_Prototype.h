//
//  LD_Prototype.h
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#ifndef Ludo_LD_Prototype_h
#define Ludo_LD_Prototype_h
#import <Foundation/Foundation.h>
#import "../LD_Game.h"

#define kSegue_displaySelectionController @"displaySelectionController"
#define kSegue_displayGameController @"displayGameController"


@interface LD_Prototype : NSObject
+(BOOL) Create;
+(BOOL) Destroy;

+(BOOL) savedGame:(Game*)game;
+(NSInteger) gamesCount;

+(Game *)gameAtIndex:(NSUInteger) index;
@end

#endif

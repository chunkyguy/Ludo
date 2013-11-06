//
//  LD_Prototype.m
//  Ludo
//
//  Created by Sid on 06/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_Prototype.h"
#define kFileName_savedGames @"game.plist"

@interface LD_Prototype_Internal : NSObject {
 NSMutableArray *games;
}
-(NSArray *) savedGames;
-(BOOL) saveGames;

-(NSString *) save_file_path;
@end

@implementation LD_Prototype_Internal
-(id) init {
 self = [super init];
 if (self) {
  /* Load saved games */
  if ([[NSFileManager defaultManager] fileExistsAtPath:[self save_file_path]]) {
   games = [[NSMutableArray alloc] initWithContentsOfFile:[self save_file_path]];
  } else {
   games = [[NSMutableArray alloc] init];
  }
 }
 
 return self;
}

-(void) dealloc {
 [games release];
 [super dealloc];
}

#pragma mark - Save game
-(NSArray *) savedGames {
 return games;
}

-(BOOL) saveGames {
 return [games writeToFile:[self save_file_path] atomically:YES];
}

-(NSString *) save_file_path {
 return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kFileName_savedGames];
}
@end



static LD_Prototype_Internal *g_Internal = nil;
@implementation LD_Prototype
+(BOOL) Create {
 g_Internal = [[LD_Prototype_Internal alloc] init];
 
 return YES;
}

+(BOOL) Destroy {
 [g_Internal release];

 return YES;
}

+(BOOL) savedGame:(Game*)game {
 
 return [g_Internal saveGames];
}

+(NSInteger) gamesCount {
 return [[g_Internal savedGames] count];
}

+(Game *)gameAtIndex:(NSUInteger) index {
 return NULL;
}

@end

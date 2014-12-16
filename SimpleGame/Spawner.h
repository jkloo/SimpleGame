//
//  Spawner.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/15/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_Spawner_h
#define SimpleGame_Spawner_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BallController.h"

@interface Spawner : NSObject

@property CGPoint location;
@property CGVector vector;
@property float force;

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndForce:(float)force;
-(BallController*)spawnObject;
-(void)fireObject:(BallController*)ball;

@end

#endif

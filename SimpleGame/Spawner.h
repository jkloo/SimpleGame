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
#import "BlackHole.h"

@interface Spawner : SKSpriteNode

@property CGVector vector;
@property float velocity;

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndVelocity:(float)velocity;
-(BlackHole*)spawnObject;
-(void)fireObject:(BlackHole*)ball;
-(void)spawnAndFireObject;

@end

#endif

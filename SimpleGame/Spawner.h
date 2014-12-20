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
#import "CelestialBody.h"

enum PORTAL_TYPE
{
    GRAY,
    RED,
    BLUE
};

@interface Spawner : CelestialBody

@property CGVector vector;
@property float velocity;
@property enum PORTAL_TYPE portal_type;

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndVelocity:(float)velocity;
-(void)spawnAndFireObject;
-(void)spawnAndFireObjectWithTimer:(NSTimer*)timer;
-(void)changePortalType:(enum PORTAL_TYPE)new_type;

@end

#endif

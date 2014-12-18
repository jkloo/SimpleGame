//
//  BlackHole.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_BlackHole_h
#define SimpleGame_BlackHole_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "CelestialBody.h"

@interface BlackHole : CelestialBody

@property double radius;
@property double radius_min;
@property double radius_max;

-(id)init;
-(id)initWithMass:(double)mass AndRadius:(double)radius;
-(void)updateSize:(double)radius;
-(void)setupPhysicsBodyWithMass:(double)mass AndRadius:(double)radius;
-(double)constrainRadius:(double)radius;

@end

#endif

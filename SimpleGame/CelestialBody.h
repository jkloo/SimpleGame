//
//  CelestialBody.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/17/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_CelestialBody_h
#define SimpleGame_CelestialBody_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface CelestialBody : SKSpriteNode

@property bool stationary;
@property float mass_min;
@property float mass_max;

-(id)init;
-(id)initWithImageNamed:(NSString *)name;
-(id)initWithImageNamed:(NSString*)name AndMass:(float)mass;
-(void)updateSize:(CGSize*)size;
-(void)setupPhysicsBodyWithMass:(float)mass;
-(double)constrainMass:(double)mass;
-(double)constrainValue:(double)value Between:(double)min And:(double)max;

@end

#endif

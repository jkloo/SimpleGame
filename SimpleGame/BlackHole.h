//
//  BallController.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_BlackHole_h
#define SimpleGame_BlackHole_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BlackHole : SKSpriteNode

@property float radius;
@property double min_mass;
@property double max_mass;
@property double min_radius;
@property double max_radius;
@property bool stationary;

-(id)init;
-(id)initWithMass:(float)mass AndRadius:(float)radius;
-(void)updateSize:(float)radius;
-(void)setupPhysicsBodyWithMass:(float)mass AndRadius:(float)radius;

@end

#endif

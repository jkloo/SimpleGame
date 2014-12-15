//
//  BallController.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_BallController_h
#define SimpleGame_BallController_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BallController : SKSpriteNode

@property double min_mass;
@property double max_mass;
@property double min_radius;
@property double max_radius;
@property bool stationary;

-(id)init;
-(id)initWithMass:(float)mass AndRadius:(float)radius;
-(id)initWithRandomMassBetween:(int)mass_min And:(int)mass_max AndRadius:(int)rad_min And:(int)rad_max;

@end

#endif

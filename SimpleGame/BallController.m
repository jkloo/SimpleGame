//
//  BallController.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "BallController.h"

@interface BallController()

@property float radius;

-(double)constrainMass:(double)mass;
-(double)constrainRadius:(double)radius;
-(double)constrainValue:(double)value Between:(double)min And:(double)max;

@end

@implementation BallController : SKSpriteNode

-(id)init
{
    self = [[BallController alloc] initWithMass:10 AndRadius:10];
    return self;
}

-(id)initWithMass:(float)mass AndRadius:(float)radius
{
    self = [super initWithImageNamed:@"BluePlanet"];
    if(self)
    {
        self.stationary = NO;
        self.min_mass = 5;
        self.max_mass = 100;
        self.min_radius = 3;
        self.max_radius = 50;
        
        self.radius = [self constrainRadius:radius];
        self.size = CGSizeMake(self.radius * 2, self.radius * 2);
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.radius];
        self.physicsBody.dynamic = YES;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.mass = [self constrainMass:mass];
    }
    return self;
}

-(id)initWithRandomMassBetween:(int)mass_min And:(int)mass_max AndRadius:(int)rad_min And:(int)rad_max
{
    double mass = arc4random() % (mass_max - mass_min) + mass_min;
    double radius = arc4random() % (rad_max - rad_min) + rad_min;
    self = [[BallController alloc] initWithMass:mass AndRadius:radius];
    return self;
}

-(double)constrainMass:(double)mass
{
    return [self constrainValue:mass Between:self.min_mass And:self.max_mass];
}

-(double)constrainRadius:(double)radius
{
    return [self constrainValue:radius Between:self.min_radius And:self.max_radius];
}

-(double)constrainValue:(double)value Between:(double)min And:(double)max
{
    if(value < min)
    {
        value = min;
    }
    else if (value > max)
    {
        value = max;
    }
    return value;
}
@end
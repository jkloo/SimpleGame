//
//  BallController.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "BlackHole.h"

@interface BlackHole()

-(double)constrainMass:(double)mass;
-(double)constrainRadius:(double)radius;
-(double)constrainValue:(double)value Between:(double)min And:(double)max;

@end

@implementation BlackHole : SKSpriteNode

-(id)init
{
    self = [[BlackHole alloc] initWithMass:10 AndRadius:10];
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
        self.min_radius = 5;
        self.max_radius = 50;
        
        [self updateSize:[self constrainRadius:radius]];
        [self setupPhysicsBodyWithMass:mass AndRadius:radius];
        

    }
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

-(void)updateSize:(float)radius
{
    self.radius = [self constrainRadius:radius];
    self.size = CGSizeMake(self.radius * 2, self.radius * 2);
}

-(void)setupPhysicsBodyWithMass:(float)mass AndRadius:(float)radius
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:[self constrainRadius:radius]];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = [self constrainMass:mass];
}
@end
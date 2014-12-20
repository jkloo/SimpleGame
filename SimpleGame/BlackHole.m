//
//  BlackHole.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "BlackHole.h"
#import "Collisions.h"

@interface BlackHole()

@end

@implementation BlackHole : CelestialBody

-(id)init
{
    self = [[BlackHole alloc] initWithMass:10 AndRadius:10];
    return self;
}

-(id)initWithMass:(double)mass AndRadius:(double)radius
{
    self = [super initWithImageNamed:@"BluePlanet"];
    if(self)
    {
        self.stationary = YES;
        self.mass_min = 5;
        self.mass_max = 1000;
        self.radius_min = 5;
        self.radius_max = 50;
        
        [self updateSize:[self constrainRadius:radius]];
        [self setupPhysicsBodyWithMass:mass AndRadius:radius];
    }
    return self;
}

-(double)constrainRadius:(double)radius
{
    return [self constrainValue:radius Between:self.radius_min And:self.radius_max];
}

-(void)updateSize:(double)radius
{
    self.radius = [self constrainRadius:radius];
    self.size = CGSizeMake(self.radius * 2, self.radius * 2);
}

-(void)setupPhysicsBodyWithMass:(double)mass AndRadius:(double)radius
{
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:[self constrainRadius:radius]];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.mass = [self constrainMass:mass];
    self.physicsBody.categoryBitMask = BLACKHOLE_CATEGORY;
    self.physicsBody.collisionBitMask = BLACKHOLE_COLLIDES;
    self.physicsBody.contactTestBitMask = BLACKHOLE_CONTACTS;
}
@end
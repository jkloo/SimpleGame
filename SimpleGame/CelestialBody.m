//
//  CelestialBody.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/17/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "CelestialBody.h"

@interface CelestialBody()

@end

@implementation CelestialBody : SKSpriteNode

-(id)init
{
    self = [[CelestialBody alloc] initWithImageNamed:@"BluePlanet"];
    return self;
}

-(id)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    if(self)
    {
        self.stationary = NO;
        self.mass_min = 0;
        self.mass_max = 10;
        [self setupPhysicsBodyWithMass:10];
    }
    return self;
}

-(id)initWithImageNamed:(NSString*)name AndMass:(float)mass
{
    self = [self initWithImageNamed:name];
    if(self)
    {
        [self setupPhysicsBodyWithMass:mass];
    }
    return self;
}

-(double)constrainMass:(double)mass
{
    return [self constrainValue:mass Between:self.mass_min And:self.mass_max];
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

-(void)updateSize:(CGSize*)size
{
    self.size = *(size);
}

-(void)setupPhysicsBodyWithMass:(float)mass
{
    self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture size:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = YES;
    self.physicsBody.mass = [self constrainMass:mass];
    self.physicsBody.friction = 0.0;
    self.physicsBody.restitution = 0.9;
}

-(void)destroy
{
    [self removeFromParent];
}
@end
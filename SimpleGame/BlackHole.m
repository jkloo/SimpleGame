//
//  BlackHole.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "BlackHole.h"
#import "Collisions.h"

@interface BlackHole ()

@property double shrink_interval;

@end

@implementation BlackHole : CelestialBody

- (id)init
{
    self = [[BlackHole alloc] initWithMass:10 AndRadius:10];
    return self;
}

- (id)initWithMass:(double)mass AndRadius:(double)radius
{
    self = [super initWithImageNamed:@"WormHole"];
    if (self) {
        self.stationary = YES;
        self.mass_min = BLACK_HOLE_MASS_MIN;
        self.mass_max = BLACK_HOLE_MASS_MAX;
        self.radius_min = BLACK_HOLE_RADIUS_MIN;
        self.radius_max = BLACK_HOLE_RADIUS_MAX;

        [self updateSize:[self constrainRadius:radius]];
        [self setupPhysicsBodyWithMass:mass AndRadius:radius];
    }
    return self;
}

- (double)constrainRadius:(double)radius
{
    return [self constrainValue:radius Between:self.radius_min And:self.radius_max];
}

- (void)updateSize:(double)radius
{
    self.radius = [self constrainRadius:radius];
    self.size = CGSizeMake(self.radius * 2, self.radius * 2);
}

- (void)setupPhysicsBodyWithMass:(double)mass AndRadius:(double)radius
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

- (void)finalize
{
    self.shrink_interval = 0.03;
    int n = (self.radius - self.radius_min) / BLACK_HOLE_RADIUS_GROWTH_RATE * 1 / self.shrink_interval;
    SKAction *delay = [SKAction waitForDuration:1];
    SKAction *interval = [SKAction waitForDuration:self.shrink_interval];
    SKAction *shrink = [SKAction performSelector:@selector(shrink) onTarget:self];
    SKAction *shrink_to_zero =
        [SKAction repeatAction:[SKAction sequence:[NSArray arrayWithObjects:interval, shrink, nil]] count:n];
    SKAction *vanish = [SKAction performSelector:@selector(vanish) onTarget:self];
    SKAction *all = [SKAction sequence:[NSArray arrayWithObjects:delay, shrink_to_zero, vanish, nil]];
    [self.parent runAction:all];
}

- (void)shrink
{
    double new_radius = self.radius - BLACK_HOLE_RADIUS_GROWTH_RATE * self.shrink_interval;
    double new_mass = self.physicsBody.mass - BLACK_HOLE_MASS_GROWTH_RATE * self.shrink_interval;
    [self updateSize:new_radius];
    self.physicsBody.mass = new_mass;
}

- (void)vanish
{
    self.physicsBody.mass = 0;
    [self removeFromParent];
}

@end
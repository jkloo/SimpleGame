//
//  Ship.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"
#import "Collisions.h"

@interface Ship()

@end

@implementation Ship : CelestialBody

-(id)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    if(self)
    {
        self.stationary = NO;
        self.size = CGSizeMake(self.texture.size.width, self.texture.size.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.texture.size.width/3, self.texture.size.height/4)center:CGPointMake(self.texture.size.width*1/3, 0)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.allowsRotation = YES;
        self.physicsBody.categoryBitMask = SHIP_CATEGORY;
        self.physicsBody.collisionBitMask = SHIP_COLLIDES;
        self.physicsBody.contactTestBitMask = SHIP_CONTACTS;
        self.mass_min = 100;
        self.mass_max = 150;
    }
    return self;
}

@end
//
//  Spawner.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/15/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spawner.h"
#import "GameScene.h"
#import "BlackHole.h"
#import "Ship.h"
#import "RedShip.h"
#import "BlueShip.h"
#import "Collisions.h"

@interface Spawner()

@end

@implementation Spawner : CelestialBody

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndVelocity:(float)velocity
{
    self = [super initWithImageNamed:@"GrayPortal"];
    if(self)
    {
        self.portal_type = GRAY;
        self.position = location;
        self.vector = vector;
        self.velocity = velocity;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.texture.size.width/2, self.texture.size.height)];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = PORTAL_CATEGORY;
        self.physicsBody.contactTestBitMask = PORTAL_CONTACTS;
        self.physicsBody.collisionBitMask = PORTAL_COLLIDES;
    }
    return self;
}

-(void)changePortalType:(enum PORTAL_TYPE)new_type
{
    if(new_type == self.portal_type)
        
    {
        return;
    }
    self.portal_type = new_type;
    switch (self.portal_type) {
        case BLUE:
            self.texture = [SKTexture textureWithImageNamed:@"BluePortal"];
            break;
        case RED:
            self.texture = [SKTexture textureWithImageNamed:@"RedPortal"];
            break;
        case GRAY:
        default:
            self.texture = [SKTexture textureWithImageNamed:@"GrayPortal"];
            break;
    }
}

-(void)spawnAndFireObject
{
    Ship* ship;
    if(self.portal_type == BLUE)
    {
        ship = [[BlueShip alloc] init];
    }
    else if (self.portal_type == RED)
    {
        ship = [[RedShip alloc] init];
    }
    else
    {
        return;
    }
    ship.position = self.position;
    [[self parent] addChild:ship];
    if(ship.physicsBody)
    {
        CGVector velocity_vector = CGVectorMake(self.velocity * self.vector.dx, self.velocity * self.vector.dy);
        ship.physicsBody.velocity = velocity_vector;
    }
    [(GameScene*)self.parent addShip:ship];
}

-(void)spawnAndFireObjectWithTimer:(NSTimer*)timer
{
    [self spawnAndFireObject];
}

@end
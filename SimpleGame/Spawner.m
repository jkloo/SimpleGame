//
//  Spawner.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/15/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spawner.h"
#import "BlackHole.h"

@interface Spawner()

@end

@implementation Spawner : SKSpriteNode

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndVelocity:(float)velocity
{
    self = [super initWithImageNamed:@"BluePortal"];
    if(self)
    {
        self.position = location;
        self.vector = vector;
        self.velocity = velocity;
    }
    return self;
}

-(BlackHole*)spawnObject
{
    BlackHole* hole = [[BlackHole alloc] initWithMass:25 AndRadius:25];
    hole.position = self.position;
    [[self parent] addChild:hole];
    return hole;
}

-(void)fireObject:(BlackHole*)hole
{
    if(hole.physicsBody)
    {
        CGVector velocity_vector = CGVectorMake(self.velocity * self.vector.dx, self.velocity * self.vector.dy);
        hole.physicsBody.velocity = velocity_vector;
    }
}

-(void)spawnAndFireObject
{
    [self fireObject:[self spawnObject]];
}

@end
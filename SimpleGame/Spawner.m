//
//  Spawner.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/15/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spawner.h"
#import "BallController.h"

@interface Spawner()

@end

@implementation Spawner

-(id)initWithLocation:(CGPoint)location Vector:(CGVector)vector AndForce:(float)force
{
    self = [super init];
    if(self)
    {
        self.location = location;
        self.vector = vector;
        self.force = force;
    }
    return self;
}

-(BallController*)spawnObject
{
    BallController* ball = [[BallController alloc] initWithMass:25 AndRadius:25];
    ball.position = self.location;
    return ball;
}

-(void)fireObject:(BallController*)ball
{
    if(ball.physicsBody)
    {
        CGVector force_vector = CGVectorMake(self.force * self.vector.dx, self.force * self.vector.dy);
        [ball.physicsBody applyForce:force_vector];
    }
}

@end
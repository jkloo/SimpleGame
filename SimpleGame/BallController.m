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

@end

@implementation BallController : SKSpriteNode

-(id)init
{
    self = [super initWithImageNamed:@"BluePlanet"];
    if(self)
    {
        self.radius = 10;
        self.size = CGSizeMake(self.radius * 2, self.radius * 2);

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.radius];
        self.physicsBody.dynamic = YES;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.mass = 10;
    }
    return self;
}

@end
//
//  GameScene.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "GameScene.h"
#import "BallController.h"

@interface GameScene ()

@property double GRAV_CONST;

@end



@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.GRAV_CONST = 6.674 * pow(10, -11) * pow(10, 14);
//    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        BallController* ball = [[BallController alloc] init];
        ball.position = location;
        [self addChild:ball];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    for (BallController* ball_1 in self.children)
    {
        for(BallController* ball_2 in self.children)
        {
            if (ball_1 == ball_2) {
                continue;
            }
            double delta_x = ball_2.position.x - ball_1.position.x;
            double delta_y = ball_2.position.y - ball_1.position.y;
            double hypo = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
            double force_mag = [self CalculateGravityForceBetweenBall1:ball_1 AndBall2:ball_2];
            CGVector force = CGVectorMake(force_mag * delta_x/hypo, force_mag * delta_y/hypo);
            
            [ball_1.physicsBody applyForce:force];
        }
    }
}

-(double)CalculateGravityForceBetweenBall1:(BallController*)ball_1 AndBall2:(BallController*)ball_2
{
    double rad_square = pow(ball_1.position.x - ball_2.position.x, 2) + pow(ball_1.position.y - ball_2.position.y, 2);
    return self.GRAV_CONST * ball_1.physicsBody.mass * ball_2.physicsBody.mass / rad_square;
}

@end

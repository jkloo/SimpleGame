//
//  GameScene.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "GameScene.h"
#import "BallController.h"
#import "Spawner.h"

@interface GameScene ()

@property double GRAV_CONST;
@property NSTimeInterval touch_begin;
@property BallController* placing_ball;
@property Spawner* spawner1;

@end



@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.GRAV_CONST = 6.674 * pow(10, -11) * pow(10, 13);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.spawner1 = [[Spawner alloc] initWithLocation:CGPointMake(10, 500) Vector:CGVectorMake(1, 0) AndForce:10000];
    BallController* ball = [self.spawner1 spawnObject];
    [self addChild:ball];
    [self.spawner1 fireObject:ball];
    
    for(int i=0; i<10; i++)
    {
        int x = arc4random() % (int)([[UIScreen mainScreen] bounds].size.width + 1);
        int y = arc4random() % (int)([[UIScreen mainScreen] bounds].size.height + 1);
        double n = arc4random() % (20 - 5) + 5;
        BallController* ball = [[BallController alloc] initWithMass:n AndRadius:n];
        ball.position = CGPointMake(x, y);
        [self addChild:ball];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        self.touch_begin = touch.timestamp;
        self.placing_ball = [[BallController alloc] initWithMass:0 AndRadius:0];
        self.placing_ball.position = [touch locationInNode:self];
        [self addChild:self.placing_ball];
        break;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for(UITouch* touch in touches)
    {
        NSTimeInterval touch_end = touch.timestamp;
        double radius = [self durationToRadius:(touch_end - self.touch_begin)];
        double mass = [self durationToMass:(touch_end - self.touch_begin)];

        CGPoint location = [touch locationInNode:self];
        
        [self.placing_ball updateSize:radius];
        [self.placing_ball setupPhysicsBodyWithMass:mass AndRadius:radius];
        self.placing_ball.position = location;
        break;
    }
    self.placing_ball = nil;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        self.placing_ball.position = [touch locationInNode:self];
    }

}

-(void)update:(CFTimeInterval)currentTime
{
    if(self.placing_ball)
    {
        NSTimeInterval now = [[NSProcessInfo processInfo] systemUptime];
        NSLog(@"Now: %f", now);
        NSLog(@"Begin: %f", self.touch_begin);
        NSLog(@"Duration: %f", (now - self.touch_begin));
        double radius = [self durationToRadius:(now - self.touch_begin)];
        double mass = [self durationToMass:(now - self.touch_begin)];
        [self.placing_ball updateSize:radius];
        [self.placing_ball setupPhysicsBodyWithMass:mass AndRadius:radius];
    }
    
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
            if(!ball_1.stationary)
            {
                [ball_1.physicsBody applyForce:force];
            }
        }
    }
}

-(double)CalculateGravityForceBetweenBall1:(BallController*)ball_1 AndBall2:(BallController*)ball_2
{
    double rad_square = pow(ball_1.position.x - ball_2.position.x, 2) + pow(ball_1.position.y - ball_2.position.y, 2);
    return self.GRAV_CONST * ball_1.physicsBody.mass * ball_2.physicsBody.mass / rad_square;
}

-(double)durationToRadius:(NSTimeInterval)duration
{
    return (double)(30 * duration);
}

-(double)durationToMass:(NSTimeInterval)duration
{
    return (double)(30 * duration);
}

@end

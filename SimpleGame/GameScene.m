//
//  GameScene.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import "GameScene.h"
#import "BlackHole.h"
#import "Spawner.h"

@interface GameScene ()

@property double GRAV_CONST;
@property NSTimeInterval touch_begin;
@property BlackHole* placing_ball;
@property NSArray* spawners;

@property float screen_height;
@property float screen_width;

@end


@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.GRAV_CONST = 6.674 * pow(10, -11) * pow(10, 13);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.screen_height = [[UIScreen mainScreen] bounds].size.height;
    self.screen_width = [[UIScreen mainScreen] bounds].size.width;
    
    Spawner* sp0 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 1/6) Vector:CGVectorMake(1, 0)AndVelocity:200];
    Spawner* sp1 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 2/6) Vector:CGVectorMake(1, 0)AndVelocity:200];
    Spawner* sp2 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 3/6) Vector:CGVectorMake(1, 0)AndVelocity:200];
    Spawner* sp3 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 4/6) Vector:CGVectorMake(1, 0)AndVelocity:200];
    Spawner* sp4 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 5/6) Vector:CGVectorMake(1, 0)AndVelocity:200];
    
    self.spawners = [NSArray arrayWithObjects:sp0, sp1, sp2, sp3, sp4, nil];
    for (Spawner* spawner in self.spawners)
    {
        [self addChild:spawner];
    }
    for (Spawner* spawner in self.spawners)
    {
        [spawner spawnAndFireObject];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        self.touch_begin = touch.timestamp;
        self.placing_ball = [[BlackHole alloc] initWithMass:0 AndRadius:0];
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
    
    for (BlackHole* hole_1 in self.children)
    {
        for(BlackHole* hole_2 in self.children)
        {
            if (hole_1 == hole_2)
            {
                continue;
            }
            if(![hole_1 isKindOfClass:[BlackHole class]] || ![hole_2 isKindOfClass:[BlackHole class]])
            {
                continue;
            }
            double delta_x = hole_2.position.x - hole_1.position.x;
            double delta_y = hole_2.position.y - hole_1.position.y;
            double hypo = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
            double force_mag = [self CalculateGravityForceBetweenBall1:hole_1 AndBall2:hole_2];
            CGVector force = CGVectorMake(force_mag * delta_x/hypo, force_mag * delta_y/hypo);
            if(!hole_1.stationary)
            {
                [hole_1.physicsBody applyForce:force];
            }
        }
    }
}

-(double)CalculateGravityForceBetweenBall1:(BlackHole*)hole_1 AndBall2:(BlackHole*)hole_2
{
    double rad_square = pow(hole_1.position.x - hole_2.position.x, 2) + pow(hole_1.position.y - hole_2.position.y, 2);
    return self.GRAV_CONST * hole_1.physicsBody.mass * hole_2.physicsBody.mass / rad_square;
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

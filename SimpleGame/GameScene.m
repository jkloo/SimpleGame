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
#import "Collisions.h"

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
    
    Spawner* sp0 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 1/6) Vector:CGVectorMake(1, 0)AndVelocity:300];
    Spawner* sp1 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 2/6) Vector:CGVectorMake(1, 0)AndVelocity:300];
    Spawner* sp2 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 3/6) Vector:CGVectorMake(1, 0)AndVelocity:300];
    Spawner* sp3 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 4/6) Vector:CGVectorMake(1, 0)AndVelocity:300];
    Spawner* sp4 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 5/6) Vector:CGVectorMake(1, 0)AndVelocity:300];
    
    self.spawners = [NSArray arrayWithObjects:sp0, sp1, sp2, sp3, sp4, nil];
    [self selectActivePortals];
    SKAction* waitForSelect = [SKAction waitForDuration:2];
    SKAction* waitForFire = [SKAction waitForDuration:5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:[SKAction performSelector:@selector(selectActivePortals) onTarget:self], waitForSelect, waitForFire, nil]]] withKey:@"ChangeActiveSpawner"];
    
    int i = 0;
    for (Spawner* spawner in self.spawners)
    {
        [self addChild:spawner];
        SKAction* fire = [SKAction performSelector:@selector(spawnAndFireObject) onTarget:spawner];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:waitForSelect, fire, waitForFire, nil]]] withKey:[NSString stringWithFormat:@"sp%d", i]];
        i++;
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
        double radius = [self durationToRadius:(now - self.touch_begin)];
        double mass = [self durationToMass:(now - self.touch_begin)];
        [self.placing_ball updateSize:radius];
        [self.placing_ball setupPhysicsBodyWithMass:mass AndRadius:radius];
    }
    
//    for (CelestialBody* body1 in self.children)
//    {
//        for(CelestialBody* body2 in self.children)
//        {
//            if (body1 == body2)
//            {
//                continue;
//            }
//            if(![body1 isKindOfClass:[CelestialBody class]] || ![body2 isKindOfClass:[CelestialBody class]])
//            {
//                continue;
//            }
//            double delta_x = body2.position.x - body1.position.x;
//            double delta_y = body2.position.y - body1.position.y;
//            double hypo = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
//            double force_mag = [self calculateGravityForceBetweenBody1:body1 AndBody2:body2];
//            CGVector force = CGVectorMake(force_mag * delta_x/hypo, force_mag * delta_y/hypo);
//            if(!body1.stationary)
//            {
//                [body1.physicsBody applyForce:force];
//                NSLog(@"Applied a force of: %f", force_mag);
//            }
//        }
//    }
}

-(double)calculateGravityForceBetweenBody1:(CelestialBody*)hole_1 AndBody2:(CelestialBody*)hole_2
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

-(void)selectActivePortals
{
    NSUInteger red = arc4random() % 5;
    NSUInteger blue = red;
    while (blue == red)
    {
        blue = arc4random() % 5;
    }
    for (NSUInteger i = 0; i < self.spawners.count; i++)
    {
        if (i == red)
        {
            [self.spawners[i] changePortalType:RED];
        }
        else if (i == blue)
        {
            [self.spawners[i] changePortalType:BLUE];
        }
        else
        {
            [self.spawners[i] changePortalType:GRAY];
        }

    }
}

@end

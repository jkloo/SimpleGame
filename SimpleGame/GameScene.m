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
#import "ExitPortal.h"
#import "Collisions.h"
#import "Ship.h"
#import "RedShip.h"
#import "BlueShip.h"

@interface GameScene ()

@property SKLabelNode* score_label;
@property SKLabelNode* lives_label;

@property double GRAV_CONST;
@property NSTimeInterval touch_begin;
@property BlackHole* placing_ball;
@property NSArray* spawners;
@property ExitPortal* exit_portal;

@property float screen_height;
@property float screen_width;

@property NSUInteger lives_remaining;
@property NSUInteger score;

@property NSMutableArray* ships;
@property NSMutableArray* holes;

@end


@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.GRAV_CONST = 6.674 * pow(10, -11) * pow(10, 14);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.screen_height = [[UIScreen mainScreen] bounds].size.height;
    self.screen_width = [[UIScreen mainScreen] bounds].size.width;
    self.score = 0;
    self.lives_remaining = 5;
    self.ships = [NSMutableArray array];
    self.holes = [NSMutableArray array];

    /* Setup Score label */
    self.score_label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %d", self.score]];
    self.score_label.fontSize = 24;
    self.score_label.fontName = @"MenloRg-Regular";
    self.score_label.fontColor = [SKColor whiteColor];
    self.score_label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.score_label.position = CGPointMake(self.size.width/2, self.screen_height - 50);
    [self addChild:self.score_label];

    /* Setup Lives counter */
    self.lives_label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Lives: %d", self.lives_remaining]];
    self.lives_label.fontSize = 24;
    self.lives_label.fontName = @"MenloRg-Regular";
    self.lives_label.fontColor = [SKColor whiteColor];
    self.lives_label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.lives_label.position = CGPointMake(self.size.width/2, self.screen_height - 100);
    [self addChild:self.lives_label];

    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.screen_width, self.screen_height)center:CGPointMake(self.screen_width/2, self.screen_height/2)];
    self.physicsBody.categoryBitMask = WORLD_CATEGORY;
    self.physicsBody.contactTestBitMask = WORLD_CONTACTS;
    self.physicsBody.collisionBitMask = WORLD_COLLIDES;
    
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

    self.exit_portal = [[ExitPortal alloc] initWithLocation:CGPointMake(self.screen_width - 50, self.screen_height / 2)];
    [self addChild:self.exit_portal];

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
        [self.holes addObject:self.placing_ball];
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

//    NSLog(@"n ships: %d", [self.ships count]);
//    NSLog(@"n holes: %d", [self.holes count]);
    for (Ship* ship in self.ships)
    {
        for(BlackHole* hole in self.holes)
        {
            if(![ship isKindOfClass:[Ship class]] || ![hole isKindOfClass:[BlackHole class]])
            {
                continue;
            }
            double delta_x = hole.position.x - ship.position.x;
            double delta_y = hole.position.y - ship.position.y;
            double hypo = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
//            NSLog(@"hypo: %f", hypo);
            double force_mag = [self calculateGravityForceBetweenBody1:ship AndBody2:hole];
//            NSLog(@"mag: %f", force_mag);
            CGVector force = CGVectorMake(force_mag * delta_x/hypo, force_mag * delta_y/hypo);
            if(!ship.stationary)
            {
                [ship.physicsBody applyForce:force];
                NSLog(@"Applied a force of: %f", force_mag);
            }
        }
    }
}

-(double)calculateGravityForceBetweenBody1:(CelestialBody*)hole_1 AndBody2:(CelestialBody*)hole_2
{
    double rad_square = pow(hole_1.position.x - hole_2.position.x, 2) + pow(hole_1.position.y - hole_2.position.y, 2);
    NSLog(@"rad square: %f", rad_square);
    NSLog(@"body1 mass: %f", hole_1.physicsBody.mass);
    NSLog(@"body2 mass: %f", hole_2.physicsBody.mass);
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

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* body1;
    SKPhysicsBody* body2;

    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        body1 = contact.bodyA;
        body2 = contact.bodyB;
    }
    else
    {
        body1 = contact.bodyB;
        body2 = contact.bodyA;
    }

    if((body1.categoryBitMask & WORLD_CATEGORY) != 0
       && (body2.categoryBitMask & SHIP_CATEGORY) != 0)
    {
        NSLog(@"Ship hit world");
    }
    else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0
             && (body2.categoryBitMask & SHIP_CATEGORY) != 0)
    {
        NSLog(@"Ship hit ship");
        [self decrementLivesRemaining];
    }
    else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0
             && (body2.categoryBitMask & EXIT_CATEGORY) != 0)
    {
        NSLog(@"Ship hit exit");
        if([body1.node isMemberOfClass:[RedShip class]])
        {
            [self decrementLivesRemaining];
            [body1.node removeFromParent];
        }
        else if ([body1.node isMemberOfClass:[BlueShip class]])
        {
            [self scorePoint];
            [body1.node removeFromParent];
        }
    }
    else
    {
        NSLog(@"Unknown contact");
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* body1;
    SKPhysicsBody* body2;

    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        body1 = contact.bodyA;
        body2 = contact.bodyB;
    }
    else
    {
        body1 = contact.bodyB;
        body2 = contact.bodyA;
    }

    if((body1.categoryBitMask & WORLD_CATEGORY) != 0
       && (body2.categoryBitMask & SHIP_CATEGORY) != 0)
    {
        NSLog(@"Ship exited world");
        if([body2.node isMemberOfClass:[BlueShip class]])
        {
            [self decrementLivesRemaining];
        }
        [body2.node removeFromParent];
    }
    else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0
             && (body2.categoryBitMask & SHIP_CATEGORY) != 0)
    {
        NSLog(@"Ship exited ship");
    }
    else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0
             && (body2.categoryBitMask & EXIT_CATEGORY) != 0)
    {
        NSLog(@"Ship exited exit");
    }
    else
    {
        NSLog(@"Unknown exit");
    }
}

-(void)decrementLivesRemaining
{
    self.lives_remaining--;
    NSLog(@"Remaining Lives: %d", self.lives_remaining);
    self.lives_label.text = [NSString stringWithFormat:@"Lives: %d", self.lives_remaining];
}

-(void)scorePoint
{
    self.score++;
    NSLog(@"Score: %d", self.score);
    self.score_label.text = [NSString stringWithFormat:@"Score: %d", self.score];
}

-(void)endGame
{
    NSLog(@"Game Over");
}

-(void)addShip:(Ship *)ship
{
    NSLog(@"addShip");
    [self.ships addObject:ship];
}

@end

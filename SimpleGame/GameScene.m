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
#import "GameOverScene.h"

@interface GameScene ()

@property SKLabelNode *score_label;

@property double GRAV_CONST;
@property NSTimeInterval touch_begin;
//@property BlackHole* placing_ball;
@property NSArray *spawners;
@property ExitPortal *exit_portal;

@property float screen_height;
@property float screen_width;

@property NSUInteger lives_remaining;
@property NSUInteger score;

@property NSMutableArray *ships;
@property NSMutableArray *holes;
@property NSMutableArray *placing_holes;
@property NSMutableArray *placing_timers;
@property NSMutableArray *active_touches;

@property NSArray *life_markers;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.GRAV_CONST = 6.674 * pow(10, -11) * pow(10, 15);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.screen_height = [[UIScreen mainScreen] bounds].size.height;
    self.screen_width = [[UIScreen mainScreen] bounds].size.width;
    self.score = 0;
    self.lives_remaining = 5;
    self.ships = [NSMutableArray array];
    self.holes = [NSMutableArray array];

    /* Setup Score label */
    SKSpriteNode *score_background = [SKSpriteNode spriteNodeWithImageNamed:@"LargeRectButton"];
    score_background.position = CGPointMake(self.size.width / 2, self.screen_height - 30);
    score_background.size = CGSizeMake(225, 100);
    [self addChild:score_background];

    self.score_label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %d", (unsigned)self.score]];
    self.score_label.fontSize = 36;
    self.score_label.fontName = @"Menlo";
    self.score_label.fontColor = [SKColor blackColor];
    self.score_label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.score_label.position = CGPointMake(self.size.width / 2, self.screen_height - 50);
    [self addChild:self.score_label];

    /* Setup life markers */
    int marker_size = 75;
    SKSpriteNode *life0 = [[SKSpriteNode alloc] initWithImageNamed:@"GrayShip"];
    life0.size = CGSizeMake(marker_size, life0.texture.size.height * marker_size / life0.texture.size.width);
    life0.position = CGPointMake(self.screen_width - 350, self.screen_height - 30);
    [self addChild:life0];

    SKSpriteNode *life1 = [[SKSpriteNode alloc] initWithImageNamed:@"GrayShip"];
    life1.size = CGSizeMake(marker_size, life1.texture.size.height * marker_size / life1.texture.size.width);
    life1.position = CGPointMake(self.screen_width - 275, self.screen_height - 30);
    [self addChild:life1];

    SKSpriteNode *life2 = [[SKSpriteNode alloc] initWithImageNamed:@"GrayShip"];
    life2.size = CGSizeMake(marker_size, life2.texture.size.height * marker_size / life2.texture.size.width);
    life2.position = CGPointMake(self.screen_width - 200, self.screen_height - 30);
    [self addChild:life2];

    SKSpriteNode *life3 = [[SKSpriteNode alloc] initWithImageNamed:@"GrayShip"];
    life3.size = CGSizeMake(marker_size, life3.texture.size.height * marker_size / life3.texture.size.width);
    life3.position = CGPointMake(self.screen_width - 125, self.screen_height - 30);
    [self addChild:life3];

    SKSpriteNode *life4 = [[SKSpriteNode alloc] initWithImageNamed:@"GrayShip"];
    life4.size = CGSizeMake(marker_size, life4.texture.size.height * marker_size / life4.texture.size.width);
    life4.position = CGPointMake(self.screen_width - 50, self.screen_height - 30);
    [self addChild:life4];

    self.life_markers = [NSArray arrayWithObjects:life4, life3, life2, life1, life0, nil];

    /* Set up physics world */
    self.physicsWorld.contactDelegate = self;
    self.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.screen_width, self.screen_height)
                                        center:CGPointMake(self.screen_width / 2, self.screen_height / 2)];
    self.physicsBody.dynamic = NO;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = WORLD_CATEGORY;
    self.physicsBody.contactTestBitMask = WORLD_CONTACTS;
    self.physicsBody.collisionBitMask = WORLD_COLLIDES;

    /* Set up Spawners */
    Spawner *sp0 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 1 / 6)
                                              Vector:CGVectorMake(1, 0)
                                         AndVelocity:SPAWNER_INITIAL_VELOCITY];
    Spawner *sp1 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 2 / 6)
                                              Vector:CGVectorMake(1, 0)
                                         AndVelocity:SPAWNER_INITIAL_VELOCITY];
    Spawner *sp2 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 3 / 6)
                                              Vector:CGVectorMake(1, 0)
                                         AndVelocity:SPAWNER_INITIAL_VELOCITY];
    Spawner *sp3 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 4 / 6)
                                              Vector:CGVectorMake(1, 0)
                                         AndVelocity:SPAWNER_INITIAL_VELOCITY];
    Spawner *sp4 = [[Spawner alloc] initWithLocation:CGPointMake(50, self.screen_height * 5 / 6)
                                              Vector:CGVectorMake(1, 0)
                                         AndVelocity:SPAWNER_INITIAL_VELOCITY];

    self.spawners = [NSArray arrayWithObjects:sp0, sp1, sp2, sp3, sp4, nil];
    [self selectActivePortals];
    SKAction *waitForSelect = [SKAction waitForDuration:2];
    SKAction *waitForFire = [SKAction waitForDuration:5];
    [self
        runAction:[SKAction repeatActionForever:
                                [SKAction sequence:[NSArray arrayWithObjects:
                                                                [SKAction performSelector:@selector(selectActivePortals)
                                                                                 onTarget:self],
                                                                waitForSelect, waitForFire, nil]]]
          withKey:@"ChangeActiveSpawner"];

    int i = 0;
    for (Spawner *spawner in self.spawners) {
        [self addChild:spawner];
        SKAction *fire = [SKAction performSelector:@selector(spawnAndFireObject) onTarget:spawner];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:waitForSelect, fire,
                                                                                                   waitForFire, nil]]]
                withKey:[NSString stringWithFormat:@"sp%d", i]];
        i++;
    }

    self.exit_portal =
        [[ExitPortal alloc] initWithLocation:CGPointMake(self.screen_width - 50, self.screen_height / 2)];
    [self addChild:self.exit_portal];
    SKAction *doPhysics = [SKAction performSelector:@selector(calcPhysics) onTarget:self];
    SKAction *waitPhysics = [SKAction waitForDuration:0.1];
    [self
        runAction:[SKAction
                      repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:doPhysics, waitPhysics, nil]]]];

    for (int j = 0; j < 6; j++) {
        Spawner *rockSpawner0 = [[Spawner alloc] initWithLocation:CGPointMake(self.screen_width * (j + 1) / 6, -100)
                                                           Vector:CGVectorMake(0, 1)
                                                      AndVelocity:SPAWNER_INITIAL_VELOCITY];
        [rockSpawner0 changePortalType:ROCK];

        [self addChild:rockSpawner0];
        SKAction *fire = [SKAction performSelector:@selector(spawnAndFireObject) onTarget:rockSpawner0];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:waitForSelect, fire,
                                                                                                   waitForFire, nil]]]];
    }

    for (int j = 0; j < 6; j++) {
        Spawner *rockSpawner0 =
            [[Spawner alloc] initWithLocation:CGPointMake(self.screen_width * (j + 1) / 6, self.screen_height + 100)
                                       Vector:CGVectorMake(0, -1)
                                  AndVelocity:SPAWNER_INITIAL_VELOCITY];
        [rockSpawner0 changePortalType:ROCK];

        [self addChild:rockSpawner0];
        SKAction *fire = [SKAction performSelector:@selector(spawnAndFireObject) onTarget:rockSpawner0];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:[NSArray arrayWithObjects:waitForSelect, fire,
                                                                                                   waitForFire, nil]]]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */

    for (UITouch *touch in touches) {
        if (self.placing_holes == nil) {
            self.placing_holes = [[NSMutableArray alloc] init];
        }

        NSTimeInterval start = touch.timestamp;
        BlackHole *hole = [[BlackHole alloc] initWithMass:0 AndRadius:0];
        hole.touch = touch;
        hole.beginning = start;

        hole.position = [touch locationInNode:self];
        [self addChild:hole];
        [self.holes addObject:hole];
        [self.placing_holes addObject:hole];
        [self.placing_timers addObject:[NSNumber numberWithDouble:start]];
        [self.active_touches addObject:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (BlackHole *hole in self.placing_holes) {
        if ([touches containsObject:hole.touch]) {
            hole.position = [hole.touch locationInNode:self];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *finished_holes = [[NSMutableArray alloc] init];
    for (BlackHole *hole in self.placing_holes) {
        if ([touches containsObject:hole.touch]) {
            NSTimeInterval end = hole.touch.timestamp;

            double radius = [self durationToRadius:(end - hole.beginning)];
            double mass = [self durationToMass:(end - hole.beginning)];

            CGPoint location = [hole.touch locationInNode:self];

            [hole updateSize:radius];
            [hole setupPhysicsBodyWithMass:mass AndRadius:radius];
            hole.position = location;
            [hole finalize];
            [finished_holes addObject:hole];
        }
    }
    for (BlackHole *hole in finished_holes) {
        hole.touch = nil;
        [self.placing_holes removeObject:hole];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    for (BlackHole *hole in self.placing_holes) {
        NSTimeInterval now = [[NSProcessInfo processInfo] systemUptime];
        double radius = [self durationToRadius:(now - hole.beginning)];
        double mass = [self durationToMass:(now - hole.beginning)];
        [hole updateSize:radius];
        [hole setupPhysicsBodyWithMass:mass AndRadius:radius];
    }

    for (Ship *ship in self.ships) {
        double angle = atan2(ship.physicsBody.velocity.dy, ship.physicsBody.velocity.dx);
        [ship runAction:[SKAction rotateToAngle:angle duration:0.1]];
        float vel_mag = sqrtf(powf(ship.physicsBody.velocity.dx, 2) + powf(ship.physicsBody.velocity.dy, 2));
        float dx = ship.physicsBody.velocity.dx / vel_mag;
        float dy = ship.physicsBody.velocity.dy / vel_mag;
        [ship.physicsBody applyForce:CGVectorMake(SHIP_CONSTANT_FORCE * dx, SHIP_CONSTANT_FORCE * dy)];
    }
}

- (void)calcPhysics
{
    for (Ship *ship in self.ships) {
        for (BlackHole *hole in self.holes) {
            if (![ship isKindOfClass:[Ship class]] || ![hole isKindOfClass:[BlackHole class]]) {
                continue;
            }
            double delta_x = hole.position.x - ship.position.x;
            double delta_y = hole.position.y - ship.position.y;
            double hypo = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
            double force_mag = [self calculateGravityForceBetweenBody1:ship AndBody2:hole];
            if (force_mag > MAX_FORCE) {
                force_mag = MAX_FORCE;
            }
            CGVector force = CGVectorMake(force_mag * delta_x / hypo, force_mag * delta_y / hypo);
            if (!ship.stationary) {
                [ship.physicsBody applyForce:force];
            }
        }
    }
}

- (double)calculateGravityForceBetweenBody1:(CelestialBody *)hole_1 AndBody2:(CelestialBody *)hole_2
{
    double rad_square = pow(hole_1.position.x - hole_2.position.x, 2) + pow(hole_1.position.y - hole_2.position.y, 2);
    return self.GRAV_CONST * hole_1.physicsBody.mass * hole_2.physicsBody.mass / rad_square;
}

- (double)durationToRadius:(NSTimeInterval)duration
{
    return (double)(BLACK_HOLE_RADIUS_MIN + BLACK_HOLE_RADIUS_GROWTH_RATE * duration);
}

- (double)durationToMass:(NSTimeInterval)duration
{
    return (double)(BLACK_HOLE_MASS_MIN + BLACK_HOLE_MASS_GROWTH_RATE * duration);
}

- (void)selectActivePortals
{
    NSUInteger red = arc4random() % 5;
    NSUInteger blue = red;
    while (blue == red) {
        blue = arc4random() % 5;
    }
    for (NSUInteger i = 0; i < self.spawners.count; i++) {
        if (i == red) {
            [self.spawners[i] changePortalType:RED];
        } else if (i == blue) {
            [self.spawners[i] changePortalType:BLUE];
        } else {
            [self.spawners[i] changePortalType:GRAY];
        }
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *body1;
    SKPhysicsBody *body2;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        body1 = contact.bodyA;
        body2 = contact.bodyB;
    } else {
        body1 = contact.bodyB;
        body2 = contact.bodyA;
    }

    if ((body1.categoryBitMask & WORLD_CATEGORY) != 0 && (body2.categoryBitMask & SHIP_CATEGORY) != 0) {
        NSLog(@"Ship hit world");
    } else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0 && (body2.categoryBitMask & SHIP_CATEGORY) != 0) {
        NSLog(@"Ship hit ship");
        [(Ship *)body1.node destroy];
        [(Ship *)body2.node destroy];
        [self decrementLivesRemaining];
    } else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0 && (body2.categoryBitMask & EXIT_CATEGORY) != 0) {
        NSLog(@"Ship hit exit");
        if ([body1.node isMemberOfClass:[RedShip class]]) {
            [self decrementLivesRemaining];
            [body1.node removeFromParent];
        } else if ([body1.node isMemberOfClass:[BlueShip class]]) {
            [self scorePoint];
            [body1.node removeFromParent];
        }
    } else {
        NSLog(@"Unknown contact");
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *body1;
    SKPhysicsBody *body2;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        body1 = contact.bodyA;
        body2 = contact.bodyB;
    } else {
        body1 = contact.bodyB;
        body2 = contact.bodyA;
    }

    if ((body1.categoryBitMask & WORLD_CATEGORY) != 0 && (body2.categoryBitMask & SHIP_CATEGORY) != 0) {
        NSLog(@"Ship exited world");
        if ([body2.node isMemberOfClass:[BlueShip class]]) {
            [self decrementLivesRemaining];
        }
        [body2.node removeFromParent];
    } else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0 && (body2.categoryBitMask & SHIP_CATEGORY) != 0) {
        NSLog(@"Ship exited ship");
    } else if ((body1.categoryBitMask & SHIP_CATEGORY) != 0 && (body2.categoryBitMask & EXIT_CATEGORY) != 0) {
        NSLog(@"Ship exited exit");
    } else {
        NSLog(@"Unknown exit");
    }
}

- (void)decrementLivesRemaining
{
    self.lives_remaining--;
    SKSpriteNode *x = [[SKSpriteNode alloc] initWithImageNamed:@"RedX"];
    x.size = CGSizeMake(75, 75);
    SKSpriteNode *indicator = [self.life_markers objectAtIndex:self.lives_remaining];
    x.position = indicator.position;
    [self addChild:x];
    NSLog(@"Remaining Lives: %d", (unsigned)self.lives_remaining);
    if (self.lives_remaining == 0) {
        [self endGame];
    }
}

- (void)scorePoint
{
    self.score++;
    NSLog(@"Score: %lu", (unsigned long)self.score);
    self.score_label.text = [NSString stringWithFormat:@"Score: %d", (unsigned)self.score];
}

- (void)endGame
{
    NSLog(@"Game Over");
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene *gameOverScene = [[GameOverScene alloc] initWithSize:self.size AndScore:self.score];
    [self.view presentScene:gameOverScene transition:reveal];
}

- (void)addShip:(Ship *)ship
{
    NSLog(@"addShip");
    [self.ships addObject:ship];
}

@end

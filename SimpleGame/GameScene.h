//
//  GameScene.h
//  SimpleGame
//

//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ship.h"

static double MAX_FORCE = 100000;

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(void)addShip:(Ship*)ship;

@end

//
//  ShipController.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_ShipController_h
#define SimpleGame_ShipController_h

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ShipController : NSObject

@property SKSpriteNode* ship;
@property float speed;
@property float move_x;
@property float move_y;
@property float direction;

-(id)init;
-(SKAction*)move;
-(SKAction*)rotateToMoveDirection;
-(void)setMoveDirectionFromPoint:(CGPoint*)target;

@end

#endif

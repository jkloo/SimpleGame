//
//  ShipController.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <tgmath.h>
#import "ShipController.h"

@interface ShipController ()

@property float bound_x;
@property float bound_y;
@property float bound_buffer;

@end

@implementation ShipController

-(id)init
{
    self = [super init];
    if(self)
    {
        self.ship = [SKSpriteNode spriteNodeWithImageNamed:@"BlueShip"];
        self.ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ship.frame.size];
        self.ship.physicsBody.affectedByGravity = NO;
        self.ship.physicsBody.dynamic = YES;
        self.ship.xScale = 0.5;
        self.ship.yScale = 0.5;
        self.speed = 3.0F;
        self.move_x = 0.0F;
        self.move_y = 0.0F;
        self.direction = M_PI/2;
        self.bound_x = [[UIScreen mainScreen] bounds].size.width;
        self.bound_y = [[UIScreen mainScreen] bounds].size.height;
        self.bound_buffer = 10;
    }
    
    return self;
}

-(void)setMoveDirectionFromPoint:(CGPoint*)target
{
    float delta_x = target->x - self.ship.position.x;
    float delta_y = target->y - self.ship.position.y;
    float hypotenuse = sqrtf( powf(delta_x, 2) + powf(delta_y, 2));
    self.move_x = delta_x / hypotenuse;
    self.move_y = delta_y / hypotenuse;
}

-(SKAction*)rotateToMoveDirection
{
    float target_angle = atan2f(self.move_y, self.move_x);
    float delta_angle = target_angle - self.direction;
    
    // Coorect for wrapping
    if(delta_angle > M_PI)
    {
        delta_angle = -2 * M_PI + delta_angle;
    }
    else if (delta_angle < -M_PI)
    {
        delta_angle = 2 * M_PI + delta_angle;
    }
    self.direction = target_angle;
    SKAction* action = [SKAction rotateByAngle:delta_angle duration:0.1];
    return action;
}

-(SKAction*)move
{
    float delta_x = self.speed * self.move_x;
    float delta_y = self.speed * self.move_y;
    float new_x = delta_x + self.ship.position.x;
    float new_y = delta_y + self.ship.position.y;
    
    if(new_x < self.bound_buffer)
    {
        new_x = self.bound_buffer;
        delta_x = new_x - self.ship.position.x;
    }
    else if (new_x > self.bound_x - self.bound_buffer)
    {
        new_x = self.bound_x - self.bound_buffer;
        delta_x = new_x - self.ship.position.x;
    }

    if(new_y < self.bound_buffer)
    {
        new_y = self.bound_buffer;
        delta_y = new_y - self.ship.position.y;

    }
    else if (new_y > self.bound_y - self.bound_buffer)
    {
        new_y = self.bound_y - self.bound_buffer;
        delta_y = new_y - self.ship.position.y;
    }
    
    SKAction *action = [SKAction moveByX:delta_x y:delta_y duration:0.03];
    return action;
}

@end
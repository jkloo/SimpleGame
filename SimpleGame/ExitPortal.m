//
//  ExitPortal.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/20/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExitPortal.h"
#import "Collisions.h"

@interface ExitPortal()

@end

@implementation ExitPortal

-(id)initWithLocation:(CGPoint)location
{
    self = [super initWithImageNamed:@"BluePortal"];
    if(self)
    {
        self.position = location;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = EXIT_CATEGORY;
        self.physicsBody.contactTestBitMask = PORTAL_CONTACTS;
        self.physicsBody.collisionBitMask = PORTAL_COLLIDES;
    }
    return self;
}

@end
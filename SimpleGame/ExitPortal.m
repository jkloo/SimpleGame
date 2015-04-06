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

@interface ExitPortal ()

@end

@implementation ExitPortal

- (id)initWithLocation:(CGPoint)location
{
    self = [super initWithImageNamed:@"BluePortal"];
    if (self) {
        self.position = location;
        self.physicsBody = [SKPhysicsBody
            bodyWithRectangleOfSize:CGSizeMake(self.texture.size.width / 3, self.texture.size.height * 0.75)
                             center:CGPointMake(self.texture.size.width / 3, 0)];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = EXIT_CATEGORY;
        self.physicsBody.contactTestBitMask = EXIT_CONTACTS;
        self.physicsBody.collisionBitMask = EXIT_COLLIDES;
    }
    return self;
}

@end
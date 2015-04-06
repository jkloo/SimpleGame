//
//  Rock.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 3/2/15.
//  Copyright (c) 2015 Jeff Kloosterman. All rights reserved.
//

#import "Rock.h"
#import "Collisions.h"

@implementation Rock

- (id)init
{
    self = [super initWithImageNamed:@"Rock"];
    self.diameter = arc4random() % 20 + 10;
    self.size = CGSizeMake(self.diameter, self.diameter);
    self.physicsBody.categoryBitMask = ROCK_CATEGORY;
    self.physicsBody.collisionBitMask = ROCK_COLLIDES;
    self.physicsBody.contactTestBitMask = ROCK_CONTACTS;
    return self;
}

- (void)destroy { [self removeFromParent]; }

@end

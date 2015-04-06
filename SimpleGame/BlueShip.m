//
//  BlueShip.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/18/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueShip.h"

@interface BlueShip ()

@end

@implementation BlueShip

- (id)init
{
    self = [super initWithImageNamed:@"BlueShip"];
    NSArray *textures = [NSArray
        arrayWithObjects:[SKTexture textureWithImageNamed:@"BlueShip0"], [SKTexture textureWithImageNamed:@"BlueShip1"],
                         [SKTexture textureWithImageNamed:@"BlueShip2"], [SKTexture textureWithImageNamed:@"BlueShip3"],
                         [SKTexture textureWithImageNamed:@"BlueShip2"], [SKTexture textureWithImageNamed:@"BlueShip3"],
                         [SKTexture textureWithImageNamed:@"BlueShip2"], [SKTexture textureWithImageNamed:@"BlueShip1"],
                         nil];
    [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.08]]];
    self.size = CGSizeMake(380 / 2, 114 / 2);
    return self;
}

- (void)destroy
{
    NSArray *textures = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"BlueCrash0"],
                                                  [SKTexture textureWithImageNamed:@"BlueCrash1"],
                                                  [SKTexture textureWithImageNamed:@"BlueCrash2"],
                                                  [SKTexture textureWithImageNamed:@"BlueCrash3"],
                                                  [SKTexture textureWithImageNamed:@"BlueCrash3"], nil];
    SKAction *animate = [SKAction animateWithTextures:textures timePerFrame:0.08];
    SKAction *remove = [SKAction performSelector:@selector(removeFromParent) onTarget:self];
    [self runAction:[SKAction sequence:[NSArray arrayWithObjects:animate, remove, nil]]];
}

@end
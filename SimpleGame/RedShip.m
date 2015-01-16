//
//  RedShip.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/18/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedShip.h"

@interface RedShip()

@end

@implementation RedShip

-(id)init
{
    self = [super initWithImageNamed:@"RedShip"];
    NSArray* textures = [NSArray arrayWithObjects:
                         [SKTexture textureWithImageNamed:@"RedShip0"],
                         [SKTexture textureWithImageNamed:@"RedShip1"],
                         [SKTexture textureWithImageNamed:@"RedShip2"],
                         [SKTexture textureWithImageNamed:@"RedShip3"],
                         [SKTexture textureWithImageNamed:@"RedShip2"],
                         [SKTexture textureWithImageNamed:@"RedShip3"],
                         [SKTexture textureWithImageNamed:@"RedShip2"],
                         [SKTexture textureWithImageNamed:@"RedShip1"],
                         nil];
    [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.08]]];
    self.size = CGSizeMake(380/2, 114/2);
    return self;
}

-(void)destroy
{
    NSArray* textures = [NSArray arrayWithObjects:
                         [SKTexture textureWithImageNamed:@"RedCrash0"],
                         [SKTexture textureWithImageNamed:@"RedCrash1"],
                         [SKTexture textureWithImageNamed:@"RedCrash2"],
                         [SKTexture textureWithImageNamed:@"RedCrash3"],
                         [SKTexture textureWithImageNamed:@"RedCrash3"],
                         nil];
    SKAction * animate = [SKAction animateWithTextures:textures timePerFrame:0.08];
    SKAction * remove = [SKAction performSelector:@selector(removeFromParent) onTarget:self];
    [self runAction: [SKAction sequence:[NSArray arrayWithObjects:animate, remove, nil]]];

}

@end
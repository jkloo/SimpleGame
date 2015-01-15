//
//  GameOverScene.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 1/14/15.
//  Copyright (c) 2015 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];

        NSString * message;
        message = @"Game Over";

        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"MenloRg-Regular"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor whiteColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];

        NSString * score = @"Score: ";
        SKLabelNode * scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MenloRg-Regular"];
        scoreLabel.text = score;
        scoreLabel.fontSize = 30;
        scoreLabel.fontColor = [SKColor whiteColor];
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/3);
        [self addChild:scoreLabel];

        SKSpriteNode * replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"LargeRectButton"];
        replayButton.position = CGPointMake(self.size.width/2, 50);
        replayButton.size = CGSizeMake(150, 50);
        replayButton.name = @"replayButton";
        [self addChild:replayButton];

        NSString * replayButtonString = @"Replay";
        SKLabelNode *replayText = [SKLabelNode labelNodeWithFontNamed:@"MenloRg-Regular"];
        replayText.text = replayButtonString;
        replayText.fontColor = [SKColor whiteColor];
        replayText.position = CGPointMake(self.size.width/2, 50);
        replayText.name = @"replay";
        [self addChild:replayText];

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if ([node.name isEqualToString:@"replay"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];

        GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];

    }
}
@end

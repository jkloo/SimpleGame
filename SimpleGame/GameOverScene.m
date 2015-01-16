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
-(id)initWithSize:(CGSize)size AndScore:(unsigned int)score {
    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];

        NSString * message;
        message = @"Game Over";

        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        label.text = message;
        label.fontSize = 96;
        label.fontColor = [SKColor colorWithRed:57/255 green:120/255 blue:255/255 alpha:1];
        label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        label.position = CGPointMake(self.size.width/2, self.size.height * 0.8);
        [self addChild:label];

        SKSpriteNode * scoreBackground = [SKSpriteNode spriteNodeWithImageNamed:@"LargeRectButton"];
        scoreBackground.position = CGPointMake(self.size.width/2, self.size.height * 0.5);
        scoreBackground.size = CGSizeMake(300, 150);
        scoreBackground.name = @"scoreBackground";
        [self addChild:scoreBackground];

        NSString * scoreText = [NSString stringWithFormat:@"Score: %d", score];
        SKLabelNode * scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        scoreLabel.text = scoreText;
        scoreLabel.fontSize = 48;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height * 0.5);
        [self addChild:scoreLabel];

        SKSpriteNode * replayButton = [SKSpriteNode spriteNodeWithImageNamed:@"LargeRectButton"];
        replayButton.position = CGPointMake(self.size.width/2, self.size.height * 0.3);
        replayButton.size = CGSizeMake(300, 150);
        replayButton.name = @"replayButton";
        [self addChild:replayButton];

        NSString * replayButtonString = @"Replay";
        SKLabelNode *replayText = [SKLabelNode labelNodeWithFontNamed:@"Menlo"];
        replayText.text = replayButtonString;
        replayText.fontSize = 48;
        replayText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        replayText.fontColor = [SKColor blackColor];
        replayText.position = CGPointMake(self.size.width/2, self.size.height * 0.3);
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

-(void)updateScore:(unsigned int)score
{

}
@end

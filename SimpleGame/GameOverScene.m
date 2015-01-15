//
//  GameOverScene.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 1/14/15.
//  Copyright (c) 2015 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameOverScene.h"
//#import "MyScene.h"

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

        NSString * replayButtonString = @"Replay";
        SKLabelNode *replayButton = [SKLabelNode labelNodeWithFontNamed:@"MenloRg-Regular"];
        replayButton.text = replayButtonString;
        replayButton.fontColor = [SKColor whiteColor];
        replayButton.position = CGPointMake(self.size.width/2, 50);
        replayButton.name = @"replay";
        [self addChild:replayButton];

    }
    return self;
}
@end

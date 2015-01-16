//
//  Ship.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_Ship_h
#define SimpleGame_Ship_h

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CelestialBody.h"

static double SHIP_CONSTANT_FORCE = 25;

@interface Ship : CelestialBody

-(id)initWithImageNamed:(NSString *)name;

@end

#endif

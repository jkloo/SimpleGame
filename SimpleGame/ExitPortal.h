//
//  ExitPortal.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/20/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_ExitPortal_h
#define SimpleGame_ExitPortal_h

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "CelestialBody.h"

@interface ExitPortal : CelestialBody

- (id)initWithLocation:(CGPoint)location;

@end

#endif

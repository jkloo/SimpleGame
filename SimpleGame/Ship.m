//
//  Ship.m
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/13/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@interface Ship()

@end

@implementation Ship : CelestialBody

-(id)init
{
    self = [super initWithImageNamed:@"BlueShip"];
    if(self)
    {
        self.stationary = NO;
    }
    return self;
}

@end
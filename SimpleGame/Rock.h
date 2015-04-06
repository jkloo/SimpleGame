//
//  Rock.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 3/2/15.
//  Copyright (c) 2015 Jeff Kloosterman. All rights reserved.
//

#import "Ship.h"

@interface Rock : Ship

@property CGFloat diameter;

- (id)init;
- (void)destroy;

@end

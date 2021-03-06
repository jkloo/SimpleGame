//
//  Collisions.h
//  SimpleGame
//
//  Created by Jeff Kloosterman on 12/20/14.
//  Copyright (c) 2014 Jeff Kloosterman. All rights reserved.
//

#ifndef SimpleGame_Collisions_h
#define SimpleGame_Collisions_h

#import <Foundation/Foundation.h>

static const uint32_t WORLD_CATEGORY = 0x00000001;
static const uint32_t SHIP_CATEGORY = 0x00000010;
static const uint32_t BLACKHOLE_CATEGORY = 0x00000100;
static const uint32_t PORTAL_CATEGORY = 0x00001000;
static const uint32_t EXIT_CATEGORY = 0x00010000;
static const uint32_t ROCK_CATEGORY = 0x00100000;

static const uint32_t WORLD_CONTACTS = SHIP_CATEGORY;
static const uint32_t SHIP_CONTACTS = SHIP_CATEGORY | EXIT_CATEGORY | WORLD_CATEGORY | ROCK_CATEGORY;
static const uint32_t EXIT_CONTACTS = SHIP_CATEGORY;
static const uint32_t PORTAL_CONTACTS = 0;
static const uint32_t BLACKHOLE_CONTACTS = 0;
static const uint32_t ROCK_CONTACTS = 0;

static const uint32_t WORLD_COLLIDES = 0;
static const uint32_t SHIP_COLLIDES = 0;
static const uint32_t EXIT_COLLIDES = 0;
static const uint32_t PORTAL_COLLIDES = 0;
static const uint32_t BLACKHOLE_COLLIDES = 0;
static const uint32_t ROCK_COLLIDES = 0;

#endif

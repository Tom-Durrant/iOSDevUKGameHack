//
//  WGPlayer2.m
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WGPlayer2.h"

static WGPlayer2 *shared = nil;

@implementation WGPlayer2

@synthesize deltaY=_deltaY;

+(WGPlayer2 *)shared {
    if(nil == shared) {
        shared = [[WGPlayer2 alloc] init];
    }
    return shared;
}

-(void)dealloc {
    if(self == shared) { shared = nil; }
    [super dealloc];
}

@end

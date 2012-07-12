//
//  WGPlayer1.m
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WGPlayer1.h"

static WGPlayer1 *shared = nil;

@implementation WGPlayer1

@synthesize deltaX=_deltaX;

+(WGPlayer1 *)shared {
    if(nil == shared) {
        shared = [[WGPlayer1 alloc] init];
    }
    return shared;
}

-(void)dealloc {
    if(self == shared) { shared = nil; }
    [super dealloc];
}

@end

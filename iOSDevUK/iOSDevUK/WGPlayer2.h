//
//  WGPlayer2.h
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGPlayer2 : NSObject {
    CGFloat _deltaY;
}

@property CGFloat deltaY;

+(WGPlayer2 *)shared;

@end

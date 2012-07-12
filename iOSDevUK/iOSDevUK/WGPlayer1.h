//
//  WGPlayer1.h
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WGPlayer1 : NSObject {
    CGFloat _deltaX;
}

@property CGFloat deltaX;

+(WGPlayer1 *)shared;

@end

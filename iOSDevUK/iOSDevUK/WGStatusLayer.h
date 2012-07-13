//
//  WGStatusLayer.h
//  iOSDevUK
//
//  Created by Dean Morris on 13/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WGStatusLayer : CCLayer {
    
    NSInteger health, maxHealth;
}

@property (nonatomic) NSInteger health, maxHealth;

+(id)setupWithData:(NSInteger)initial maxHealth:(NSInteger)max;
-(void)adjustHealth:(NSInteger)changedAmount;

@end
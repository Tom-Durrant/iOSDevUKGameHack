//
//  HelloWorldLayer.h
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameLayer.h"

@class GameLayer;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
    //CCLabelTTF *_label;
    CGFloat _vx, _vy;
    CGFloat _CurrentAngle;
    WGMode _mode;
    
    GameLayer *_gameLayer;
    CCSprite *_arrowLeftRight, *_arrowUpDown;
    
    uint32_t ownTickStamp, otherTickStamp;
}

@property WGMode mode;

-(id)initWithMode:(WGMode)mode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *)sceneWithMode:(WGMode)mode;

@end

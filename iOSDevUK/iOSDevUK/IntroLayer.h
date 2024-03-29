//
//  IntroLayer.h
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameLayer.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer {
    WGMode _mode;
}

@property WGMode mode;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *)sceneWithMode:(WGMode)mode;

@end

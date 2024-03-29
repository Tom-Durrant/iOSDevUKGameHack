//
//  GameLayer.h
//  DragonGame
//
//  Created by Dean Morris on 12/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapLayer.h"
#import "WGStatusLayer.h"

typedef enum {
    kGameLevelError = 0,
    kGameLevelBackground,
    kGameLevelMap,
    kGameLevelDragon,
    kGameLevelHUD,
    kGameLevelControls,
    kGameLevelMaximum
} GameLevels;

@interface GameLayer : CCLayer {
    MapLayer *mapLayer;
    CCSpriteBatchNode *batchNode;
    
    CGSize winSize;
    NSInteger nextTag;
    
    NSInteger tagMap, tagDragon;
    NSInteger tagLeft, tagRight, tagDown, tagUp;
    
    WGStatusLayer *statusLayer;
    
    CCSprite *_dragon;
    
    ccTime lastUpdate;
    
    BOOL gameOver;
    
    double lastDeath;
}

@property (readonly) CCSprite *dragon;
@property (nonatomic, assign) WGStatusLayer *statusLayer;

+(id)setupWithData;

-(void)moveCharacter:(CGPoint)direction;
-(void)moveCharacterToPosition:(CGPoint)position;
-(CGPoint)getCurrentMapPosition;

@end

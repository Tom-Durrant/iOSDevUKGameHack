//
//  MapLayer.h
//  DragonGame
//
//  Created by Dean Morris on 12/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MIN_MAP_NUMBER	0
#define MAX_MAP_NUMBER	1

typedef enum{
    kMapContentError = 0,
    kMapContentBlank,
    kMapContentWall,
    kMapContentTreasure,
    kMapContentEnemy,
    kMapContentGoal,
    kMapContentMaximum
} MapContentType;

@interface MapLayer : CCLayer {

    NSInteger mapNumber;
	CCTMXTiledMap *tiledMap;
    CGSize mapSize;
    CCLabelTTF *hitDisplay;
    CGRect startLocation, endLocation;
}
@property(nonatomic, readonly) CGRect startLocation, endLocation;


+(id)setupWithData:(NSInteger)levelNumer;

-(MapContentType)contentsAtPlayerScreenLocation:(CGPoint)screenLocation;
-(void)scrollMapInGivenDirection:(CGPoint)offset;
-(void)removeTile:(CGPoint)mapLocation tileType:(MapContentType)contentType;
-(CGPoint)convertScreenLocationToMapLocation:(CGPoint)screenLocation;
- (CGPoint)tiledMapPosition;

@end

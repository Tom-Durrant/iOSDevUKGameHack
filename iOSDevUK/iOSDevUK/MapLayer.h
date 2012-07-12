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
    kMapContentMaximum
} MapContentType;

@interface MapLayer : CCLayer {

    NSInteger mapNumber;
	CCTMXTiledMap *tiledMap;
    CGSize mapSize;
}

+(id)setupWithData:(NSInteger)levelNumer;

-(MapContentType)contentAtLocation:(CGPoint)mapLocation;
-(void)scrollMapInGivenDirection:(CGPoint)offset;
-(CGPoint)convertScreenLocationToMapLocation:(CGPoint)screenLocation;

@end

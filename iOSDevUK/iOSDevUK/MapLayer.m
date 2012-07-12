//
//  MapLayer.m
//  DragonGame
//
//  Created by Dean Morris on 12/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import "MapLayer.h"


@implementation MapLayer


/*-----------------------------------------------------------------------------------------------
 * Scroll the map the number of pixels in the given delta direction
 *-----------------------------------------------------------------------------------------------*/ 
-(void)scrollMapInGivenDirection:(CGPoint)offset{
    
    tiledMap.position = ccpSub(tiledMap.position, offset);
    
}


/*-----------------------------------------------------------------------------------------------
 * This will look up the the current map offset, look at the location given and compute what
 * map location this relates to
 *-----------------------------------------------------------------------------------------------*/ 
-(CGPoint)convertScreenLocationToMapLocation:(CGPoint)screenLocation{
    
    CGPoint adjustedOffset = ccpSub(screenLocation, tiledMap.position);
    
    CGPoint mapLocation = CGPointMake((NSInteger)(adjustedOffset.x / tiledMap.tileSize.width) + 1, (NSInteger)(mapSize.height - adjustedOffset.y / tiledMap.tileSize.height) + 1);
    
    return mapLocation;
}


/*-----------------------------------------------------------------------------------------------
 * Return the contents of the map at the given location
 *-----------------------------------------------------------------------------------------------*/ 
-(MapContentType)contentAtLocation:(CGPoint)mapLocation{
    
    unsigned int graphicId;
    
    // Go through all the layers - start with the top
    CCTMXLayer *enemyLayer = [tiledMap layerNamed:@"enemies"];
    graphicId = [enemyLayer tileGIDAt:mapLocation];
    if(graphicId > 0)
        return kMapContentEnemy;
    
    CCTMXLayer *treasureLayer = [tiledMap layerNamed:@"treasure"];
    graphicId = [treasureLayer tileGIDAt:mapLocation];
    if(graphicId > 0)
        return kMapContentTreasure;
    
    CCTMXLayer *wallLayer = [tiledMap layerNamed:@"walls"];
    graphicId = [wallLayer tileGIDAt:mapLocation];
    if(graphicId > 0)
        return kMapContentWall;

    return kMapContentBlank;
}


/*-----------------------------------------------------------------------------------------------
 * Load the current map level
 *-----------------------------------------------------------------------------------------------*/ 
-(void)loadMap:(NSInteger)levelNumer{
    NSString *mapName = [NSString stringWithFormat:@"level%ld.tmx", (long)levelNumer];
    CCLOG(@"MapLayer.loadMap: (%@)", mapName);
    
    tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    [self addChild:tiledMap];
    mapSize = tiledMap.mapSize;
    
    for(CCTMXLayer* child in [tiledMap children] ) {
        [[child texture] setAntiAliasTexParameters];
    }
}


/*-----------------------------------------------------------------------------------------------
 * Class constructor
 *-----------------------------------------------------------------------------------------------*/ 
-(id)initWithSetup:(NSInteger)levelNumer{
	
	if(!(self = [super init])){
		NSLog(@"MapLayer.init fail");
		return nil;
	}
    
    if(mapNumber < MIN_MAP_NUMBER || mapNumber > MAX_MAP_NUMBER){
        NSLog(@"MapLayer.init Invalid map number (%d)", levelNumer);
        return nil;
    }
    
    mapNumber = levelNumer;
    
    [self loadMap:mapNumber];
    
    return self;
}


/*-----------------------------------------------------------------------------------------------
 * Initialise with parameters
 *-----------------------------------------------------------------------------------------------*/ 
+(id)setupWithData:(NSInteger)levelNumer{
    
    return [[self alloc]initWithSetup:levelNumer];
    
}



@end

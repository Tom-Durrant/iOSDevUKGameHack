//
//  MapLayer.m
//  DragonGame
//
//  Created by Dean Morris on 12/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import "MapLayer.h"


@implementation MapLayer
@synthesize startLocation, endLocation;


/*-----------------------------------------------------------------------------------------------
 * Remove the tile at the given location
 *-----------------------------------------------------------------------------------------------*/ 
-(void)removeTile:(CGPoint)mapLocation tileType:(MapContentType)contentType{
    
    // Work out what layer we want
    CCTMXLayer *layer;
    switch (contentType) {
        case kMapContentEnemy:
            layer = [tiledMap layerNamed:@"enemies"];
            break;
        case kMapContentTreasure:
            layer = [tiledMap layerNamed:@"treasure"];
            break;
        case kMapContentWall:
            layer = [tiledMap layerNamed:@"walls"];
            break;
        default:
            // Abort
            return;
    }

    CCLOG(@"remove (%f,%f)", mapLocation.x, mapLocation.y);
    [layer removeTileAt:mapLocation];
    
}


/*-----------------------------------------------------------------------------------------------
 * Scroll the map the number of pixels in the given delta direction
 *-----------------------------------------------------------------------------------------------*/ 
-(void)scrollMapInGivenDirection:(CGPoint)offset{
    
    tiledMap.position = ccpSub(tiledMap.position, offset);
    
}

- (CGPoint)tiledMapPosition
{
    return tiledMap.position;
}


/*-----------------------------------------------------------------------------------------------
 * This will look up the the current map offset, look at the location given and compute what
 * map location this relates to
 *-----------------------------------------------------------------------------------------------*/ 
-(CGPoint)convertScreenLocationToMapLocation:(CGPoint)screenLocation{
    
    CGPoint adjustedOffset = ccpSub(screenLocation, tiledMap.position);
    
    CGPoint mapLocation = CGPointMake((NSInteger)(adjustedOffset.x / tiledMap.tileSize.width) + 1, (NSInteger)(mapSize.height - adjustedOffset.y / tiledMap.tileSize.height) + 1);
    
    /*
    CCLOG(@"  (%f,%f)", mapLocation.x, mapLocation.y);
    CCTMXLayer *enemyLayer = [tiledMap layerNamed:@"background"];
	[enemyLayer removeTileAt:mapLocation];
    */
    
    return mapLocation;
}


/*-----------------------------------------------------------------------------------------------
 * Decode
 *-----------------------------------------------------------------------------------------------*/ 
-(NSString *)decodeContents:(MapContentType)contents{
    
    switch (contents) {
        case kMapContentGoal:
            return @"Goal";
        case kMapContentWall:
            return @"Wall";
        case kMapContentEnemy:
            return @"Enemy";
        case kMapContentTreasure:
            return @"Treasure";
        default:
            return @"Blank";
    }
}


/*-----------------------------------------------------------------------------------------------
 * Return the contents of the map at the given location
 *-----------------------------------------------------------------------------------------------*/ 
-(MapContentType)contentAtLocation:(CGPoint)mapLocation{
    
    if(gameOver)
        return kMapContentBlank;
    
    unsigned int graphicId;
    MapContentType contents = kMapContentBlank;
    
    // See if we've reached the goal
    if(abs(endLocation.origin.x - mapLocation.x) <= 1 && abs(tiledMap.mapSize.height - endLocation.origin.y - mapLocation.y) <= 1){
        //CCLOG(@"*******************");
        contents = kMapContentGoal;
        gameOver = YES;
        
        WGGameOverLayer *gameOverLayer = [WGGameOverLayer setupWithData:YES];
        [self addChild:gameOverLayer z:9999];
        return kMapContentBlank;
                                          
        
    } else {
        
        // Go through all the layers - start with the top
        CCTMXLayer *enemyLayer = [tiledMap layerNamed:@"enemies"];
        graphicId = [enemyLayer tileGIDAt:mapLocation];
        if(graphicId > 0){
            contents = kMapContentEnemy;
        } else {
            
            CCTMXLayer *treasureLayer = [tiledMap layerNamed:@"treasure"];
            graphicId = [treasureLayer tileGIDAt:mapLocation];
            if(graphicId > 0) {
                contents = kMapContentTreasure;
            } else{
                
                CCTMXLayer *wallLayer = [tiledMap layerNamed:@"walls"];
                graphicId = [wallLayer tileGIDAt:mapLocation];
                if(graphicId > 0)
                    contents = kMapContentWall;
            }
        }
    }
    
    [hitDisplay setString:[self decodeContents:contents]];
    
    return contents;
}


/*-----------------------------------------------------------------------------------------------
 * Return the contents of the map at the given location
 *-----------------------------------------------------------------------------------------------*/ 
-(MapContentType)contentsAtPlayerScreenLocation:(CGPoint)screenLocation{
    
    CGPoint adjustedOffset = ccpSub(screenLocation, tiledMap.position);
    
    CGFloat baseX = adjustedOffset.x / tiledMap.tileSize.width;
    CGFloat baseY = mapSize.height - adjustedOffset.y / tiledMap.tileSize.height;
    
    CGPoint topLeft = ccp((NSInteger)baseX, (NSInteger)baseY - 1);
    CGPoint topRight = ccp((NSInteger)baseX + 1, (NSInteger)baseY - 1);
    CGPoint bottomLeft = ccp((NSInteger)baseX, (NSInteger)baseY);
    CGPoint bottomRight = ccp((NSInteger)baseX + 1, (NSInteger)baseY);
    
    MapContentType contentsTopRight = [self contentAtLocation:topRight];
    MapContentType contentsTopLeft = [self contentAtLocation:topLeft];
    MapContentType contentsBottomRight = [self contentAtLocation:bottomRight];
    MapContentType contentsBottomLeft = [self contentAtLocation:bottomLeft];
    
    BOOL hitEnemy = NO;
    BOOL hitWall = NO;
    BOOL hitTreasure = NO;
    BOOL hitGoal = NO;
    
    switch (contentsTopRight) {
        case kMapContentGoal:
            hitGoal = YES;
            break;
        case kMapContentWall:
            hitWall = YES;
            break;
        case kMapContentEnemy:
            hitEnemy = YES;
            break;
        case kMapContentTreasure:
            hitTreasure = YES;
            [self removeTile:topRight tileType:contentsTopRight];
            break;
        default:
            break;
    }
    switch (contentsTopLeft) {
        case kMapContentGoal:
            hitGoal = YES;
            break;
        case kMapContentWall:
            hitWall = YES;
            break;
        case kMapContentEnemy:
            hitEnemy = YES;
            break;
        case kMapContentTreasure:
            hitTreasure = YES;
            [self removeTile:topLeft tileType:contentsTopLeft];
            break;
        default:
            break;
    }
    switch (contentsBottomRight) {
        case kMapContentGoal:
            hitGoal = YES;
            break;
        case kMapContentWall:
            hitWall = YES;
            break;
        case kMapContentEnemy:
            hitEnemy = YES;
            break;
        case kMapContentTreasure:
            hitTreasure = YES;
            [self removeTile:bottomRight tileType:contentsBottomRight];
            break;
        default:
            break;
    }
    switch (contentsBottomLeft) {
        case kMapContentGoal:
            hitGoal = YES;
            break;
        case kMapContentWall:
            hitWall = YES;
            break;
        case kMapContentEnemy:
            hitEnemy = YES;
            break;
        case kMapContentTreasure:
            hitTreasure = YES;
            [self removeTile:bottomLeft tileType:contentsBottomLeft];
            break;
        default:
            break;
    }
    
    MapContentType contents;
    if(hitGoal){
        contents = kMapContentGoal;
    } else if(hitEnemy) {
        contents = kMapContentEnemy;
    } else if (hitWall) {
        contents = kMapContentWall;
    } else if (hitTreasure) {
        contents = kMapContentTreasure;
    } else {
        contents = kMapContentBlank;
    }
    
    /*
    CCLOG(@"  (%f,%f)", topLeft.x, topLeft.y);
    CCTMXLayer *enemyLayer = [tiledMap layerNamed:@"background"];
	[enemyLayer removeTileAt:topLeft];
*/
    
    return contents;
}


/*-----------------------------------------------------------------------------------------------
 * Load the current map level
 *-----------------------------------------------------------------------------------------------*/ 
-(void)loadMap:(NSInteger)levelNumer{
    NSString *mapName = [NSString stringWithFormat:@"level%ld.tmx", (long)levelNumer];
    CCLOG(@"MapLayer.loadMap: (%@)", mapName);
    
    tiledMap = [CCTMXTiledMap tiledMapWithTMXFile:mapName];
    [self addChild:tiledMap z:0];
    mapSize = tiledMap.mapSize;
    
    for(CCTMXLayer* child in [tiledMap children] ) {
        [[child texture] setAntiAliasTexParameters];
    }
    
    // Process the start and end location
    CCTMXObjectGroup *mapObjects = [tiledMap objectGroupNamed:@"special"];
	NSInteger numObjects = [[mapObjects objects]count];
	for(NSInteger loop = 0; loop < numObjects; loop++){
		NSDictionary *properties = [[mapObjects objects]objectAtIndex:loop];
		NSString *type = [properties valueForKey:@"name"];
		CGFloat rawX = [[properties valueForKey:@"x"]floatValue] / tiledMap.tileSize.width;
		//CGFloat rawY = tiledMap.mapSize.height - [[properties valueForKey:@"y"]floatValue] / tiledMap.tileSize.width;
		CGFloat rawY = [[properties valueForKey:@"y"]floatValue] / tiledMap.tileSize.width;
		CGFloat width = [[properties valueForKey:@"width"]floatValue] / tiledMap.tileSize.width;
		CGFloat height = [[properties valueForKey:@"height"]floatValue] / tiledMap.tileSize.width;
        CCLOG(@"type:(%@) (%f,%f) (%fx%f)", type, rawX, rawY, width, height);
        if([type compare:@"start"] == NSOrderedSame){
            CCLOG(@"start");
            startLocation = CGRectMake(rawX, rawY, width, height);
        } else if([type compare:@"goal"] == NSOrderedSame){
            CCLOG(@"goal");
            endLocation = CGRectMake(rawX, rawY, width, height);
            
            CCSprite *goal = [CCSprite spriteWithFile:@"goal.png"];
            goal.anchorPoint = ccp(0, 0);
            goal.position = ccpMult(endLocation.origin, tiledMap.tileSize.width);
            goal.scale = 0.5;
            
            [goal runAction:[CCRepeatForever actionWithAction:
                             	[CCSequence actions:
                                 	[CCScaleTo actionWithDuration:0.5 scale:0.1], 
                                	[CCScaleTo actionWithDuration:0.5 scale:0.5], 
                                 nil]]];
            
            [tiledMap addChild:goal z:100 tag:42];
        }
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
    gameOver = NO;
    startLocation = CGRectZero;
    endLocation = CGRectZero;
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    [self loadMap:mapNumber];
    
    tiledMap.position = ccp(- startLocation.origin.x * tiledMap.tileSize.width + winSize.width * 0.5, - (tiledMap.mapSize.height - startLocation.origin.y) * tiledMap.tileSize.height + winSize.height * 0.5);

    hitDisplay = [CCLabelTTF labelWithString:@"test" fontName:@"Verdana" fontSize:12];
    hitDisplay.position = ccp(winSize.width * 0.5, winSize.height * 0.85);
    hitDisplay.anchorPoint = ccp(0.5, 1);
    [self addChild:hitDisplay z:1];
    
    return self;
}


/*-----------------------------------------------------------------------------------------------
 * Initialise with parameters
 *-----------------------------------------------------------------------------------------------*/ 
+(id)setupWithData:(NSInteger)levelNumer{
    
    return [[self alloc]initWithSetup:levelNumer];
    
}



@end

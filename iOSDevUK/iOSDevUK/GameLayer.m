//
//  GameLayer.m
//  DragonGame
//
//  Created by Dean Morris on 12/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

@synthesize dragon=_dragon;

/*-----------------------------------------------------------------------------------------------
 * Get the next sprite tag
 *-----------------------------------------------------------------------------------------------*/ 
-(NSInteger)nextTag{
	nextTag++;
	return nextTag;
}


/*-----------------------------------------------------------------------------------------------
 * Move the dragon
 *-----------------------------------------------------------------------------------------------*/ 
-(void)moveCharacter:(CGPoint)direction {
    
    [mapLayer scrollMapInGivenDirection: direction];
    
    // Get the map location for the character
    CCSprite *character = (CCSprite *)[self getChildByTag:tagDragon];
    
    // See what's at the new location
    MapContentType mapContents = [mapLayer contentsAtPlayerScreenLocation:character.position];
    //CCLOG(@"contents at (%f,%f): %d", mapLocation.x, mapLocation.y, mapContents);
    
    CGPoint mapLocation = [mapLayer convertScreenLocationToMapLocation:character.position];
    switch (mapContents) {
        case kMapContentEnemy:
            CCLOG(@"enemy");
            [statusLayer adjustHealth:-1];
            break;
        case kMapContentTreasure:
            CCLOG(@"treasure");
            [statusLayer adjustHealth:+1];
            [mapLayer removeTile:mapLocation tileType:mapContents];
            break;
        case kMapContentWall:
            CCLOG(@"wall");
            [mapLayer scrollMapInGivenDirection: ccp(-direction.x, -direction.y)];
            break;
        default:
            break;
    }
    
    // Are we dead?
    if(statusLayer.health <= 0)
        CCLOG(@"Game Over");
    
}


/*-----------------------------------------------------------------------------------------------
 * Move the dragon to the given position - allows for updates after network drops
 *-----------------------------------------------------------------------------------------------*/ 
-(void)moveCharacterToPosition:(CGPoint)position{
    CGPoint difference = ccpSub(position, _dragon.position);
    [self moveCharacter:difference];
}


/*-----------------------------------------------------------------------------------------------
 * See what they touched!
 *-----------------------------------------------------------------------------------------------*/ 
-(void)handleTouch:(CGPoint)point{
	
	for(CCNode *child in self.children){
		if(child.tag == tagLeft && CGRectContainsPoint(child.boundingBox, point)){
			CCLOG(@"left pressed");
			[self moveCharacter:ccp(-1, 0)];
        } else if(child.tag == tagRight && CGRectContainsPoint(child.boundingBox, point)){
            CCLOG(@"right pressed");
            [self moveCharacter:ccp(1, 0)];
        } else if(child.tag == tagDown && CGRectContainsPoint(child.boundingBox, point)){
            CCLOG(@"down pressed");
            [self moveCharacter:ccp(0, -1)];
        } else if(child.tag == tagUp && CGRectContainsPoint(child.boundingBox, point)){
            CCLOG(@"up pressed");
            [self moveCharacter:ccp(0, 1)];
        }
    }
}


/*-----------------------------------------------------------------------------------------------
 * ccTouchEnded
 *-----------------------------------------------------------------------------------------------*/ 
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	//NSLog(@"touch ended");
	
	//[self handleTouch:touch];
	
}


/*-----------------------------------------------------------------------------------------------
 * ccTouchBegan
 *-----------------------------------------------------------------------------------------------*/ 
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	//NSLog(@"touch began");
	
	// Convert the touch to our co-ordinate system
	CGPoint point = [self convertTouchToNodeSpace:touch];
	[self handleTouch:point];
	
	return NO;
}


/*-----------------------------------------------------------------------------------------------
 * Add controls to the game
 *-----------------------------------------------------------------------------------------------*/ 
-(void)addControls{
    
    CCSprite *left = [CCSprite spriteWithFile:@"left.png"];
    left.anchorPoint = ccp(0, 0);
    left.position = ccp(10, 10);
    tagLeft = [self nextTag];
    [self addChild:left z:kGameLevelControls tag:tagLeft];
    
    CCSprite *down = [CCSprite spriteWithFile:@"down.png"];
    down.anchorPoint = ccp(0, 0);
    down.position = ccpAdd(left.position, ccp(left.contentSize.width + 10, 0));
    tagDown = [self nextTag];
    [self addChild:down z:kGameLevelControls tag:tagDown];
    
    CCSprite *right = [CCSprite spriteWithFile:@"right.png"];
    right.anchorPoint = ccp(0, 0);
    right.position = ccpAdd(down.position, ccp(down.contentSize.width + 10, 0));
    tagRight = [self nextTag];
    [self addChild:right z:kGameLevelControls tag:tagRight];

    CCSprite *up = [CCSprite spriteWithFile:@"up.png"];
    up.anchorPoint = ccp(0, 0);
    up.position = ccpAdd(left.position, ccp(left.contentSize.width + 10, left.contentSize.height + 10));
    tagUp = [self nextTag];
    [self addChild:up z:kGameLevelControls tag:tagUp];

}


/*-----------------------------------------------------------------------------------------------
 * Initialise the graphics
 *-----------------------------------------------------------------------------------------------*/ 
-(void)setupGraphics{
    
    winSize = [[CCDirector sharedDirector]winSize];
    
    // Load the sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dragon images.plist"];
    
    // Create a batch node
    batchNode = [CCSpriteBatchNode batchNodeWithFile:@"dragon images.png"];

    // Create the dragon sprite
    _dragon = [CCSprite spriteWithSpriteFrameName:@"dragon1.png"];
    //_dragon.anchorPoint = ccp(1, 1);
    _dragon.position = ccp(winSize.width * 0.5, winSize.height * 0.5);

    // Create the animation
    NSMutableArray *frameArray = [[NSMutableArray alloc]init];
    NSInteger numFrames = 10;
    for(NSInteger loop = 1; loop <= numFrames; loop++){
        //CCLOG(@"%@",[NSString stringWithFormat:@"Daisy Walk%04d.png", (long)loop]);
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dragon%d.png", 60 + (long)loop]];
        [frameArray addObject:frame];
    }
    for(NSInteger loop = numFrames - 1; loop >= 1; loop--){
        //CCLOG(@"%@",[NSString stringWithFormat:@"Daisy Walk%04d.png", (long)loop]);
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dragon%d.png", 60 +(long)loop]];
        [frameArray addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:1.0/12.0];
    CCAnimate *animateAction = [CCAnimate actionWithAnimation:animation];
    
    [_dragon runAction:[CCRepeatForever actionWithAction:animateAction]];
    
    tagDragon = [self nextTag];
	[self addChild: _dragon z:kGameLevelDragon tag:tagDragon];
    
    [self addControls];
}


/*-----------------------------------------------------------------------------------------------
 * onEnter
 *-----------------------------------------------------------------------------------------------*/ 
-(void)onEnter{
    //CCLOG(@"GameLayer.onEnter");
    
	[super onEnter];
    
	// Allow touches
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:1 swallowsTouches:NO];
    
}


/*-----------------------------------------------------------------------------------------------
 * onExit
 *-----------------------------------------------------------------------------------------------*/ 
-(void)onExit{
	// Turn on the touch handler
	[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    
	[super onExit];
    
}


/*-----------------------------------------------------------------------------------------------
 * Initialise the app
 *-----------------------------------------------------------------------------------------------*/ 
-(id) initWithSetup{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if(!(self = [super init])) {
        NSLog(@"GameLayer.init failed");
        return nil;
    }
	mapLayer = [MapLayer setupWithData:1];

    tagMap = [self nextTag];
    [self addChild:mapLayer z:kGameLevelMap tag:tagMap];
    
    [self setupGraphics];
    
    statusLayer = [WGStatusLayer setupWithData:20 maxHealth:20];
    [self addChild:statusLayer z:kGameLevelHUD tag:1024];

    return self;
}


/*-----------------------------------------------------------------------------------------------
 * Initialise with parameters
 *-----------------------------------------------------------------------------------------------*/ 
+(id)setupWithData{
	
	return [[[self alloc]initWithSetup] autorelease];
	
}


/*-----------------------------------------------------------------------------------------------
 * Create the scene
 *-----------------------------------------------------------------------------------------------*/ 
/*
+(CCScene *)scene{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameLayer *layer = [GameLayer node];
    
    // add layer as a child to scene
    [scene addChild:layer];
    
    // return the scene
    return scene;
}
*/

@end

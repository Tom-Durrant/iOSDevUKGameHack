//
//  WGGameOverLayer.m
//  iOSDevUK
//
//  Created by Dean Morris on 13/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import "WGGameOverLayer.h"


@implementation WGGameOverLayer

-(void)addLabel:(NSString *)message offset:(CGPoint)offset colour:(ccColor3B)colour{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
 
    CCLabelTTF * messageLabel = [CCLabelTTF labelWithString:message fontName:@"Verdana" fontSize:40];
    messageLabel.position = ccp(winSize.width * 0.5 + offset.x, winSize.height * 0.5 + offset.y);
    messageLabel.anchorPoint = ccp(0.5, 1);
    messageLabel.color = colour;
    [self addChild:messageLabel z:1];
    
}

/*-----------------------------------------------------------------------------------------------
 * Next level
 *-----------------------------------------------------------------------------------------------*/ 
-(void)playPressed{
    CCLOG(@"replay");
}


/*-----------------------------------------------------------------------------------------------
 * See what they touched!
 *-----------------------------------------------------------------------------------------------*/ 
-(void)handleTouch:(CGPoint)point{
	
	for(CCNode *child in self.children){
		if(child.tag == 1234 && CGRectContainsPoint(child.boundingBox, point)){
			CCLOG(@"replay pressed");
			[self playPressed];
            //} else if(child.tag == tagButtonStart && CGRectContainsPoint(child.boundingBox, point)){
            //	CCLOG(@"play pressed");
            //	[self startGame];
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
	CCLOG(@"ccTouchBegan");
	
	// Convert the touch to our co-ordinate system
	CGPoint point = [self convertTouchToNodeSpace:touch];
	
	[self handleTouch:point];
	
	//NSLog(@"<--touch began");
	return YES;
}


/*-----------------------------------------------------------------------------------------------
 * onEnter
 *-----------------------------------------------------------------------------------------------*/ 
-(void)onEnter{
	
    
	// Allow touches
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
    
    
}


/*-----------------------------------------------------------------------------------------------
 * onExit
 *-----------------------------------------------------------------------------------------------*/ 
-(void)onExit{
	// Turn on the touch handler
	[[CCDirector sharedDirector].touchDispatcher  removeDelegate:self];
	[super onExit];
    
}


/*-----------------------------------------------------------------------------------------------
 * Class constructor
 *-----------------------------------------------------------------------------------------------*/ 
-(id)initWithSetup:(NSInteger)victory{
	
	if(!(self = [super init])){
		NSLog(@"WGGameOverLayer.init fail");
		return nil;
	}
 
    NSString *imageName, *message;
    if(victory){
    	imageName = @"game_won.png";
        message = @"You're awesome.  You win.  Nice shoes.";
    } else {
    	imageName = @"game_lost.png";
        //message = @"Game Over. You still have nice hair.";
        message = @"";
    }
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    CCSprite *background = [CCSprite spriteWithFile:imageName];
    background.position = ccp(winSize.width * 0.5, winSize.height * 0.5);
    [self addChild:background z:0];
 
    [self addLabel:message offset:ccp(-1, 0) colour:ccc3(100, 0, 0)];
    [self addLabel:message offset:ccp(1, 0) colour:ccc3(100, 0, 0)];
    [self addLabel:message offset:ccp(0, 1) colour:ccc3(100, 0, 0)];
    [self addLabel:message offset:ccp(0, -1) colour:ccc3(100, 0, 0)];
    [self addLabel:message offset:ccp(0, 0) colour:ccc3(255, 255, 255)];
    
    CCSprite *nextLevel = [CCSprite spriteWithFile:@"right.png"];
    nextLevel.position = ccp(winSize.width * 0.5, winSize.height * 0.2);
    [self addChild:nextLevel z:999 tag:1234];
    [nextLevel runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.5 scale:0.5], [CCScaleTo actionWithDuration:0.5 scale:1.5], nil]]];
    
    // Pause the game
    [[CCDirector sharedDirector]pause];
    
    return self;
}


/*-----------------------------------------------------------------------------------------------
 * Initialise with parameters
 *-----------------------------------------------------------------------------------------------*/ 
+(id)setupWithData:(BOOL)victory{
    
    return [[self alloc]initWithSetup:victory];
    
}

@end

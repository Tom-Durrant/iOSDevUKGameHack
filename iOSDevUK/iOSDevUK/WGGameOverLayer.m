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

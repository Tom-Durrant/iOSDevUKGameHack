//
//  WGStatusLayer.m
//  iOSDevUK
//
//  Created by Dean Morris on 13/07/2012.
//  Copyright 2012 home. All rights reserved.
//

#import "WGStatusLayer.h"


@implementation WGStatusLayer
@synthesize health, maxHealth;



/*-----------------------------------------------------------------------------------------------
 * Adjust the health up or down
 *-----------------------------------------------------------------------------------------------*/ 
-(void)adjustHealth:(NSInteger)changedAmount{
}


/*-----------------------------------------------------------------------------------------------
 * Class constructor
 *-----------------------------------------------------------------------------------------------*/ 
-(id)initWithSetup:(NSInteger)initial maxHealth:(NSInteger)max{
	
	if(!(self = [super init])){
		NSLog(@"WGStatusLayer.init fail");
		return nil;
	}
    
    health = initial;
    maxHealth = max;
    CGSize winSize = [[CCDirector sharedDirector]winSize];

    // Create all the health bars
    for(NSInteger loop = 0; loop < maxHealth; loop++){
        CCSprite *bar = [CCSprite spriteWithFile:@"strength_bar.png"];
        bar.anchorPoint = ccp(0, 0);
        bar.position = ccp(0 + loop * bar.contentSize.width, winSize.height - bar.contentSize.height * 2);
        bar.color = ccc3(0, 0.8, 0);
        [self addChild:bar z:1 tag:100 + loop];
                           
    }
    
    return self;
}


/*-----------------------------------------------------------------------------------------------
 * Initialise with parameters
 *-----------------------------------------------------------------------------------------------*/ 
+(id)setupWithData:(NSInteger)initial maxHealth:(NSInteger)max{
    
    return [[[self alloc]initWithSetup:initial maxHealth:max]autorelease];
    
}

/*
-(void)dealloc{
    
    healthArray = nil;
    [super dealloc];
}
*/

@end

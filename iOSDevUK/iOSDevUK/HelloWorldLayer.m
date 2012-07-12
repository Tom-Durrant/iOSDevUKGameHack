//
//  HelloWorldLayer.m
//  iOSDevUK
//
//  Created by Stuart Crook on 12/07/2012.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "WGPlayer1.h"
#import "WGPlayer2.h"
#import "GameSessionManager.h"

#define STEP 1.0f
#define SENSETIVITY 2.0f
#define MAX_ANGLE_CHANGE 360.0f/64.0f
#define MOVEMENT_SPEED 2.0f

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer ()
-(void)gotDataNotification:(NSNotification *)note;
-(void)sendFloat:(CGFloat)f;
@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize mode=_mode;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene {
    return [self sceneWithMode: kModeBoth];
}

+(CCScene *)sceneWithMode:(WGMode)mode {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initWithMode: mode] autorelease];//[HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
//-(id) init 
-(id)initWithMode:(WGMode)mode
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        _mode = mode;
        
		// create and initialize a Label
        //_label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		//_label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		//[self addChild: _label z:9999];
        
        [self schedule: @selector(update:)];

        UIView *glView = [[CCDirector sharedDirector] openGLView];
        UIView *view;
        UIPanGestureRecognizer *pgr;
        
        // horizontal movement
        if(_mode != kModePlayer2) {
            view = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 512.0f, 768.0f)];
            [view setBackgroundColor: [UIColor colorWithRed: 1.0f green: 0.0f blue: 0.0f alpha: 0.1f]];
            [glView addSubview: view]; [view release];
            pgr = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(panX:)];
            [view addGestureRecognizer: pgr]; [pgr release];
        }
    
        // vertical movement
        if(_mode != kModePlayer1) {
            view = [[UIView alloc] initWithFrame: CGRectMake(512.0f, 0.0f, 512.0f, 768.0f)];
            [view setBackgroundColor: [UIColor colorWithRed: 0.0f green: 1.0f blue: 0.0f alpha: 0.1f]];
            [glView addSubview: view]; [view release];
            pgr = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(panY:)];
            [view addGestureRecognizer: pgr]; [pgr release];
        }
        
        // register for data notifications
        if(_mode != kModeBoth) {
            [[NSNotificationCenter defaultCenter] addObserver: self
                                                     selector: @selector(gotDataNotification:)
                                                         name: @"didReceiveData"
                                                       object: nil];
        }
        
        _vy = STEP;
	}

    // Add the game layer in
    _gameLayer = [GameLayer setupWithData];
    [self addChild: _gameLayer z:100 tag:666];

	return self;
}

// on "dealloc" you need to release all your retained objects
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    for(UIView *view in [[[CCDirector sharedDirector] openGLView] subviews]) {
        [view removeFromSuperview];
    }
    
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

CGFloat angles[3][3] = { 
    { 225.0f, 270.0f, 315.0f },
    { 180.0f, NAN, 0.0f },
    { 135.0f, 90.0f, 45.0f }
};

-(void)update:(ccTime)delta {

    CGFloat dx, dy;
    if(0.0f != (dx = [[WGPlayer1 shared] deltaX])) {
        _vx = dx;
    }
    if(0.0f != (dy = [[WGPlayer2 shared] deltaY])) {
        _vy = dy;
    }
    [_gameLayer moveCharacter: CGPointMake(_vx, _vy)];
    
    int x = (dx < 0.0f) ? 0 : ((dx > 0.0f) ? 2 : 1);
    int y = (dy < 0.0f) ? 0 : ((dy > 0.0f) ? 2 : 1);
    CGFloat angle = angles[x][y] - 90.0f;
    [[_gameLayer dragon] setRotation: angle];

/*
    CGPoint pos = CGPointZero; // because _label.position;
    CGFloat dx = [[WGPlayer1 shared] deltaX];
    CGFloat dy = [[WGPlayer2 shared] deltaY];
    int x = (dx < 0.0f) ? 0 : ((dx > 0.0f) ? 2 : 1);
    int y = (dy < 0.0f) ? 0 : ((dy > 0.0f) ? 2 : 1);
    CGFloat angle = angles[x][y] - 90.0f;
    //[_label setString: [NSString stringWithFormat: @"%f", angle]];

    if(!isnan(angle)) {
        CGFloat change = 0.0f;
        
        CGFloat difference = angle - _CurrentAngle;
        if(difference < -180.0f) { difference += 360.0f; }
        else if(difference > 180.0f) { difference -= 360.0f; }
        
        // Fix issue where 180 turns between 4 cardinal compass points
        if (difference == 180.0f || difference == -180.0f)
        {
            if (_CurrentAngle == 0.0f)
            {
                difference = 180.0f;
            }
            else if (_CurrentAngle == 90.0f)
            {
                difference = 180.0f;
            }
            else if (_CurrentAngle == 180.0f)
            {
                difference = -180.0f;
            }
            else if (_CurrentAngle == 270.0f)
            {
                difference = -180.0f;
            }
        }
        
        
        
    if (difference)
        change = min(fabsf(difference), MAX_ANGLE_CHANGE) * (difference / fabsf(difference));
    
    //if(NAN == angle) return;
        _CurrentAngle += change;
        
        if(_CurrentAngle < 0.0f) { _CurrentAngle += 360.0f; }
        else if(_CurrentAngle > 360.0f) { _CurrentAngle -= 360.0f; }
    }
    
    pos.x = cosf(CC_DEGREES_TO_RADIANS(_CurrentAngle)) * MOVEMENT_SPEED;
    pos.y = -sinf(CC_DEGREES_TO_RADIANS( _CurrentAngle)) * MOVEMENT_SPEED;
    
    [_gameLayer moveCharacter: pos];
    [[_gameLayer dragon] setRotation: _CurrentAngle + 90.0f];
*/
}


-(void)panX:(UIGestureRecognizer *)gr {
    CGFloat delta = 0.0f;
    UIView *view = [[CCDirector sharedDirector] openGLView];
    switch([gr state]) {
        case UIGestureRecognizerStateChanged:
            //delta = [(UIPanGestureRecognizer *)gr velocityInView: view].x;
            delta = [(UIPanGestureRecognizer *)gr translationInView: view].x;
            //[(UIPanGestureRecognizer *)gr setTranslation: CGPointZero inView: view];
            if(delta < -SENSETIVITY) { delta = -STEP; }
            else if(delta > SENSETIVITY) { delta = STEP; }
            else { delta = 0.0f; }
            break;
            
        default:
            break;
    }
    [[WGPlayer1 shared] setDeltaX: delta];
    if(_mode != kModeBoth) { [self sendFloat: delta]; }
}

-(void)panY:(UIGestureRecognizer *)gr {
    CGFloat delta = 0.0f;
    UIView *view = [[CCDirector sharedDirector] openGLView];
    switch([gr state]) {
        case UIGestureRecognizerStateChanged:
            //delta = [(UIPanGestureRecognizer *)gr velocityInView: view].y;
            delta = [(UIPanGestureRecognizer *)gr translationInView: view].y;
            //[(UIPanGestureRecognizer *)gr setTranslation: CGPointZero inView: view];
            if(delta < -SENSETIVITY) { delta = STEP; }
            else if(delta > SENSETIVITY) { delta = -STEP; }
            else { delta = 0.0f; }
            break;
            
        default:
            break;
    }
    [[WGPlayer2 shared] setDeltaY: delta];
    if(_mode != kModeBoth) { [self sendFloat: delta]; }
}

-(void)sendFloat:(CGFloat)f {
    NSMutableData *data = [NSMutableData data];
    [data appendBytes: &f length: sizeof(CGFloat)];
    [[GameSessionManager sharedManager] sendData: data];
}

-(void)gotDataNotification:(NSNotification *)note {
    if(_mode == kModeBoth) { return; } // shouldn't ever happen
    NSData *data = (NSData *)[note object];
    CGFloat f;
    [data getBytes: &f length: sizeof(CGFloat)];
    switch(_mode) {
        case kModePlayer1:
            [[WGPlayer2 shared] setDeltaY: f];
            break;
            
        case kModePlayer2:
            [[WGPlayer1 shared] setDeltaX: f];
            break;
            
        default: break;
    }
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

#undef STEP
#undef SENSETIVITY


@end

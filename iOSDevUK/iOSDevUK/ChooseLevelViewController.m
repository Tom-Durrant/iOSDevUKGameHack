//
//  ChooseLevelViewController.m
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseLevelViewController.h"
#import "GameSessionManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface ChooseLevelViewController () {
    bool observingReceivedDataNotification;
}

@end

@implementation ChooseLevelViewController

@synthesize playerMode, chosenLevel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)receivedData:(NSNotification *)notification
{
    NSData *data = notification.object;
    if ([data isKindOfClass:[NSData class]]) {
        int type = ((int *)[data bytes])[0];
        if (type == kChoseLevel) {
            int number = ((int *)[data bytes])[1];
            
            self.chosenLevel = number;
            
            if (observingReceivedDataNotification) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }
            observingReceivedDataNotification = NO;
            
            UIView *otherPlayerChoseModeView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)] autorelease];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            otherPlayerChoseModeView.center = window.center;
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(50, 50, 380, 220)] autorelease];
            label.textAlignment = UITextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = [NSString stringWithFormat:@"Your friend chose level %i", number];
            [otherPlayerChoseModeView addSubview:label];
            
            otherPlayerChoseModeView.layer.cornerRadius = 10;
            otherPlayerChoseModeView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
            otherPlayerChoseModeView.layer.borderWidth = 2;
            
            [window addSubview:otherPlayerChoseModeView];
            
            double delayInSeconds = 1.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:1 animations:^{
                    otherPlayerChoseModeView.alpha = 0;
                } completion:^(BOOL finished) {
                    [otherPlayerChoseModeView removeFromSuperview];
                }];
            });
            
            [((AppController *)[UIApplication sharedApplication].delegate) beginGameWithPlayerType:playerMode andLevelNumber:chosenLevel];
            //begin game.
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData:) name:@"didReceiveData" object:nil];
    observingReceivedDataNotification = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)levelButtonPressed:(UIButton *)sender
{
    int type = kChoseLevel;
    NSMutableData *data = [NSMutableData dataWithBytes:&type length:sizeof(int)];
    int number = sender.tag;
    [data appendBytes:&number length:sizeof(int)];
    [[GameSessionManager sharedManager] sendData:data];
    
    chosenLevel = number;
    
    [((AppController *)[UIApplication sharedApplication].delegate) beginGameWithPlayerType:playerMode andLevelNumber:chosenLevel];
}

@end

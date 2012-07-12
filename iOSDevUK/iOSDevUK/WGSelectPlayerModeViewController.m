//
//  WGSelectPlayerModeViewController.m
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WGSelectPlayerModeViewController.h"
#import "GameSessionManager.h"
#import "ChooseLevelViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WGSelectPlayerModeViewController () {
    bool observingReceivedDataNotification;
    int playerType;
}

@end

@implementation WGSelectPlayerModeViewController

@synthesize upDownButton, leftRightButton;
@synthesize buttonClickDate;

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
        if (type == kChosePlayerMode) {
            int number = ((int *)[data bytes])[1];
            
            if (number == kModePlayer1) {
                playerType = kModePlayer2;
            } else playerType = kModePlayer1;
            
            [self performSegueWithIdentifier:@"ShowLevelChooserSegue" sender:self];
            
            UIView *otherPlayerChoseModeView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)] autorelease];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            otherPlayerChoseModeView.center = window.center;
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(50, 50, 380, 220)] autorelease];
            label.textAlignment = UITextAlignmentCenter;
            label.numberOfLines = 0;
            NSString *string1 = number == kModePlayer1 ? @"'Left and Right'" : @"'Up and Down'";
            NSString *string2 = playerType == kModePlayer1 ? @"'Left and Right'" : @"'Up and Down'";
            label.text = [NSString stringWithFormat:@"Your friend chose %@, so you're now %@", string1, string2];
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
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowLevelChooserSegue"]) {
        ((ChooseLevelViewController *)segue.destinationViewController).playerMode = playerType;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData:) name:@"didReceiveData" object:nil];
    observingReceivedDataNotification = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (observingReceivedDataNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    observingReceivedDataNotification = NO;
    
    [super viewWillDisappear:animated];
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

- (void)upDownButtonPressed:(id)sender
{
    int type = kChosePlayerMode;
    NSMutableData *data = [NSMutableData dataWithBytes:&type length:sizeof(int)];
    int number = kModePlayer2;
    [data appendBytes:&number length:sizeof(int)];
    [[GameSessionManager sharedManager] sendData:data];
    
    playerType = number;
    
    [self performSegueWithIdentifier:@"ShowLevelChooserSegue" sender:self];
}

- (void)leftRightButtonPressed:(id)sender
{
    int type = kChosePlayerMode;
    NSMutableData *data = [NSMutableData dataWithBytes:&type length:sizeof(int)];
    int number = kModePlayer1;
    [data appendBytes:&number length:sizeof(int)];
    [[GameSessionManager sharedManager] sendData:data];
    
    playerType = number;
    
    [self performSegueWithIdentifier:@"ShowLevelChooserSegue" sender:self];
}

@end

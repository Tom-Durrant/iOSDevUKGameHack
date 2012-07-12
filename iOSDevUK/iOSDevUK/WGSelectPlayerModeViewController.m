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
        if (type == kChoseLevel) {
            int number = ((int *)[data bytes])[1];
            
            if (number == kModePlayer1) {
                playerType = kModePlayer2;
            } else playerType = kModePlayer1;
            
            if (observingReceivedDataNotification) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }
            observingReceivedDataNotification = NO;
            
            [self performSegueWithIdentifier:@"ShowLevelChooserSegue" sender:self];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData:) name:@"didConnect" object:nil];
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

- (void)upDownButtonPressed:(id)sender
{
    int type = kChosePlayerMode;
    NSMutableData *data = [NSMutableData dataWithBytes:&type length:sizeof(int)];
    int number = kModePlayer2;
    [data appendBytes:&number length:sizeof(int)];
    [[GameSessionManager sharedManager] sendData:data];
}

- (void)leftRightButtonPressed:(id)sender
{
    int type = kChosePlayerMode;
    NSMutableData *data = [NSMutableData dataWithBytes:&type length:sizeof(int)];
    int number = kModePlayer1;
    [data appendBytes:&number length:sizeof(int)];
    [[GameSessionManager sharedManager] sendData:data];
}

@end

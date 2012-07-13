//
//  WGConnectViewController.m
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WGConnectViewController.h"
#import "GameSessionManager.h"
#import "AppDelegate.h"

@interface WGConnectViewController () {
    bool observingConnectionNotification;
}

@end

@implementation WGConnectViewController

@synthesize connectButton;

- (void)releaseOutlets
{
    self.connectButton = nil;
}

- (void)dealloc
{
    [self releaseOutlets];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-Landscape~ipad"]] autorelease];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    imageView.frame = window.rootViewController.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [window.rootViewController.view addSubview:imageView];
    
    [UIView animateWithDuration:4 animations:^{
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self releaseOutlets];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (observingConnectionNotification) {
        observingConnectionNotification = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)connectionEstablished
{
    [self performSegueWithIdentifier:@"PushShowControlsSegue" sender:self];
}

- (void)connectButtonPressed:(id)sender
{
    [[GameSessionManager sharedManager] beginSession];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionEstablished) name:@"didConnect" object:nil];
    observingConnectionNotification = YES;
}

- (void)singlePlayerButtonPressed:(id)sender
{
    [((AppController *)[UIApplication sharedApplication].delegate) beginGameWithPlayerType:kModeBoth andLevelNumber:1];
}

@end

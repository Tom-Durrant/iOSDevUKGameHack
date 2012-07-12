//
//  WGSelectPlayerModeViewController.m
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WGSelectPlayerModeViewController.h"
#import "GameSessionManager.h"

@interface WGSelectPlayerModeViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
//    [GameSessionManager sharedManager] sendData:<#(NSData *)#>
}

- (void)leftRightButtonPressed:(id)sender
{
    
}

@end

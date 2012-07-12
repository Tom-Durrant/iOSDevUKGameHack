//
//  WGSelectPlayerModeViewController.h
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGSelectPlayerModeViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *upDownButton, *leftRightButton;
@property (nonatomic, retain) NSDate *buttonClickDate;

- (IBAction)upDownButtonPressed:(id)sender;
- (IBAction)leftRightButtonPressed:(id)sender;

@end

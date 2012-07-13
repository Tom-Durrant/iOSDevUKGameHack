//
//  ChooseLevelViewController.h
//  iOSDevUK
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseLevelViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;

@property int playerMode, chosenLevel;

- (IBAction)levelButtonPressed:(UIButton *)sender;

@end

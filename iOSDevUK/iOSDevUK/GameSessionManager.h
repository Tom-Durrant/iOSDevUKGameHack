//
//  GameSessionManager.h
//  gamecentertest
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameSessionManager : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate>

@property (nonatomic, strong) GKSession *session;
@property (nonatomic, strong) GKPeerPickerController *peerPicker;
@property (nonatomic, strong) NSString *peerID;

@property (nonatomic) int tick;

+ (GameSessionManager *)sharedManager;
- (void)beginSession;

- (void)sendData:(NSData *)data;

@end

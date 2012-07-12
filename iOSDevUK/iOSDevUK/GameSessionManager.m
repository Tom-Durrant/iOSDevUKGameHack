//
//  GameSessionManager.m
//  gamecentertest
//
//  Created by Tom Durrant on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameSessionManager.h"

@implementation GameSessionManager

@synthesize peerPicker;
@synthesize session;
@synthesize peerID;
@synthesize tick;

+ (GameSessionManager *)sharedManager
{
    static GameSessionManager *sharedManager = nil;
    if (!sharedManager) {
        sharedManager = [[GameSessionManager alloc] init];
    }
    return sharedManager;
}

- (void)beginSession
{
    self.peerPicker = [[GKPeerPickerController alloc] init];
    self.peerPicker.delegate = self;
    [self.peerPicker show];
}

- (void)timerFired
{
    NSString *string = [NSString stringWithFormat:@"Tick %i", tick++];
    NSLog(@"sending tick: %@", string);
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error) NSLog(@"%@", error);
}

#pragma mark - gkPeerPickerDelegate stuff

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)thePeerID toSession:(GKSession *)theSession
{
    self.session = theSession;
    self.peerID = thePeerID;
    
    NSLog(@"connected to peer: %@", self.peerID);
    
    picker.delegate = nil;
    [picker dismiss];
    self.peerPicker = nil;
    
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didConnect" object:[NSDate date]];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)sendData:(NSData *)data
{
    NSError *error = nil;
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (error) NSLog(@"%@", error);
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveData" object:data];
//    NSLog(@"received tick: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end

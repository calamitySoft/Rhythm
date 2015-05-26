//
//  CALMetronome.h
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

@import Foundation;
#import "CALMetronomeBeatRelationship.h"

@interface CALMetronome : NSObject

@property (readonly) BOOL actionAllowed; // simplification of beatRelationship
@property (readonly) CALMetronomeBeatRelationship beatRelationship; // KVO this
@property (readonly) float bpm;
@property (readonly) NSTimeInterval leadingLeniency; // length of time before a beat that actionAllowed == YES
@property (readonly) NSTimeInterval trailingLeniency; // length of time after a beat that actionAllowed == YES
@property (nonatomic, getter=isPaused) BOOL paused;

- (instancetype)initWithBPM:(float)bpm leadingLeniency:(NSTimeInterval)leadingLeniency trailingLeniency:(NSTimeInterval)trailingLeniency NS_DESIGNATED_INITIALIZER;

- (void)addBeatListener:(NSObject *)listener selector:(SEL)selector;
- (void)removeBeatListener:(NSObject *)listener;

- (void)start; // not thread-safe
- (void)stop;

@end

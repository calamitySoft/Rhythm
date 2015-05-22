//
//  CALMetronome.h
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

@import Foundation;

@interface CALMetronome : NSObject

@property (readonly) BOOL actionAllowed; // KVO this
@property (readonly) float bpm;
@property (readonly) NSTimeInterval leadingLeniency; // length of time before a beat that active == YES
@property (readonly) NSTimeInterval trailingLeniency; // length of time after a beat that active == YES
@property (readonly, getter=isPaused) BOOL paused;

- (instancetype)initWithBPM:(float)bpm leadingLeniency:(NSTimeInterval)leadingLeniency trailingLeniency:(NSTimeInterval)trailingLeniency NS_DESIGNATED_INITIALIZER;

- (void)start; // not thread-safe
- (void)invalidate;

@end

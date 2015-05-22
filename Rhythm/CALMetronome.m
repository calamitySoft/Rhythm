//
//  CALMetronome.m
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "CALMetronome.h"
@import QuartzCore;

@interface CALMetronome ()
@property (readwrite) BOOL active;
@property CADisplayLink *displayLink;
@property CFTimeInterval lastFireTime;
@property CFTimeInterval nextFireTime;
@property CFTimeInterval secondsPerBeat;
@end

@implementation CALMetronome

- (instancetype)initWithBPM:(float)bpm leadingLeniency:(NSTimeInterval)leadingLeniency trailingLeniency:(NSTimeInterval)trailingLeniency {
    self = [super init];
    if (self) {
        _active = NO;
        _bpm = bpm;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        _leadingLeniency = leadingLeniency;
        _trailingLeniency = trailingLeniency;
        _lastFireTime = 0;
        _nextFireTime = 0;
        _paused = YES;
        CFTimeInterval beatsPerSecond = self.bpm / 60.;
        _secondsPerBeat = 1. / beatsPerSecond;
    }
    return self;
}

- (void)dealloc {
    [self invalidate];
}

- (void)start {
    if (self.paused) {
        _paused = NO;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.lastFireTime = CACurrentMediaTime();
        self.nextFireTime = self.lastFireTime + self.secondsPerBeat;
    }
}

- (void)invalidate {
    [self.displayLink invalidate];
}

- (void)tick:(CADisplayLink *)displayLink {
    self.active = [self isActiveForTimestamp:displayLink.timestamp];
    self.lastFireTime = [self fireTimeLessThan:displayLink.timestamp];
    self.nextFireTime = [self fireTimeGreaterThanOrEqualTo:displayLink.timestamp];
    NSLog(@"displayLink .timestamp = %f, .duration = %f, active == %d", displayLink.timestamp, displayLink.duration, self.active);
}

- (BOOL)isActiveForTimestamp:(CFTimeInterval)timestamp {
    CFTimeInterval leadingDiff = self.nextFireTime - timestamp;
    CFTimeInterval trailingDiff = timestamp - self.lastFireTime;
    BOOL leadsWithinLeniency = leadingDiff >= 0 && leadingDiff < self.leadingLeniency;
    BOOL trailsWithinLeniency = trailingDiff >= 0 && trailingDiff < self.trailingLeniency;
    return leadsWithinLeniency || trailsWithinLeniency;
}

- (CFTimeInterval)fireTimeLessThan:(CFTimeInterval)timestamp {
    return (floor(timestamp/self.secondsPerBeat) - 1) * self.secondsPerBeat;
}

- (CFTimeInterval)fireTimeGreaterThanOrEqualTo:(CFTimeInterval)timestamp {
    return ceil(timestamp/self.secondsPerBeat) * self.secondsPerBeat;
}

@end

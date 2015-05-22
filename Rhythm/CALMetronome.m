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
@property (readwrite) BOOL actionAllowed;
@property CADisplayLink *displayLink;
@property CFTimeInterval startTime;
@property CFTimeInterval lastFireTime;
@property CFTimeInterval nextFireTime;
@property CFTimeInterval secondsPerBeat;
@property NSMapTable *selectorsByListener;
@end

@implementation CALMetronome

- (instancetype)initWithBPM:(float)bpm leadingLeniency:(NSTimeInterval)leadingLeniency trailingLeniency:(NSTimeInterval)trailingLeniency {
    self = [super init];
    if (self) {
        _actionAllowed = NO;
        _bpm = bpm;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        _leadingLeniency = leadingLeniency;
        _trailingLeniency = trailingLeniency;
        _lastFireTime = 0;
        _nextFireTime = 0;
        _paused = YES;
        CFTimeInterval beatsPerSecond = self.bpm / 60.;
        _secondsPerBeat = 1. / beatsPerSecond;
        _selectorsByListener = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)dealloc {
    [self invalidate];
}

#pragma mark - Display Link

- (void)start {
    if (self.paused) {
        _paused = NO;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.startTime = CACurrentMediaTime();
        self.lastFireTime = CACurrentMediaTime();
        self.nextFireTime = self.lastFireTime + self.secondsPerBeat;
    }
}

- (void)invalidate {
    [self.displayLink invalidate];
}

- (void)tick:(CADisplayLink *)displayLink {
    self.actionAllowed = [self isActiveForTimestamp:displayLink.timestamp];
    BOOL shouldFire = [self shouldFireForTimestamp:displayLink.timestamp];
    if (shouldFire) {
        self.lastFireTime = displayLink.timestamp;
        self.nextFireTime = self.lastFireTime + self.secondsPerBeat;
        for (NSObject *listener in self.selectorsByListener) {
            [[self.selectorsByListener objectForKey:listener] invoke];
        }
    }
//    NSLog(@"displayLink.timestamp = %.4f, last = %.4f, next = %.4f", displayLink.timestamp, self.lastFireTime, self.nextFireTime);
//    NSLog(@"displayLink .timestamp = %f, .duration = %f, active == %d", displayLink.timestamp, displayLink.duration, self.actionAllowed);
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

- (CFTimeInterval)multipleOf {
    return 0;
}

- (BOOL)shouldFireForTimestamp:(CFTimeInterval)timestamp {
    CFTimeInterval timeIntervalSinceLastBeat = timestamp - self.lastFireTime;
    return timeIntervalSinceLastBeat > self.secondsPerBeat;
}

- (BOOL)shouldSendBeatForDisplayLink:(CADisplayLink *)displayLink {
    CFTimeInterval timeIntervalSinceStart = displayLink.timestamp - self.startTime;
    return NO;
}

#pragma mark - Listeners

- (void)addBeatListener:(NSObject *)listener selector:(SEL)selector {
    NSMethodSignature *methodSignature = [listener methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.selector = selector;
    invocation.target = listener;
    [self.selectorsByListener setObject:invocation forKey:listener];
}

- (void)removeBeatListener:(NSObject *)listener {
    [self.selectorsByListener removeObjectForKey:listener];
}

@end

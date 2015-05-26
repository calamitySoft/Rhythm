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
@property CFTimeInterval elapsedTime;
@property CFTimeInterval startTime;
@property CFTimeInterval lastFireTime;
@property CFTimeInterval secondsPerBeat;
@property NSMapTable *selectorsByListener;
@end

@implementation CALMetronome

- (instancetype)initWithBPM:(float)bpm leadingLeniency:(NSTimeInterval)leadingLeniency trailingLeniency:(NSTimeInterval)trailingLeniency {
    self = [super init];
    if (self) {
        _actionAllowed = NO;
        _bpm = bpm;
        _leadingLeniency = leadingLeniency;
        _trailingLeniency = trailingLeniency;
        _elapsedTime = 0;
        _lastFireTime = 0;
        _paused = NO;
        CFTimeInterval beatsPerSecond = self.bpm / 60.;
        _secondsPerBeat = 1. / beatsPerSecond;
        _selectorsByListener = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

#pragma mark - State

- (void)start {
    NSAssert(!self.displayLink, @"%s may only be called once.", __func__);
    if (self.displayLink) {
        return;
    }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.startTime = CACurrentMediaTime();
    self.lastFireTime = CACurrentMediaTime();
}

- (void)setPaused:(BOOL)paused {
    _paused = paused;
    self.displayLink.paused = paused;
}

- (void)stop {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Display Link

- (void)tick:(CADisplayLink *)displayLink {
    CFTimeInterval elapsedSinceLastTick = displayLink.duration * displayLink.frameInterval;
    self.elapsedTime += elapsedSinceLastTick;
    
    BOOL actionAllowed = [self isActionAllowedForElapsedTime:self.elapsedTime];
    if (self.actionAllowed != actionAllowed) {
        self.actionAllowed = actionAllowed;
    }
    
    CFTimeInterval priorBeatTime = [self beatElapsedTimePriorToElapsedTime:self.elapsedTime];
    BOOL shouldBeat = priorBeatTime != self.lastFireTime;
    if (shouldBeat) {
        self.lastFireTime = priorBeatTime;
        for (NSObject *listener in self.selectorsByListener) {
            [[self.selectorsByListener objectForKey:listener] invoke];
        }
    }
    
//    NSLog(@"displayLink.timestamp = %.4f, last = %.4f", displayLink.timestamp, self.lastFireTime);
//    NSLog(@"displayLink .timestamp = %f, .duration = %f, .frameInterval == %ld", displayLink.timestamp, displayLink.duration, (long)displayLink.frameInterval);
}

- (BOOL)isActionAllowedForElapsedTime:(CFTimeInterval)elapsedTime {
    CFTimeInterval priorBeatTime = [self beatElapsedTimePriorToElapsedTime:elapsedTime];
    CFTimeInterval subsequentBeatTime = [self beatElapsedTimeSubsequentToElapsedTime:elapsedTime];
    CFTimeInterval trailingDiff = elapsedTime - priorBeatTime;
    CFTimeInterval leadingDiff = subsequentBeatTime - elapsedTime;
    BOOL trailsWithinLeniency = trailingDiff >= 0 && trailingDiff < self.trailingLeniency;
    BOOL leadsWithinLeniency = leadingDiff >= 0 && leadingDiff < self.leadingLeniency;
    return trailsWithinLeniency || leadsWithinLeniency;
}

- (CFTimeInterval)beatElapsedTimePriorToElapsedTime:(CFTimeInterval)elapsedTime {
    CFTimeInterval elapsedBeats = self.elapsedTime / self.secondsPerBeat;
    CFTimeInterval floorElapsedBeats = floor( elapsedBeats );
    CFTimeInterval fullElapsedBeatSeconds = floorElapsedBeats * self.secondsPerBeat;
    return fullElapsedBeatSeconds;
}

- (CFTimeInterval)beatElapsedTimeSubsequentToElapsedTime:(CFTimeInterval)elapsedTime {
    CFTimeInterval elapsedBeats = self.elapsedTime / self.secondsPerBeat;
    CFTimeInterval ceilElapsedBeats = ceil( elapsedBeats );
    CFTimeInterval fullElapsedBeatSecondsPlus1 = ceilElapsedBeats * self.secondsPerBeat;
    return fullElapsedBeatSecondsPlus1;
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

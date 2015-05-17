//
//  Metronome.m
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "Metronome.h"

@interface Metronome ()
@property (readwrite) BOOL active;
@property NSTimer *timer;
@end

@implementation Metronome

- (instancetype)initWithBPM:(float)bpm leniency:(NSTimeInterval)leniency {
    self = [super init];
    if (self) {
        _active = NO;
        _bpm = bpm;
        _leniency = leniency;
        _timer = [NSTimer timerWithTimeInterval:bpm target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)start {
    if (!self.timer.isValid) {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stop {
    [self.timer invalidate];
}

- (void)tick:(NSTimer *)timer {
    self.active = YES;
    [self performSelector:@selector(setActive:) withObject:@(NO) afterDelay:self.leniency];
}

@end

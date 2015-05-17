//
//  Metronome.h
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metronome : NSObject

@property (readonly) BOOL active; // KVO this
@property (readonly) float bpm;
@property (readonly) NSTimeInterval leniency; // length of time from a beat that active == YES

- (instancetype)initWithBPM:(float)bpm leniency:(NSTimeInterval)leniency NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)stop;

@end

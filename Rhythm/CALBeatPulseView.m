//
//  CALBeatPulseView.m
//  Rhythm
//
//  Created by Logan Moseley on 5/26/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "CALBeatPulseView.h"

extern const struct CALBeatPulseStyleFunctions {
    UIColor *(*fillColorFromBeatRelationship)(CALMetronomeBeatRelationship beatRelationship);
    UIColor *(*strokeColorFromBeatRelationship)(CALMetronomeBeatRelationship beatRelationship);
    CGFloat  (*strokeWidthFromBeatRelationship)(CALMetronomeBeatRelationship beatRelationship);
} CALBeatPulseStyle;

@implementation CALBeatPulseView

@synthesize beatRelationship = _beatRelationship;

- (CALMetronomeBeatRelationship)beatRelationship {
    return _beatRelationship;
}

- (void)setBeatRelationship:(CALMetronomeBeatRelationship)beatRelationship {
    _beatRelationship = beatRelationship;
    self.backgroundColor = CALBeatPulseStyle.fillColorFromBeatRelationship(beatRelationship);
    self.layer.borderColor = CALBeatPulseStyle.strokeColorFromBeatRelationship(beatRelationship).CGColor;
    self.layer.borderWidth = CALBeatPulseStyle.strokeWidthFromBeatRelationship(beatRelationship);
}

@end

static UIColor *fillColorFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
            return [UIColor blueColor];
        case CALMetronomeBeatRelationshipOn:
            return [UIColor yellowColor];
        case CALMetronomeBeatRelationshipTrailing:
            return [UIColor magentaColor];
        case CALMetronomeBeatRelationshipOff:
            return nil;
    }
    return [UIColor blackColor];
}

static UIColor *strokeColorFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
        case CALMetronomeBeatRelationshipOn:
        case CALMetronomeBeatRelationshipTrailing:
            return [UIColor greenColor];
        case CALMetronomeBeatRelationshipOff:
            return [UIColor redColor];
    }
    return [UIColor blackColor];
}

static CGFloat strokeWidthFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
        case CALMetronomeBeatRelationshipOn:
        case CALMetronomeBeatRelationshipTrailing:
        case CALMetronomeBeatRelationshipOff:
            return 3;
    }
    return 3;
}

const struct CALBeatPulseStyleFunctions CALBeatPulseStyle = {
    .fillColorFromBeatRelationship = fillColorFromBeatRelationship,
    .strokeColorFromBeatRelationship = strokeColorFromBeatRelationship,
    .strokeWidthFromBeatRelationship = strokeWidthFromBeatRelationship
};

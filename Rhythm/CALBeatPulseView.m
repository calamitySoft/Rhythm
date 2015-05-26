//
//  CALBeatPulseView.m
//  Rhythm
//
//  Created by Logan Moseley on 5/26/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "CALBeatPulseView.h"

static UIColor *pulseFillColorFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
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

static UIColor *pulseStrokeColorFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
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

static CGFloat pulseStrokeWidthFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
        case CALMetronomeBeatRelationshipOn:
        case CALMetronomeBeatRelationshipTrailing:
        case CALMetronomeBeatRelationshipOff:
            return 3;
    }
    return 3;
}

@implementation CALBeatPulseView

@synthesize beatRelationship = _beatRelationship;

- (CALMetronomeBeatRelationship)beatRelationship {
    return _beatRelationship;
}

- (void)setBeatRelationship:(CALMetronomeBeatRelationship)beatRelationship {
    _beatRelationship = beatRelationship;
    self.backgroundColor = pulseFillColorFromBeatRelationship(beatRelationship);
    self.layer.borderColor = pulseStrokeColorFromBeatRelationship(beatRelationship).CGColor;
    self.layer.borderWidth = pulseStrokeWidthFromBeatRelationship(beatRelationship);

}

@end

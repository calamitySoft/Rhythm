//
//  CALMetronomeBeatRelationship.m
//  Rhythm
//
//  Created by Logan Moseley on 5/25/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "CALMetronomeBeatRelationship.h"

inline BOOL CALActionAllowedFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
        case CALMetronomeBeatRelationshipOn:
        case CALMetronomeBeatRelationshipTrailing:
            return YES;
        case CALMetronomeBeatRelationshipOff:
            return NO;
    }
    return NO;
}

inline NSString *NSStringFromCALMetronomeBeatRelationship(CALMetronomeBeatRelationship beatRelationship) {
    switch (beatRelationship) {
        case CALMetronomeBeatRelationshipLeading:
            return @"leading";
        case CALMetronomeBeatRelationshipOn:
            return @"on";
        case CALMetronomeBeatRelationshipTrailing:
            return @"trailing";
        case CALMetronomeBeatRelationshipOff:
            return @"off";
    }
    return @"unknown";
}

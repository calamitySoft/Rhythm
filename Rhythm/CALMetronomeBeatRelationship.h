//
//  CALMetronomeBeatRelationship.m
//  Rhythm
//
//  Created by Logan Moseley on 5/25/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, CALMetronomeBeatRelationship) {
    CALMetronomeBeatRelationshipLeading     = -1,
    CALMetronomeBeatRelationshipOn          = 0,
    CALMetronomeBeatRelationshipTrailing    = 1,
    CALMetronomeBeatRelationshipOff         = NSIntegerMax,
};

extern BOOL CALActionAllowedFromBeatRelationship(CALMetronomeBeatRelationship beatRelationship);

extern NSString *NSStringFromCALMetronomeBeatRelationship(CALMetronomeBeatRelationship beatRelationship);

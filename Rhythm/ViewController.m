//
//  ViewController.m
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "ViewController.h"

const UIViewAutoresizing UIViewAutoresizingCenterHorizontally = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
const UIViewAutoresizing UIViewAutoresizingCenterVertically = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
const UIViewAutoresizing UIViewAutoresizingResize = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

@interface ViewController ()
@property IBOutlet UILabel *attackLabel; // scissors
@property IBOutlet UILabel *blockLabel;  // rock
@property IBOutlet UILabel *throwLabel;  // paper
@property IBOutlet UIView *pulseView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pulseView.layer.cornerRadius = CGRectGetWidth(self.pulseView.frame) / 2;
}

- (void)attack {
    
}

- (void)block {
    
}

- (void)throw {
    
}

@end

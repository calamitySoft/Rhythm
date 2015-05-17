//
//  ViewController.m
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property IBOutlet UILabel *attackLabel; // scissors
@property IBOutlet UILabel *blockLabel;  // rock
@property IBOutlet UILabel *throwLabel;  // paper
@property IBOutlet UIView *pulseView;
@end

@implementation ViewController

+ (UIColor *)highlightColor {
    return [UIColor colorWithRed:(54/255.) green:(109/255.) blue:(191/255.) alpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pulseView.layer.cornerRadius = CGRectGetWidth(self.pulseView.frame) / 2;
}

#pragma mark - Actions

- (void)attack {
    self.attackLabel.backgroundColor = [[self class] highlightColor];
    [self.attackLabel performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.25];
}

- (void)block {
    self.blockLabel.backgroundColor = [[self class] highlightColor];
    [self.blockLabel performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.25];
}

- (void)throw {
    self.throwLabel.backgroundColor = [[self class] highlightColor];
    [self.throwLabel performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.25];
}

#pragma mark - Gestures

- (IBAction)gestureRecognizerDidSwipeUp:(UISwipeGestureRecognizer *)recognizer {
    [self attack];
}

- (IBAction)gestureRecognizerDidSwipeDown:(UISwipeGestureRecognizer *)recognizer {
    [self block];
}

- (IBAction)gestureRecognizerDidSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self throw];
}

- (IBAction)gestureRecognizerDidSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"%s", __func__);
}

@end

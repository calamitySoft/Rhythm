//
//  ViewController.m
//  Rhythm
//
//  Created by Logan Moseley on 5/17/15.
//  Copyright (c) 2015 CalamitySoft. All rights reserved.
//

#import "ViewController.h"
#import "Metronome.h"
@import AVFoundation;

@interface ViewController () <UIGestureRecognizerDelegate>
@property IBOutlet UILabel *attackLabel; // scissors
@property IBOutlet UILabel *blockLabel;  // rock
@property IBOutlet UILabel *throwLabel;  // paper
@property IBOutlet UIView *pulseView;
@property AVAudioPlayer *clickAudioPlayer;
@property Metronome *metronome;
@end

@implementation ViewController

+ (UIColor *)highlightColor {
    return [UIColor colorWithRed:(54/255.) green:(109/255.) blue:(191/255.) alpha:1];
}

+ (AVAudioPlayer *)clickAudioPlayer {
    NSURL *clickURL = [[NSBundle mainBundle] URLForResource:@"Click1" withExtension:@"wav"];
    return [[AVAudioPlayer alloc] initWithContentsOfURL:clickURL fileTypeHint:AVFileTypeWAVE error:nil];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pulseView.backgroundColor = [UIColor clearColor];
    self.pulseView.layer.cornerRadius = CGRectGetWidth(self.pulseView.frame) / 2;
    self.clickAudioPlayer = [[self class] clickAudioPlayer];
    [self.clickAudioPlayer prepareToPlay];
    self.metronome = [[Metronome alloc] initWithBPM:60 leniency:0.2];
    [self.metronome addObserver:self forKeyPath:NSStringFromSelector(@selector(active)) options:NSKeyValueObservingOptionNew context:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.metronome start];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    BOOL active = [change[NSKeyValueChangeNewKey] boolValue];
    self.pulseView.backgroundColor = active ? [[self class] highlightColor] : nil;
    [self.clickAudioPlayer play];
}

#pragma mark - Click

- (void)click:(NSTimer *)timer {
    [self.clickAudioPlayer play];
    self.pulseView.backgroundColor = [[self class] highlightColor];
    [self.pulseView performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.1];
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

//
//  IBCAppDelegate.h
//  IB Calisthenics
//
//  Created by Brian Alonso on 10/3/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <math.h>

@interface IBCAppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate>
{
    NSArray *voices;
    NSSpeechSynthesizer *_speechSynth;
    NSString *selectedVoice;
}

@property (assign) IBOutlet NSWindow *window;

// Actions
- (IBAction)printHello:(id)sender;
- (IBAction)printGoodbye:(id)sender;
- (IBAction)copyText:(id)sender;
- (IBAction)printTime:(id)sender;
- (IBAction)segControlClicked:(id)sender;
- (IBAction)radioSeasonsClicked:(id)sender;
- (IBAction)sliderMoved:(id)sender;
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;
- (IBAction)sliderSpeedMoved:(id)sender;
- (IBAction)segVoicesClicked:(id)sender;

// Outlets and accessors
@property (weak) IBOutlet NSTextField *textInput;
@property (weak) IBOutlet NSTextField *labelOutput;
@property (weak) IBOutlet NSTextField *labelTime;
@property (weak) IBOutlet NSTextField *segLabelOutput;
@property (weak) IBOutlet NSSegmentedControl *segControl;
@property (weak) IBOutlet NSTextField *labelSeasons;
@property (weak) IBOutlet NSTextField *labelSlider;
@property (weak) IBOutlet NSSlider *sliderSquared;
@property (weak) IBOutlet NSTextField *labelSliderLongValue;
@property (weak) IBOutlet NSTextField *textToSpeak;
@property (weak) IBOutlet NSButton *buttonSpeak;
@property (weak) IBOutlet NSButton *buttonHush;
@property (weak) IBOutlet NSSegmentedControl *segVoices;
@property (weak) IBOutlet NSSlider *sliderSpeed;
@property (weak) IBOutlet NSTextField *labelSpeed;
@end

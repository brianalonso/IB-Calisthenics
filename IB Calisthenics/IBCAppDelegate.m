//
//  IBCAppDelegate.m
//  IB Calisthenics
//
//  Created by Brian Alonso on 10/3/12.
//  Copyright (c) 2012 Brian Alonso. All rights reserved.
//

#import "IBCAppDelegate.h"

//
// Constants
//
NSString *CONST_DefaultWindowTextString = @"Welcome to Cocoa Speech Synthesis Example.	This application provides an example of using Apple's speech synthesis technology in a Cocoa-based application.";
NSString *CONST_HelloWorld = @"Hello world !";
NSString *CONST_Goodbye = @"Goodbye !";
NSString *CONST_TextWarning = @"Please enter text to copy";

#define DEFAULT_SPEED 150

// Implementation
@implementation IBCAppDelegate

- (id)init
{
    self = [super init];
    if (self)   {
        // Create an instance of the Speech synthesizer
        // Create a new instance of NSSpeechSynthesizer
        // with the default voice.
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        
        [_speechSynth setDelegate:self];
        
        // Get the array of available voices
        voices = [NSSpeechSynthesizer availableVoices];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Seed the random number generator with the time
    // for selection of unique voice name
	srandom((unsigned)time(NULL));
    
    // Set the application default values
    [[self labelSeasons] setStringValue:@"December"];
    
    // Set the label value with the segmented control string
    [[self segLabelOutput] setStringValue:@"0:Zero"];
    
    // Setup the slider defaults
    [[self sliderSquared] setIntegerValue:1];
    [[self labelSlider] setStringValue:@"1"];
    [[self labelSliderLongValue] setStringValue:@"one"];
    
    // Set the buttons to enabled/disabled
    [[self buttonHush] setEnabled:NO];
    [[self buttonSpeak] setEnabled:YES];
    
    // Initialize a speech synthesizer's Pre-populate text to speak and speed
    [[self textToSpeak] setStringValue:CONST_DefaultWindowTextString];
    [[self labelSpeed] setStringValue:[[self sliderSpeed] stringValue]];
    [[self sliderSpeed] setFloatValue:DEFAULT_SPEED];
    
    // Setup the segmented button with 4 voices
    [[self segVoices] setSegmentCount:4];
    
    // Load up to 4 random voices into the segmented control
    for (int n=0; n<=fmin([voices count],3); ++n)
    {
        // Make all of the segment widths equal to the first segment width to display the voice names
        if (n > 0) {
            [[self segVoices] setWidth:[[self segVoices] widthForSegment:0] forSegment:n];
        }
       
        int generated;
        BOOL bFound;
        NSString *tempVoice;
        
        // Loop until an unused voice is found
        do
        {
            // Using the random number generator, generate an index
            // into the voices array from 0 to [voices count]
            generated = (int)(random() % [voices count]);
            NSLog(@"generated = %d", generated);
        
            tempVoice = [self stripVoiceName:[voices objectAtIndex:generated]];
        
            bFound = [self findVoice:tempVoice];
        } while (bFound == YES);
        
        // Set the segment label with the voice name and the tag with the voice index
        [[self segVoices] setLabel:tempVoice forSegment:n];
        [[self segVoices] setTag:generated];
        NSLog(@"Tag for voice: %li", [[self segVoices] tag]);
    }
    [[self segVoices] setSelected:YES forSegment:0];    // Select the first voice/segment
}

// Helper routine: Check if passed voice name is listed as a segment in the segmented button control
- (BOOL) findVoice:(NSString *)voice
{
    BOOL bVoice = NO;
    
    // Make sure we haven't already used this voice
    for (int i=0; i<=3; ++i)
    {
        // Does a label already exist for the passed voice ?
        NSString *vc = [[self segVoices] labelForSegment:i];
        if (voice == vc) {
            bVoice = YES;
            break;
        }
    }
    return bVoice;
}

#pragma mark -
#pragma mark Helper Routines

// Helper Routine: Strip the synthesize voice text down to the name
- (NSString *)stripVoiceName:(NSString *)strVoice
{
    NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:strVoice];
	return [dict objectForKey:NSVoiceName];
}

// Helper Routine: Clear the text in the input text area
- (void)clearInput
{
    // Clear the copy textbox
    [[self textInput] setStringValue:@""];
}

// Helper Routine: Set the passed text in the output label
- (void)storeLabelText:(NSString *)strLabelText
{
    [[self labelOutput] setStringValue:strLabelText];
}

// Helper Routine: Speak the passed text
- (void)speakText:(NSString *)strLabelText
{
    // Retrieve the short voice name from the segmented label
    selectedVoice = [[self segVoices] labelForSegment:[[self segVoices] selectedSegment]];
    
    // Convert to a long voice name for the synthesizer
    NSString *longVoiceName = [NSString stringWithFormat:@"com.apple.speech.synthesis.voice.%@",selectedVoice];
    
    // Set the voice based on the selected segment button
    [_speechSynth setVoice:longVoiceName];
	NSLog(@"Current voice = %@", selectedVoice);
    
    [_speechSynth setRate:[[self sliderSpeed] floatValue]];
    
    [[self buttonHush] setEnabled:YES];
    [[self buttonSpeak] setEnabled:NO];
    
    // say it
    [_speechSynth startSpeakingString:strLabelText];
}

// Helper Routine: Update the voice rate based upon slider value
- (void)updateVoiceRate:(NSSlider *)voiceSpeed
{
    [_speechSynth setRate:[voiceSpeed floatValue]];
    NSLog(@"New voice rate = %f", [voiceSpeed floatValue]);
    [[self labelSpeed] setStringValue:[voiceSpeed stringValue]];

}

#pragma mark -
#pragma mark Hello_Goodbye_Copy

// Respond to the Hello button click
- (IBAction)printHello:(id)sender {
    // Print Hello to output label
    [self storeLabelText:CONST_HelloWorld];
    
    // Speak it
    //[self speakText:[[self labelOutput] stringValue]];
    
    // Clear the copy textbox
    [self clearInput];
}

// Respond to the Goodbye button click
- (IBAction)printGoodbye:(id)sender {
    // Print Hello to output label
    [self storeLabelText:CONST_Goodbye];
    
    // Speak it
    //[self speakText:[[self labelOutput] stringValue]];
        
    // Clear the copy textbox
    [self clearInput];
}

// Respond to the Copy button click by setting the output label with
// the value in the text box
- (IBAction)copyText:(id)sender {
    // copy text box text label
    if ([[[self textInput] stringValue] length] > 0) {
        [self storeLabelText:[[self textInput] stringValue]];
    }
    else
    {
        // Use a standard alert to display a friendly message
        NSRunAlertPanel(@"Warning", CONST_TextWarning, @"OK", NULL, NULL);
    }
}

#pragma mark -
#pragma mark Section2

// Respond to the segmented control click
- (IBAction)segControlClicked:(NSSegmentedControl*)sender {
    
    // Get the segmented controls segment number and label
    NSString *strTemp = [NSString stringWithFormat:@"%li:%@",[sender selectedSegment],[sender labelForSegment:[sender selectedSegment]]];
    
    // Set the label value with the segmented control string
    [[self segLabelOutput] setStringValue:strTemp];
}

- (IBAction)radioSeasonsClicked:(id)sender {
    // User clicked a radio button
    NSCell *radioCell = [sender selectedCell];
    switch ([radioCell tag]) {
        case 0: // Winter
            [[self labelSeasons] setStringValue:@"December"];
            break;
            
        case 1: // Spring
            [[self labelSeasons] setStringValue:@"March"];
            break;
            
        case 2: // Summer
            [[self labelSeasons] setStringValue:@"June"];
            break;
            
        case 3: // Fall
            [[self labelSeasons] setStringValue:@"September"];
            break;
            
        default:
            [[self labelSeasons] setStringValue:@""];
            break;
    }
}


#pragma mark -
#pragma mark Section3

// Respond to the click of the Now button to display formatted date/time
- (IBAction)printTime:(id)sender {
    [[self labelTime] setObjectValue:[NSDate date]];
}


#pragma mark -
#pragma mark Section4

// Respond to the slider move
- (IBAction)sliderMoved:(id)sender {
    // Convert the value to a float
    float sliderFloat = [[self sliderSquared] floatValue];
    
    [[self labelSlider] setFloatValue:sliderFloat];
    [[self labelSliderLongValue] setFloatValue:sliderFloat*sliderFloat];
}

// Respond to the button click to Start speaking
- (IBAction)sayIt:(id)sender {
    NSString *string = [[self textToSpeak] stringValue];
    
    // Is the string zero-length?
    if ([string length] == 0)
    {
        // Use a standard alert to display a friendly message
        NSRunAlertPanel(@"Warning", CONST_TextWarning, @"OK", NULL, NULL);
		return;
    }
    // Speak it
    [self speakText:[[self textToSpeak] stringValue]];
}

// Respond to the button click to Stop speaking
- (IBAction)stopIt:(id)sender {
    [_speechSynth stopSpeaking];
    [[self buttonHush] setEnabled:NO];
    [[self buttonSpeak] setEnabled:YES];
}

// The Slider for the speech rate was moved
- (IBAction)sliderSpeedMoved:(NSSlider *)sender {
    // Call the helper procedure to set the speech synth voice rate
    [self updateVoiceRate:sender];
}

// The user selected a voice from the segmented control
- (IBAction)segVoicesClicked:(id)sender {
    
    // reset the speed to the default
    [[self sliderSpeed] setFloatValue:DEFAULT_SPEED];
    
    // Retrieve the short voice name from the segmented label
    selectedVoice = [sender labelForSegment:[sender selectedSegment]];
    NSLog(@"New voice selected = %@", selectedVoice);
}

// Delegate:  Speech synthesizer stopped speaking
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender
		didFinishSpeaking:(BOOL)finishedSpeaking
{
	NSLog(@"finishedSpeaking = %d", finishedSpeaking);
    [[self buttonHush] setEnabled:NO];
    [[self buttonSpeak] setEnabled:YES];
}

// Delegate:  Speech synthesizer will speak a word
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender willSpeakWord:(NSRange)characterRange ofString:(NSString *)string
{
    // Check the rate and voice and change if necessary
    if ([_speechSynth rate] != [[self sliderSpeed] floatValue])
    {
        // Call the helper procedure to set the speech synth voice rate
        [self updateVoiceRate:[self sliderSpeed]];
    }
    
    // Check the selected voice and change if necessary
    // Changing the voice will restart speaking from the beginning
    // Retrieve the short voice name from the segmented label
    selectedVoice = [[self segVoices] labelForSegment:[[self segVoices] selectedSegment]];
    // Convert to a long voice name for the synthesizer
    NSString *longVoiceName = [NSString stringWithFormat:@"com.apple.speech.synthesis.voice.%@",selectedVoice];
   
    if ([longVoiceName isEqualToString:[_speechSynth voice]])
    {
        // do nothing; voice has not changed
    } else
    {
        // New voice will be set in the helper routine
        // User must click speak to restart
        [self stopIt:self];
    }
}
@end

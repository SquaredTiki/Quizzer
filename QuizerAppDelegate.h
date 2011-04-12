//
//  QuizerAppDelegate.h
//  Quizer
//
//  Created by Joshua Garnham on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QuizerAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
    NSWindow *window;
	
	NSMutableArray *questionsAndAnswers;
	NSTimer *timer;
	
	IBOutlet NSTextField *score;
	IBOutlet NSTextField *question;
	IBOutlet NSTextField *overallScore;
	IBOutlet NSButton *answer1;
	IBOutlet NSButton *answer2;
	IBOutlet NSButton *answer3;
	IBOutlet NSButton *restartButton;
	
	int currentQuestion; // Begins with 0 
	
	/* ------------------------------------- */
	
	IBOutlet NSWindow *answersWindow;
	IBOutlet NSTableView *answersTable;
	
	NSMutableArray *resultsArray;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)checkAnswer:(id)sender;
- (IBAction)restart:(id)sender;

- (void)proceedToNextQuestionWithAdditionOfScore:(BOOL)addScore;

@end

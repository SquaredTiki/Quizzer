//
//  QuizerAppDelegate.m
//  Quizer
//
//  Created by Joshua Garnham on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuizerAppDelegate.h"

@implementation QuizerAppDelegate

@synthesize window;

- (void)loadQuestionsAndAnswersArray {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Quiz1" ofType:@"txt"];  
	NSString *textFileString = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:NULL];  
	
	NSArray *seperatedQA = [textFileString componentsSeparatedByString:@"\n\n"];
	
	for (NSString *QA in seperatedQA) {		
		NSString *questionString = [[[QA componentsSeparatedByString:@"\n"] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"Q:" withString:@""];
		
		NSMutableArray *answers = [[QA componentsSeparatedByString:@"A:"] mutableCopy];
		[answers removeObjectAtIndex:0];
				
		int correctAnswerLoc;
		
		for (int i = 0; i < answers.count; i++) {
			NSString *answer = [answers objectAtIndex:i];
			NSString *editedAnswer = [answer stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			editedAnswer = [editedAnswer stringByTrimmingCharactersInSet:
							[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[answers removeObjectAtIndex:i];
			[answers insertObject:editedAnswer atIndex:i];	
			answer = editedAnswer;
			if ([answer rangeOfString:@"[CORRECT]"].location != NSNotFound) {
				correctAnswerLoc = [answers indexOfObject:answer];
				NSString *editedAnswer = [answer stringByReplacingOccurrencesOfString:@"[CORRECT]" withString:@""];
				[answers removeObjectAtIndex:i];
				[answers insertObject:editedAnswer atIndex:i];
			}
		}
		
		NSLog(@"answers = %@", answers);
		
		NSDictionary *QADictionary = [NSDictionary dictionaryWithObjectsAndKeys:questionString, @"question", answers, @"answers", [NSNumber numberWithInt:correctAnswerLoc], @"correctAnswerLocation", nil];
		
		[questionsAndAnswers addObject:QADictionary]; 
	}	
	
	resultsArray = [[NSMutableArray alloc] initWithCapacity:[questionsAndAnswers count]];
}

- (void)loadQuestionsAndAnswersIntoInterface {
	NSDictionary *QADictionary = [questionsAndAnswers objectAtIndex:currentQuestion];		
	
	[question setStringValue:[QADictionary valueForKey:@"question"]];
	[answer1 setTitle:[[QADictionary valueForKey:@"answers"] objectAtIndex:0]];
	[answer2 setTitle:[[QADictionary valueForKey:@"answers"] objectAtIndex:1]];
	[answer3 setTitle:[[QADictionary valueForKey:@"answers"] objectAtIndex:2]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	questionsAndAnswers = [[[NSMutableArray alloc] init] retain];
	currentQuestion = 0;
	
	[self loadQuestionsAndAnswersArray];
	[self loadQuestionsAndAnswersIntoInterface];
		
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.001
									 target:self
								   selector:@selector(decreaseScore:)
								   userInfo:nil
									repeats:YES] retain];
}

#pragma mark Restarting

- (IBAction)restart:(id)sender {
	currentQuestion = 0;
	[self loadQuestionsAndAnswersIntoInterface];
	[restartButton setHidden:YES];
	[question setEnabled:YES];
	[answer1 setEnabled:YES];
	[answer2 setEnabled:YES];
	[answer3 setEnabled:YES];
	[score setEnabled:YES];
	[self resetTimer];
	[overallScore setStringValue:@"0"];
	[resultsArray removeAllObjects];
	[answersTable reloadData];
}

#pragma mark Timer Control

- (void)stopTimer {
	[timer invalidate];
	timer = nil;
}

- (void)resetTimer {
	[score setStringValue:@"10000"];
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.001
											  target:self
											selector:@selector(decreaseScore:)
											userInfo:nil
											 repeats:YES] retain];
}

- (void)decreaseScore:(NSTimer *)aTimer {	
	NSString *scoreString = [score stringValue];
	int scoreInt = [scoreString intValue];
		
	int newScoreInt = scoreInt - 1;
		
	if (newScoreInt == 0) {
		[self proceedToNextQuestionWithAdditionOfScore:NO];
		return;
	}
	
	NSString *newScoreString = [NSString stringWithFormat:@"%i", newScoreInt];
	
	[score setStringValue:newScoreString];
}

#pragma mark Answer Check

- (void)proceedToNextQuestionWithAdditionOfScore:(BOOL)addScore {
	if (addScore) {
		[resultsArray addObject:[NSNumber numberWithBool:YES]];
		[answersTable reloadData];
		[self stopTimer];
		
		int scoreInt = [[score stringValue] intValue];
		int overallScoreInt = [[overallScore stringValue] intValue];
		
		int newOverallScoreInt = overallScoreInt + scoreInt;
		
		[overallScore setStringValue:[NSString stringWithFormat:@"%i", newOverallScoreInt]];
		
		if (currentQuestion + 1 == [questionsAndAnswers count]) {
			[question setEnabled:NO];
			[answer1 setEnabled:NO];
			[answer2 setEnabled:NO];
			[answer3 setEnabled:NO];
			[score setEnabled:NO];
			[restartButton setHidden:NO];
			return;
		}
		
		[self resetTimer];
		currentQuestion++;
		[self loadQuestionsAndAnswersIntoInterface];
	} else {
		[resultsArray addObject:[NSNumber numberWithBool:NO]];
		[answersTable reloadData];
		[self stopTimer];
				
		if (currentQuestion + 1 == [questionsAndAnswers count]) {
			[question setEnabled:NO];
			[answer1 setEnabled:NO];
			[answer2 setEnabled:NO];
			[answer3 setEnabled:NO];
			[score setEnabled:NO];
			[restartButton setHidden:NO];
			return;
		}
		
		[self resetTimer];
		currentQuestion++;
		[self loadQuestionsAndAnswersIntoInterface];
	}
}

- (IBAction)checkAnswer:(id)sender {
	int buttonNumber;
	
	if (sender == answer1)
		buttonNumber = 0;
	else if (sender == answer2)
		buttonNumber = 1;
	else if (sender == answer3)
		buttonNumber = 2;
		
	NSDictionary *currentQuestionDictionary = [questionsAndAnswers objectAtIndex:currentQuestion];
		
	int correctAnswer = [[currentQuestionDictionary valueForKey:@"correctAnswerLocation"] intValue];
	
	if (buttonNumber == correctAnswer) {
		[self proceedToNextQuestionWithAdditionOfScore:YES];
	} else {
		[self proceedToNextQuestionWithAdditionOfScore:NO];
	}
}

#pragma mark Table View Datasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [resultsArray count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[[aTableColumn headerCell] stringValue] isEqualToString:@"Question"]) {
		return [[questionsAndAnswers objectAtIndex:rowIndex] valueForKey:@"question"];
	} else {
		NSMutableAttributedString *result;
		if ([[resultsArray objectAtIndex:rowIndex] boolValue] == YES) {
			result = [[NSMutableAttributedString alloc] initWithString:@"Correct"];
			[result addAttribute:(NSString *)NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(0, [[result string] length])];
		} else {
			result = [[NSMutableAttributedString alloc] initWithString:@"In-Correct"];
			[result addAttribute:(NSString *)NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, [[result string] length])];		
		}
		return result;
	}
	return @"ERROR";
}

@end

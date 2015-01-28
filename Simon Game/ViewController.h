//
//  ViewController.h
//  Simon Game
//
//  Created by Patt on 2013-09-30.
//  Copyright (c) 2013 Patt. All rights reserved.
//
//Note to self: button order: RED, GREEN, YELLOW, BLUE
//                              0,     1,      2,    3

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    //boolean that lets us know if the solution is being shown
    BOOL inProgress;
    
    //Images used for the buttons (not the highlighted images)
    UIImageView *redButton;
    UIImageView *greenButton;
    UIImageView *yellowButton;
    UIImageView *blueButton;
    
    
    //Mutable array to keep track of the sequence.
    NSMutableArray *solutionArray;
    
    int count;
    int health;
    int scoreInt;
 
    //labels that are displayed on the storyboard.
    //Note: testingLabel is used to show the solution when debugging. This can be enabled by uncommenting it in the .m file
    __weak IBOutlet UILabel *testingLabel;
    
    __weak IBOutlet UILabel *scoreLabel;
    
    __weak IBOutlet UILabel *healthLabel;
    
    __weak IBOutlet UILabel *messageLabel;
}

//methods for playing the game
-(void) buttons;
-(void) addNewToArray;
-(void) replaySolution;
-(void) checkForContinue;
-(void) highlight:(int) button;
-(void) gameOver:(NSString*) alerted;
-(void) roundComplete;
-(void) roundFail;

//pause button
- (IBAction)pause:(id)sender;


@end

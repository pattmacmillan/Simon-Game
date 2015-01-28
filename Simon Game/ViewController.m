//
//  ViewController.m
//  Simon Game
//
//  Created by Patt on 2013-10-03.
//  Copyright (c) 2013 Patt. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //loading our graphics...
    [self buttons];
    
    //set our boolean flag that checks if the app is showing the sequence to false (no)
    inProgress = NO;
    
    solutionArray = [[NSMutableArray alloc] initWithCapacity: 20];
    
    health = 3;
    
    scoreInt = 0;
    
    //RNG
    //srandom(time(NULL));
    
    //add a number (colour) to the mutable arrayz
    [self addNewToArray];
    
    //play
    [self replaySolution];
    
    //check to see if we need to continue
    //[self checkForContinue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//this method adds a new button to the array
-(void) addNewToArray {
    
    //testingLabel.text = @"add to new array";
    
    
    //selects a random button (0-3 inclusive)
    int r = arc4random_uniform(4);
    
    //takes the button selected above and adds it to the array (solutionArray)
    [solutionArray addObject:[NSNumber numberWithInt:r]];
    
     //Taking out the below comment markers will display the array on screen.
    //NSString *string = [solutionArray componentsJoinedByString:@" "];
    //testingLabel.text = string;
    
}

-(void) replaySolution {
    
    //testingLabel.text = @"replay sol";
    
    messageLabel.text = @"Watch Closely!";
    
    //refresh the count
    count = 0;
    
    //solution is going to be shown so set to true
    inProgress = YES;
    
    //start showing the solution
    [self highlight:[(NSNumber*)[solutionArray objectAtIndex:count] intValue]];
    
    
}

//checks to see if the solution is still playing
-(void) checkForContinue{
    
    //testingLabel.text = @"check for cont";
    
    if(inProgress)
    {
        //checks to see if when we increase the count if there's still more of the solution to play
        if([solutionArray count] > ++count)
        {
            
            [self highlight:[(NSNumber*)[solutionArray objectAtIndex:count] intValue]];
        }
        
        //if there's no more to the solution, we set our inProgress boolean to false and reset the count
        else
        {
            inProgress = NO;
            count = 0;
        }
    }
}

//this method handles the interactions with the four buttons (player's input)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    int retrieveSolution;
    
    //check to see if the solution is playing or if the player has inputted enough of a sequence
    if(count < [solutionArray count] && !inProgress)
    {
        //set a variable that will represent an interaction (touch)
        UITouch* pressed = [touches anyObject];
        
        //check to see if a UIImageView element was interacted with (aka the buttons)
        if([pressed.view class] == [UIImageView class])
        {
            
            
            UIImageView *buttonPressed = (UIImageView*) pressed.view;
            
            //call the highlight method to highlight the appropriate button
            [self highlight:buttonPressed.tag];
            
            //check to see if the button pressed by the user is the correct button at that index of the solution array.
            retrieveSolution = [(NSNumber*)[solutionArray objectAtIndex:count] intValue];
            
            //check to see if the button pressed was the right one
            if(retrieveSolution == buttonPressed.tag)
            {
                messageLabel.text = @"Great!";
                //increase the count
                count++;
                
                //[self scoreLabel setText:[NSString stringWithFormat:@"%d", scoreInt]];
                //check to see if the player is done inputting (aka they reached the end)
                if(count == [solutionArray count])
                {
                    
                    //player has completed this round, wait a second and a half before continuing
                    [self performSelector:@selector(roundComplete) withObject:nil afterDelay:1.5];
                     
                    
                }
                
            }
            
            //if button was wrong one...
            else
            {
                messageLabel.text = @"Wrong!";
                //check to see if they have remaining lives
                if(health > 0)
                {
                    [self performSelector:@selector(roundFail) withObject:nil afterDelay:1.5];
                }
                
                else
                {
                    
                    //game is over!
                    [self gameOver:@"No more remaining lives, Game Over!"];
                }
                
                
                //[self gameOver:@"No more remaining lives, Game Over!"];
                
            }
            
            
        }
        
    }
}

//This method starts the next round by adding a new button to the solution, this is called when the user beats the previous round
-(void) roundComplete {
    
    //increase the score
    scoreInt++;
    
    //create string
    NSString *convertInt;
    
    //convert int to string
    convertInt = [NSString stringWithFormat:@"%d", scoreInt];
    
    //display new score
    scoreLabel.text = convertInt;
    
    //add new button...
    [self addNewToArray];
    
    //and play the new solution
    [self replaySolution];
}

//same as above method except no new button is added and the score is not increased. this is for when a user fails the previous round
-(void) roundFail {
    //decrease health
    health--;
    
    //create string
    NSString *convertInt;
    
    //convert int to string
    convertInt = [NSString stringWithFormat:@"%d", health];
    
    //display new score
    healthLabel.text = convertInt;
    
    //play the new solution
    [self replaySolution];
}

//this action allows us to 'pause' the game. Pausing the game only affects user interaction. The reason this is set up as such is that if a user was to pause the game during the sequence animation, they would most likely forget the sequence pre pause.
- (IBAction)pause:(id)sender {
    
    UIButton *pauseButton = (UIButton *)sender;
    NSString *state = pauseButton.titleLabel.text;
    
    //check to see the state of our button
    if([state isEqualToString:@"Pause"])
    {
        //disable buttons when paused
        redButton.userInteractionEnabled = NO;
        greenButton.userInteractionEnabled = NO;
        yellowButton.userInteractionEnabled = NO;
        blueButton.userInteractionEnabled = NO;
        
        //change state of button
        [pauseButton setTitle:@"Resume" forState:(UIControlStateNormal)];
        
    }
    
    else if([state isEqualToString:@"Resume"])
    {
        //enable buttons when paused
        redButton.userInteractionEnabled = YES;
        greenButton.userInteractionEnabled = YES;
        yellowButton.userInteractionEnabled = YES;
        blueButton.userInteractionEnabled = YES;
        
        //change state of button
        [pauseButton setTitle:@"Pause" forState:(UIControlStateNormal)];
    }
}

//this method is called when the user runs out of health/lives
-(void) gameOver:(NSString *)alerted {
    
    //set up a popup alert for when the game ends
    UIAlertView *gameOver = [[UIAlertView alloc] initWithTitle:@"Out of Lives!" message: alerted delegate: self cancelButtonTitle:@"Try Again!" otherButtonTitles: nil];
    
    //display popup
    [gameOver show];
    
}

//This method is a follow up to a game over to restart the game. (after pressing "End Game")
-(void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    //restart game (aka reset everything to 0/empty)
    [solutionArray removeAllObjects];
    count = 0;
    
    //reset the score
    scoreInt = 0;
    
    //create string
    NSString *convertInt;
    
    //convert int to string
    convertInt = [NSString stringWithFormat:@"%d", scoreInt];
    
    //display new score
    scoreLabel.text = convertInt;
    
    //start the game again
    [self addNewToArray];
    
    [self replaySolution];
}

//clean up method
-(void)viewDidUnload
{
    solutionArray = nil;
    redButton = nil;
    greenButton = nil;
    yellowButton = nil;
    blueButton = nil;
}


//highlights the button then unhighlights
-(void) highlight:(int)button {
    
    //NSDate *delay = [NSDate dateWithTimeIntervalSinceNow: 1];
    
    //if the button is red...
    if(button == 0) {
        
        //highlight the red button
        redButton.highlighted = YES;
        //sleep for half a second
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            redButton.highlighted = NO;
        });
        
    }
    
    //if the button is green...
    else if(button == 1) {
        
        //highlight the green button
        greenButton.highlighted = YES;
        //sleep for half a second
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            greenButton.highlighted = NO;
        });
        
    }
    
    //if the button is yellow...
    else if(button == 2) {
        
        //highlight the yellow button
        yellowButton.highlighted = YES;
        //sleep for half a second
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            yellowButton.highlighted = NO;
        });
        
    }
    
    //if the button is blue...
    else if(button == 3) {
        
        //highlight the blue button
        blueButton.highlighted = YES;
        //sleep for half a second
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            blueButton.highlighted = NO;
        });
        
    }
    
    [self performSelector:@selector(checkForContinue) withObject:nil afterDelay:1.0];
    
    
}

//this method prepares the layout of the app. Used mostly in lieu of the storyboard
-(void) buttons {
    
    //a check to see our progress for debugging purposes
    //testingLabel.text = @"load";
    
    //RED BUTTON
    //loading attributes for the red button (size, placement etc.)
    redButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"redHighlighted.gif"] highlightedImage:[UIImage imageNamed:@"redButton.gif"]];
    
    CGRect placementSize = CGRectMake(75, 150, 50, 50);
    redButton.frame = placementSize;
    [self.view addSubview:redButton];
    
    //red tag is set to 0 (first button)
    redButton.tag = 0;
    
    //enable the red button for use
    redButton.userInteractionEnabled = YES;
    
    
    //GREEN BUTTON
    //loading attributes for the green button (size, placement etc.)
    greenButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"greenButton.gif"] highlightedImage:[UIImage imageNamed:@"greenHighlighted.gif"]];
    
    placementSize = CGRectMake(200, 150, 50, 50);
    greenButton.frame = placementSize;
    [self.view addSubview:greenButton];
    
    //green tag is set to 1 (second button)
    greenButton.tag = 1;
    
    //enable the green button for use
    greenButton.userInteractionEnabled = YES;
    
    
    //YELLOW BUTTON
    //loading attributes for the yellow button (size, placement etc.)
    yellowButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"yellowButton.gif"] highlightedImage:[UIImage imageNamed:@"yellowHighlighted.gif"]];
    
    placementSize = CGRectMake(75, 250, 50, 50);
    yellowButton.frame = placementSize;
    [self.view addSubview:yellowButton];
    
    //yellow tag is set to 2 (third button)
    yellowButton.tag = 2;
    
    //enable the yellow button for use
    yellowButton.userInteractionEnabled = YES;
    
    
    //BLUE BUTTON
    //loading attributes for the blue button (size, placement etc.)
    blueButton = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"blueButton.gif"] highlightedImage:[UIImage imageNamed:@"blueHighlighted.gif"]];
    
    placementSize = CGRectMake(200, 250, 50, 50);
    blueButton.frame = placementSize;
    [self.view addSubview:blueButton];
    
    //blue tag is set to 3 (fourth button)
    blueButton.tag = 3;
    
    //enable the blue button for use
    blueButton.userInteractionEnabled = YES;
}

@end

//
//  ViewController.m
//  Simon Says!
//
//  Created by Jhaybie on 10/10/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@end


@implementation RootViewController
@synthesize  highScoreLabel,
             playerScoreLabel,
             startButton;


BOOL           playerTurn;
float          difficultyCounter;
id             observer;
int            highScore,
               numberOfMoves,
               playerMoveCounter,
               playerScore;
NSMutableArray *moves;


- (IBAction)onStartButtonTap:(id)sender
{
    [self performSelector:@selector(generateMoves)
               withObject:nil
               afterDelay:1.0f];
}


- (void)resetGame
{
    moves = [[NSMutableArray alloc] init];
    difficultyCounter = 1.0;
    numberOfMoves = 1;
    playerMoveCounter = 0;
    playerScore = 0;
    playerTurn = NO;
//    [startButton setTitle:@"Start!"
//                 forState:UIControlStateNormal];
    startButton.hidden = NO;
}


- (void)updateScore
{
    playerScore = playerScore + 1 * numberOfMoves;
    playerScoreLabel.text = [NSString stringWithFormat:@"%i", playerScore];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqual:@"Correct!"])
        [self performSelector:@selector(generateMoves)
                   withObject:nil
                   afterDelay:1.0f];
    else
    {
        if ([alertView.title isEqual:@"New High Score!"])
        {
            highScoreLabel.text = [NSString stringWithFormat:@"%i", highScore];
            if (buttonIndex != 0)
            {
                HighScoreViewController *hsvc = [[HighScoreViewController alloc] init];
                hsvc.playerName = (NSString *)[alertView textFieldAtIndex:0];
                hsvc.highScore = highScore;
                [self presentViewController:hsvc animated:YES completion:nil];
            }
        }
        else
        {
            if (buttonIndex != 0)
            {
//                HighScoreViewController *hsvc = ;
//                hsvc.highScore = highScore
            }
                //call next view controller
        }
    }
}


- (void)endComputerTurn
{
    playerTurn = YES;
}


- (void)generateMoves
{
    startButton.hidden = YES;
    playerTurn = NO;
    
    int x = arc4random()%6;
    moves[numberOfMoves-1] = [NSString stringWithFormat:@"%i", x];
    for (int index = 0; index < moves.count % 3; index ++)
    {
        difficultyCounter = difficultyCounter - 0.025;
    }
    for (int i = 0; i < numberOfMoves; i++)
    {
        for (ColorPanelView *view in self.view.subviews)
        {
            if ([view isKindOfClass: [ColorPanelView class]])
            {
                ColorPanelView *myView = (ColorPanelView *)view;
                if ([[NSString stringWithFormat:@"%i", myView.tag] isEqual:moves[i]])
                {
                    [myView performSelector:@selector(animateColorPanelView:)
                                 withObject:myView
                                 afterDelay:i * difficultyCounter];
                }
            }
        }
    }
    [self performSelector:@selector(endComputerTurn) withObject:nil afterDelay:numberOfMoves * difficultyCounter];
}


- (void) checkPlayerMoves:(NSString *)tag
{
    if (playerMoveCounter < numberOfMoves)
    {
        NSString *tempTag = moves[playerMoveCounter];
        if (tag.intValue != tempTag.intValue)
        {
            if (playerScore > highScore)
            {
                highScore = playerScore;
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New High Score!"
                                                                  message:@"Type in your name:"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:@"High Scores", nil];
                message.alertViewStyle = UIAlertViewStylePlainTextInput;
                [message show];
                
                
                // Present HighScoreViewController and pass params
                
                
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Game Over"
                                                                  message: @"Wrong button!"
                                                                 delegate: self
                                                        cancelButtonTitle: @"Ok"
                                                        otherButtonTitles: @"High Scores", nil];
                [message show];
            }
            [self resetGame];
        }
        else
        {
            playerMoveCounter++;
            [self updateScore];
            if (playerMoveCounter == numberOfMoves)
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle: @"Correct!"
                                                              message: @""
                                                                 delegate: self
                                                        cancelButtonTitle: @"Continue"
                                                        otherButtonTitles: nil];
                [message show];
                
                // TODO: refactor code to automatically start next round AFTER player dismisses UIAlertView message
                
                playerMoveCounter = 0;
                numberOfMoves++;
            }
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetGame];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    observer = [nc addObserverForName:@"Panel Touched"
                               object:nil
                                queue:[NSOperationQueue mainQueue]
                           usingBlock:^(NSNotification *note)
                {
                    if (playerTurn)
                    {
                        [self checkPlayerMoves:note.object];
                    }
                }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}


@end

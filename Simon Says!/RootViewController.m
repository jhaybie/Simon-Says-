//
//  ViewController.m
//  Simon Says!
//
//  Created by Jhaybie on 10/10/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UILabel  *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel  *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel  *turnLabel;
@end


@implementation RootViewController
@synthesize     highScoreLabel,
                playerScoreLabel,
                startButton,
                turnLabel;


BOOL            playerTurn;
float           difficultyCounter;
id              observer;
int             highScore,
                lowestHighScore,
                numberOfMoves,
                playerMoveCounter,
                playerScore;
NSMutableArray  *highScoreList,
                *moves;




- (void)generateMoves
{
    playerTurn         = NO;
    startButton.hidden = YES;
    turnLabel.text     = @"Computer's turn!";
    
    int x = arc4random()%6;
    moves[numberOfMoves-1] = [NSString stringWithFormat:@"%i", x];
    
    // *** This loop slowly shortens the delay between each panel animation as the game progresses ***
    
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
    [self performSelector:@selector(endComputerTurn)
               withObject:nil
               afterDelay:numberOfMoves * difficultyCounter];
}


- (void) checkPlayerMoves:(NSString *)tag
{
    if (playerMoveCounter < numberOfMoves)
    {
        NSString *tempTag = moves[playerMoveCounter];
        if (tag.intValue != tempTag.intValue)
        {
            if (playerScore > lowestHighScore)
            {
                lowestHighScore = playerScore;
                if (playerScore > highScore)
                    highScore = playerScore;
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New High Score!"
                                                                  message:@"Type in your name:"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:@"High Scores", nil];
                message.alertViewStyle = UIAlertViewStylePlainTextInput;
                [message show];
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
                playerMoveCounter = 0;
                numberOfMoves++;
            }
        }
    }
}


- (void)sortHighScoreList
{
    NSArray *sortedArray = [highScoreList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int a = [(HighScorePlayer *) obj1 playerScore];
        int b = [(HighScorePlayer *) obj2 playerScore];
        return [[NSString stringWithFormat:@"%i", a] compare: [NSString stringWithFormat:@"%i", b]];
    }];
    highScoreList = sortedArray.mutableCopy;
    [highScoreList removeObjectAtIndex:[highScoreList count] - 1];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqual:@"Correct!"])
        [self performSelector:@selector(generateMoves)
                   withObject:nil
                   afterDelay:1.0f];
    else
    {
        HighScoreViewController *hsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HighScoreViewController"];
        hsvc.highScoreList            = highScoreList;
        if ([alertView.title isEqual:@"New High Score!"])
        {
            HighScorePlayer *player = [[HighScorePlayer alloc] init];
            player.playerName       = [[alertView textFieldAtIndex:0] text];
            player.playerScore      = playerScore;
            [highScoreList addObject:player];
            [self sortHighScoreList];
            highScoreLabel.text = [NSString stringWithFormat:@"%i", highScore];
            if (buttonIndex != 0)
            {
                [self.navigationController pushViewController:hsvc
                                                     animated:YES];
            }
        }
        else
        {
            if (buttonIndex != 0)
            {
                [self.navigationController pushViewController:hsvc
                                                     animated:YES];
            }
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    highScoreList = [[NSMutableArray alloc] init];
    
    // Loading dummy high scores into HighScoreList
    
    HighScorePlayer *tempPerson0 = [[HighScorePlayer alloc] init];
    tempPerson0.playerName = @"KickAss";
    tempPerson0.playerScore = 2468;
    HighScorePlayer *tempPerson1 = [[HighScorePlayer alloc] init];
    tempPerson1.playerName = @"KickAss, Jr.";
    tempPerson1.playerScore = 2231;
    HighScorePlayer *tempPerson2 = [[HighScorePlayer alloc] init];
    tempPerson2.playerName = @"I'm # 1!";
    tempPerson2.playerScore = 1650;
    HighScorePlayer *tempPerson3 = [[HighScorePlayer alloc] init];
    tempPerson3.playerName = @"Jimmy";
    tempPerson3.playerScore = 1575;
    HighScorePlayer *tempPerson4 = [[HighScorePlayer alloc] init];
    tempPerson4.playerName = @"Darlene M";
    tempPerson4.playerScore = 1349;
    HighScorePlayer *tempPerson5 = [[HighScorePlayer alloc] init];
    tempPerson5.playerName = @"Jimmy";
    tempPerson5.playerScore = 989;
    HighScorePlayer *tempPerson6 = [[HighScorePlayer alloc] init];
    tempPerson6.playerName = @"Voltes V";
    tempPerson6.playerScore = 810;
    HighScorePlayer *tempPerson7 = [[HighScorePlayer alloc] init];
    tempPerson7.playerName = @"Asdfasdf";
    tempPerson7.playerScore = 521;
    HighScorePlayer *tempPerson8 = [[HighScorePlayer alloc] init];
    tempPerson8.playerName = @"Gettin btr";
    tempPerson8.playerScore = 128;
    HighScorePlayer *tempPerson9 = [[HighScorePlayer alloc] init];
    tempPerson4.playerName = @"I suck";
    tempPerson4.playerScore = 32;
    
    highScoreList[0] = tempPerson0;
    highScoreList[1] = tempPerson1;
    highScoreList[2] = tempPerson2;
    highScoreList[3] = tempPerson3;
    highScoreList[4] = tempPerson4;
    highScoreList[5] = tempPerson5;
    highScoreList[6] = tempPerson6;
    highScoreList[7] = tempPerson7;
    highScoreList[8] = tempPerson8;
    highScoreList[9] = tempPerson9;
    
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


- (void)resetGame
{
    moves = [[NSMutableArray alloc] init];
    difficultyCounter  = 1.0;
    highScore          = 0;
    numberOfMoves      = 1;
    playerMoveCounter  = 0;
    playerScore        = 0;
    playerTurn         = NO;
    startButton.hidden = NO;
    turnLabel.hidden   = YES;
    lowestHighScore = INT16_MAX;
    for (int i = 0; i < [highScoreList count]; i++)
    {
        if (highScore < [highScoreList[i] playerScore])
            highScore = [highScoreList[i] playerScore];
        if (lowestHighScore > [highScoreList[i] playerScore])
            lowestHighScore = [highScoreList[i] playerScore];
    }
    highScoreLabel.text = [NSString stringWithFormat:@"%i", highScore];
}


- (void)updateScore
{
    playerScore = playerScore + 1 * numberOfMoves;
    playerScoreLabel.text = [NSString stringWithFormat:@"%i", playerScore];
    if (playerScore > highScore)
    {
        highScore = playerScore;
        highScoreLabel.text = [NSString stringWithFormat:@"%i", highScore];
    }
}


- (void)endComputerTurn
{
    playerTurn       = YES;
    turnLabel.text   = @"Your turn!";
    turnLabel.hidden = NO;
}


- (IBAction)onStartButtonTap:(id)sender
{
    [self resetGame];
    playerScoreLabel.text = @"0";
    [self performSelector:@selector(generateMoves)
               withObject:nil
               afterDelay:1.0f];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.NavigationBarHidden = YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}


@end

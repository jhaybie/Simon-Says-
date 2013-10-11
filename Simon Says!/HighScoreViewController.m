//
//  HighScoreViewController.m
//  Simon Says!
//
//  Created by Jhaybie on 10/10/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import "HighScoreViewController.h"


@interface HighScoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *highScoreTableView;
@end


@implementation HighScoreViewController
@synthesize highScore, highScoreList, highScoreTableView, playerName;


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
    //return [highScoreList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [highScoreTableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"xxx"];
    }
    
    
    cell.textLabel.text = playerName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", highScore];
    //cell.textLabel.text = highScoreList[indexPath.row];
    [highScoreTableView reloadData];
    return cell;
}


- (IBAction)onDoneButtonTap:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
//    if (highScore > 0)
//    {
//        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
//        [temp setObject:playerNameTextField.text
//                 forKey:[NSString stringWithFormat:@"%i", highScore]];
//        [highScoreList addObject:temp];
//    }
//    [highScoreTableView reloadData];
//     Go back to RootViewController
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Player: %@, High Score: %i", playerName, highScore);
}



@end

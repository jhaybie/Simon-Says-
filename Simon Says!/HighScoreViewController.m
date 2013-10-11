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
@synthesize     highScoreList,
                highScoreTableView;


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [highScoreList count];
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
    
    cell.textLabel.text = [highScoreList[indexPath.row] playerName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [highScoreList[indexPath.row] playerScore]];

    [highScoreTableView reloadData];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    for (int i = 0; i < [highScoreList count]; i++)
    {
        HighScorePlayer *tempPerson = highScoreList[i];
        NSLog(@"Name: %@,  Score: %i", tempPerson.playerName, tempPerson.playerScore);
    }
    [highScoreTableView reloadData];
}



@end

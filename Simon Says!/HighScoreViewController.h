//
//  HighScoreViewController.h
//  Simon Says!
//
//  Created by Jhaybie on 10/10/13.
//  Copyright (c) 2013 Jhaybie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) NSMutableArray *highScoreList;
@property (weak, nonatomic) NSString *playerName;
@property (nonatomic) int highScore;
@end

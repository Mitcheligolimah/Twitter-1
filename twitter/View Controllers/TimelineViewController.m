//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *tweetsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void) didTweet:(Tweet *)tweet {
    [self.tweetsArray insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets)forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}
    // Get timeline
    - (void)fetchTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsArray = (NSMutableArray *)tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *dictionary in tweets) {
                NSString *text = dictionary.text;
                NSLog(@"%@", text);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    }


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[APIManager shared] logout];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweetsArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath: indexPath];
  
    Tweet *thisTweet = self.tweetsArray[indexPath.row];
    cell.tweet = thisTweet;
    
    cell.tweetName.text = thisTweet.user.name;
    cell.tweetText.text = thisTweet.text;
    cell.userName.text = [NSString stringWithFormat:@"@%@",thisTweet.user.screenName];
    
    NSString *URLString = thisTweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    cell.tweetImage.layer.cornerRadius = cell.tweetImage.frame.size.height / 2;
    cell.tweetImage.layer.masksToBounds = YES;
    cell.tweetImage.layer.borderWidth = 0;
    [cell.tweetImage setImageWithURL: url];
    
    NSString *favoriteCount = [NSString stringWithFormat:@"%d", thisTweet.favoriteCount];
    [cell.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];
    
    NSString *retweetCount = [NSString stringWithFormat:@"%d", thisTweet.retweetCount];
    [cell.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
    return cell;

}
  

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
}


@end
    

    

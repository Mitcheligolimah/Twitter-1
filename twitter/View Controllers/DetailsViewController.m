//
//  DetailsViewController.m
//  twitter
//
//  Created by Mitchel Igolimah on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *UnfavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *UnretweetButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end


@implementation DetailsViewController
- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        UIImage *UnfavoriteImage = [UIImage imageNamed:@"favor-icon"];
        [self.UnfavoriteButton setImage:UnfavoriteImage forState:UIControlStateNormal];
        NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];
        
        [[APIManager shared] Unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                 NSLog(@"Error Unfavoriting tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully Unfavorited the following Tweet: %@", tweet.text);
            }
        }];
        
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    
        UIImage *favoriteImage = [UIImage imageNamed:@"favor-icon-red"];
        [self.favoriteButton setImage:favoriteImage forState:UIControlStateNormal];
        // number (like count)
        NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}



- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        UIImage *UnretweetImage = [UIImage imageNamed:@"retweet-icon"];
        [self.UnretweetButton setImage:UnretweetImage forState:UIControlStateNormal];
        
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.UnretweetButton setTitle:retweetCount forState:UIControlStateNormal];

        [[APIManager shared] Unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                 NSLog(@"Error Unretweeting tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully Unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
    
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        UIImage *retweetImage = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:retweetImage forState:UIControlStateNormal];
    
        NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else {
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
        
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tweetName.text = self.tweet.user.name;
    self.tweetText.text = self.tweet.text;
    NSString *userName = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.userName.text = userName;
    self.dateLabel.text = self.tweet.createdAtString;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    self.tweetImage.layer.cornerRadius = self.tweetImage.frame.size.height / 2;
    self.tweetImage.layer.masksToBounds = YES;
    self.tweetImage.layer.borderWidth = 0;
    [self.tweetImage setImageWithURL: url];
    NSLog(@"%@", self.tweet);
    
    NSString *favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.favoriteButton setTitle:favoriteCount forState:UIControlStateNormal];

    NSString *retweetCount = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCount forState:UIControlStateNormal];

    
    
}


@end



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

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetName.text = self.tweet.user.name;
    self.tweetText.text = self.tweet.text;
    NSString *userName = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.userName.text = userName;
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    self.tweetImage.layer.cornerRadius = self.tweetImage.frame.size.height / 2;
    self.tweetImage.layer.masksToBounds = YES;
    self.tweetImage.layer.borderWidth = 0;
    [self.tweetImage setImageWithURL: url];
    NSLog(@"%@", self.tweet);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



//
//  RaceGameOverViewController.m
//  RoadFighter
//
//  Created by Pranav on 27/07/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#import "RaceGameOverViewController.h"

#import "RaceGameScoreBoardViewController.h"

@interface RaceGameOverViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end

@implementation RaceGameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_bkgImageView setImage:_bkgImage];
    [_lblTime setText:[NSString stringWithFormat:@"Time : %@",_time]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:NSStringFromClass([RaceGameScoreBoardViewController class])]) {
        RaceGameScoreBoardViewController *scoreBoardVC = (RaceGameScoreBoardViewController *)segue.destinationViewController;
        scoreBoardVC.bkgImage = _bkgImage;
    }
}


@end

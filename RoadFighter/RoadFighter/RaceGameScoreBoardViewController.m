//
//  RaceGameScoreBoardViewController.m
//  RoadFighter
//
//  Created by Pranav on 27/07/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#import "RaceGameScoreBoardViewController.h"

@interface RaceGameScoreBoardViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;

@end

@implementation RaceGameScoreBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_bkgImageView setImage:_bkgImage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

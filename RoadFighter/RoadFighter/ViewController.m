//
//  ViewController.m
//  RoadFighter
//
//  Created by Pranav on 29/06/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#import "ViewController.h"

#import "GameScreenView.h"
#import "RaceGameOverViewController.h"

@interface ViewController ()
- (IBAction)playButtonAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
}

- (void)gameOverVC:(UIImage *)screen{
    RaceGameOverViewController *nexScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RaceGameOverViewController"];
    nexScreenVC.bkgImage = screen;
    nexScreenVC.time = _time;
    [self.navigationController pushViewController:nexScreenVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButtonAction:(id)sender
{
    CGRect frame = [[UIScreen mainScreen]bounds];
    [self.view addSubview:[GameScreenView startGame:frame viewController:self]];
}
@end


//
//  GameScreenView.m
//  RoadFighter
//
//  Created by Pranav on 29/06/16.
//  Copyright © 2016 Pranav. All rights reserved.
//

#define Required_Score 20

#import "GameScreenView.h"

#import "MyCarView.h"
#import "CarRacingViewController.h"
#import "CoreDataHandler.h"
#import "AlarmAppAudioPlayer.h"
#import "Common.h"

GameScreenView *gameView;
NSMutableArray *carSeeders, *allTimer;
int roads;
NSTimer *myTimer, *animateTimer;
double placeTimer, speed, gameTimeMin;
CGFloat firstSeed;
int lifeRemaining, totalScore, carCounter, blueCarCounter;
int gameTime;
BOOL gameCar, start;
UILabel *carLabel, *timeLabel;
NSTimeInterval myInterval;
MyCarView *car, *playerCar;
UIViewController *mainScreenVC;

@implementation GameScreenView

+(GameScreenView *)startGame:(CGRect)frame viewController:(id)viewController{
    mainScreenVC = viewController;
    gameTime = 0;
    gameView = [[GameScreenView alloc]initWithFrame:frame];
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:frame];
    background.image = [UIImage imageNamed:@"bg-1"];
    background.contentMode = UIViewContentModeScaleToFill;
    
    UIImageView *roadBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.232, -frame.size.height, frame.size.width*0.54, frame.size.height)];
    roadBg1.image = [UIImage imageNamed:@"road_bg"];
    roadBg1.contentMode = UIViewContentModeScaleAspectFill;
    UIImageView *roadBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.232, 0, frame.size.width*0.54, frame.size.height)];
    roadBg2.image = [UIImage imageNamed:@"road_bg"];
    roadBg2.contentMode = UIViewContentModeScaleAspectFill;
    
    [UIView animateWithDuration:2.0
                          delay:0
                        options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                     animations:^{roadBg2.frame = CGRectMake(frame.size.width*0.232, frame.size.height, frame.size.width*0.54, frame.size.height);
                         roadBg1.frame = CGRectMake( frame.size.width*0.232, 0, frame.size.width*0.54, frame.size.height);
                     }
                     completion:^(BOOL finished){
                         roadBg2.frame = CGRectMake(frame.size.width*0.232, 0, frame.size.width*0.54, frame.size.height);
                         roadBg1.frame = CGRectMake(frame.size.width*0.232, -frame.size.height, frame.size.width*0.54, frame.size.height);
                     }];
    
    [gameView addSubview:roadBg2];
    [gameView addSubview:roadBg1];
    [gameView addSubview:background];
    
    [gameView sendSubviewToBack:roadBg2];
    [gameView sendSubviewToBack:roadBg1];
    [gameView sendSubviewToBack:background];
    allTimer = [[NSMutableArray alloc]init];
    playerCar = [[MyCarView alloc]initWithImage:[UIImage imageNamed:@"car_1"]];
    roads = 8;
    start = NO;
    gameTimeMin = 20.0;
    carCounter = 0;
    gameCar = YES;
    lifeRemaining = 3;
    placeTimer = 1.2;
    speed = 4;
    totalScore = 0;
    carLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameView.frame.origin.x+20, gameView.frame.origin.y+17, 40, 50)];
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(gameView.frame.size.width-65, gameView.frame.origin.y+17, 55, 50)];
    UILabel *timeLabelHead = [[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x, timeLabel.frame.origin.y-20, 55, 50)];
    UILabel *carLabelHead = [[UILabel alloc]initWithFrame:CGRectMake(carLabel.frame.origin.x-7, carLabel.frame.origin.y-20, 50, 50)];
    
    [timeLabelHead setText:@"Time"];
    [timeLabelHead setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:20]];
    [timeLabelHead setTextAlignment:NSTextAlignmentCenter];
    [timeLabelHead setTextColor:[UIColor colorWithRed:228.0/255.0 green:241.0/255.0 blue:53.0/255.0 alpha:1.0]];
    [carLabelHead setText:@"Cars"];
    [carLabelHead setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:20]];
    [carLabelHead setTextAlignment:NSTextAlignmentCenter];
    [carLabelHead setTextColor:[UIColor colorWithRed:228.0/255.0 green:241.0/255.0 blue:53.0/255.0 alpha:1.0]];
    
    [carLabel setText:[NSString stringWithFormat:@"%d", carCounter]];
    [timeLabel setText:@"0.0"];
    [carLabel setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:25]];
    [timeLabel setFont:[UIFont fontWithName:@"Sen-ExtraBold" size:25]];
    [carLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setTextColor:[UIColor colorWithRed:228.0/255.0 green:241.0/255.0 blue:53.0/255.0 alpha:1.0]];
    [carLabel setTextColor:[UIColor colorWithRed:228.0/255.0 green:241.0/255.0 blue:53.0/255.0 alpha:1.0]];
    
    [gameView addSubview:timeLabelHead];
    [gameView addSubview:carLabelHead];
    [gameView addSubview:timeLabel];
    [gameView addSubview:carLabel];
    carSeeders = [[NSMutableArray alloc]init];
    firstSeed = frame.size.width/roads;
    CGFloat seedBuffer = firstSeed*2.5;
    for (int i=1; i<=4; i++) {
        [carSeeders addObject:[NSNumber numberWithDouble:seedBuffer]];
        seedBuffer += firstSeed;
    }
    playerCar.frame = CGRectMake([[carSeeders objectAtIndex:carSeeders.count/2]floatValue]-(playerCar.frame.size.width*0.33), frame.size.height, 35, 70);
    playerCar.carType = 5;
    [gameView addSubview:playerCar];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateGameTimer)
                                   userInfo:nil
                                    repeats:YES];
    [self placeCars];
    return gameView;
}

+ (void)updateGameTimer{
    gameTime ++;
    int minute = gameTime/60;
    int second = gameTime % 60;
    [timeLabel setText:[NSString stringWithFormat:@"%d.%d",minute,second]];
}

- (void)startAnimations{
    start = YES;
    gameCar = NO;
}

+ (void)placeCars{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView animateWithDuration:0.6
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{playerCar.transform = CGAffineTransformTranslate(playerCar.transform, 0, -playerCar.frame.size.width*2.5);}
                         completion:nil];
        double delay = 0.1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [gameView startAnimations];
        });
    });
    if (start){
        placeTimer -= 0.08;
        int buff = arc4random_uniform(5)+2;
        carCounter++;
        car = [[MyCarView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"car_%d",buff]]];
        car.carType = buff;
        car.frame = CGRectMake([[carSeeders objectAtIndex:arc4random_uniform((int)carSeeders.count)] floatValue]-(car.frame.size.width*0.33), 50, 35, 70);
        car.collide = NO;
        [gameView addSubview:car];
        if(placeTimer<0.4)
            placeTimer = 0.4;
        if(speed>9.5)
            speed = 9.5;
        animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                        target:self
                                                      selector:@selector(animateCars:)
                                                      userInfo:car
                                                       repeats:YES];
    }
    [self performSelector:@selector(placeCars)
               withObject:nil
               afterDelay:placeTimer];
}

+ (void)animateCars:(NSTimer *)timer{
    [allTimer addObject:timer];
    speed += 0.01;
    MyCarView *myCar = [timer userInfo];
    myCar.transform = CGAffineTransformTranslate(myCar.transform, 0, speed);
    if (myCar.frame.origin.y >= gameView.frame.size.height) {
        ++carCounter;
        [carLabel setText:[NSString stringWithFormat:@"%d", carCounter]];
        [myCar removeFromSuperview];
        totalScore += 1;
        [timer invalidate];
        if (carCounter == Required_Score) {
            [gameView gameOver];
        }
    } else if(CGRectIntersectsRect(playerCar.frame, myCar.frame) && myCar.collide == NO){
        myCar.collide = YES;
        placeTimer = 1.0;
        speed = 3.5;
        [myCar removeFromSuperview];
        [timer invalidate];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:gameView];
    if (touchPoint.x > gameView.frame.size.width/2 && playerCar.center.x+firstSeed < gameView.frame.size.width*0.75) {
        //move right
        [UIView animateWithDuration:0.1
                         animations:^{playerCar.frame = CGRectOffset(playerCar.frame, firstSeed, 0);
                         }];
    } else
        if (touchPoint.x < gameView.frame.size.width/2 && playerCar.center.x-firstSeed > gameView.frame.size.width*0.25){
            //move left
            [UIView animateWithDuration:0.1
                             animations:^{playerCar.frame = CGRectOffset(playerCar.frame, -firstSeed, 0);
                             }];
        }
}

- (void)gameOver{
    UIGraphicsBeginImageContext(gameView.frame.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    for (id timerCounter in allTimer) {
        if ([timerCounter isValid])
            [timerCounter invalidate];
    }
    start = NO;
    NSString *game_time = [NSString stringWithFormat:@"%d",gameTime];
    [[CoreDataHandler sharedInstance] saveScore:[NSString stringWithFormat:@"%d",Required_Score] time:timeLabel.text totalTimeInSecond:game_time gameName:Car_racing_game_name];
    [[AlarmAppAudioPlayer sharedInstance] stopAudio];
    CarRacingViewController *vc = (CarRacingViewController *)mainScreenVC;
    vc.time = timeLabel.text;
    vc.screenShot = screenShot;
    vc.timeInSecond = game_time;
    vc.gameName = Car_racing_game_name;
    vc.currentScore = [NSString stringWithFormat:@"%d",Required_Score];
    [mainScreenVC performSelector:@selector(gameOverVC)];
}

@end

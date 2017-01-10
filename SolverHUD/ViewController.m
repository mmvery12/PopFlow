//
//  ViewController.m
//  WarnView
//
//  Created by liyuchang on 15-1-28.
//  Copyright (c) 2015年 com.Vacn. All rights reserved.
//

#import "ViewController.h"
#import "SolverHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    SolverHUDGIF *gif = [SolverHUDGIF ScheduledShowInView:self.view withImages:@[(id)[UIImage imageNamed:@"microphone1"].CGImage,
                                                             (id)[UIImage imageNamed:@"microphone2"].CGImage,
                                                             (id)[UIImage imageNamed:@"microphone3"].CGImage]];
    [gif removeThisHud];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [SolverHUDTextDailog ScheduledShowInView:self.view withText:@"asdasdasdasdsadsdasdasdsadasdasdasdsadasdasdsadasdsadsadasdasdas"];
//        [SolverHUDWorkFlowFailed ScheduledShowInView:self.view];
//    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

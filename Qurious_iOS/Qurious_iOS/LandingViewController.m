//
//  LandingViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/22/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger myID = [defaults integerForKey: @"myID"];
    if (myID == 0){
        //  force login
        [self performSegueWithIdentifier: @"gotoLogin" sender: self];
    }
    else {
        [self performSegueWithIdentifier: @"gotoMaster" sender: self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LandingViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/22/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "LandingViewController.h"
#import "QApiRequests.h"

@interface LandingViewController ()

@end
static UIViewController * _self;

@implementation LandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

void authCallback (id arg) {
    NSLog(@"Check authorization JSON Callback %@", arg);
    if (![arg isKindOfClass: [NSString class]] && arg != NULL) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger myID = [((NSDictionary*) arg)[@"user_id"] intValue];
        if (myID != 0){
            [defaults setInteger:myID forKey: @"myID"];
            [_self performSegueWithIdentifier: @"gotoMaster" sender: _self];
        }
        else {
            [_self performSegueWithIdentifier: @"gotoLogin" sender: _self];
        }
    } else {
    //  force login
        [_self performSegueWithIdentifier: @"gotoLogin" sender: _self];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    _self = self;
    [QApiRequests whoAmI: &authCallback];

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

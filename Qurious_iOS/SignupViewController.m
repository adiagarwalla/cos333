//
//  SignupViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/13/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "SignupViewController.h"
#import "QApiRequests.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize usernameField = _usernameField;
@synthesize pwField = _pwField;
@synthesize pw2Field = _pw2Field;

static UIViewController * me;

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
    // Do any additional setup after loading the view.
    _usernameField.delegate = self;
    _pwField.delegate = self;
    _pw2Field.delegate = self;
    me = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString: @"signup"]) {
        NSString *username = _usernameField.text;
        NSString *pw = _pwField.text;
        NSString *pwConfirm = _pw2Field.text;
        if ([username isEqualToString: @""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                            message:@"Please enter a valid nonempty username and confirm."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else if ([pw isEqualToString: @""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password"
                                                            message:@"Please enter a valid nonempty password and confirm."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        else if (![pw isEqualToString:pwConfirm])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords Do Not Match"
                                                            message:@"Please enter a valid nonempty password and confirm."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    return YES;

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

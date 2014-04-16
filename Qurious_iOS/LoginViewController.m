//
//  LoginViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/13/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "LoginViewController.h"
#import "QApiRequests.h"
#import "SignupViewController.h"
#import "MasterViewController.h"
@interface LoginViewController ()
@end

@implementation LoginViewController
@synthesize usernameField = _usernameField;
@synthesize pwField = _pwField;

static UIViewController * me;
static id myID;
static UIActivityIndicatorView* spinner;

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
    self.usernameField.delegate = self;
    self.pwField.delegate = self;
    me = self;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(160.0f, 188.0f)];
    [self.view addSubview:spinner]; // spinner is not visible until started

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void loginCallback (id arg) {
    if (arg == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                        message:@"Please enter a valid username and password combination."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        [spinner stopAnimating];
        myID = ((NSDictionary*) arg)[@"userid"];
        [me performSegueWithIdentifier:@"loginSuccess" sender:me];
        
    }
    [spinner stopAnimating];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"loginSuccess"]) {
        [[segue destinationViewController] setUserID: myID];
    }
}


- (IBAction) loginButtonClicked {
    NSString *username = self.usernameField.text;
    NSString *pw = self.pwField.text;
    [spinner startAnimating];
    [QApiRequests login: username andPassword: pw andCallback: &loginCallback];
    
}


- (IBAction)cancel:(UIStoryboardSegue *)segue {
    
}

void signupCallback(id arg) {
    [spinner stopAnimating];
    if (arg == NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsuccessful Signup"
                                                        message:@"Sorry there is something wrong with our system! Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([((NSDictionary*) arg)[@"return"] isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsuccessful Signup"
                                                        message:@"Please try again with a different username"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                        message:@"Sign up was a success! Please sign in!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)save:(UIStoryboardSegue *)segue
{
    SignupViewController *signupController = [segue sourceViewController];
    NSString * username = signupController.usernameField.text;
    NSString * pw = signupController.pwField.text;
    [spinner startAnimating];

    [QApiRequests signUp: username andPassword: pw andEmail: @"" andCallback: &signupCallback];
    
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

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

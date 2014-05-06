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
#import "SWRevealViewController.h"

@interface LoginViewController () {
    CGFloat kbSize;
}
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
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationController.navigationBar.hidden = YES;
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
    else if (![arg isKindOfClass: [NSString class]]){
        [spinner stopAnimating];
        myID = ((NSDictionary*) arg)[@"userid"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger: [myID intValue] forKey:@"myID"];
        [defaults synchronize];
        NSLog(@"UserID saved");
        [me performSegueWithIdentifier:@"loginSuccess" sender:me];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Down"
                                                        message:@"Please try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [spinner stopAnimating];
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"prepareForSegue: %@", segue.identifier);
//    
//    if ([segue.identifier isEqualToString:@"loginSuccess"]) {
//        [[segue destinationViewController] setUserID: myID];
//    }
//}


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
    //[self setViewMovedUp:NO];
    return YES;
}



-(void)keyboardWillShow :(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height*.8;
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
}

-(void)keyboardWillHide :(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height*.8;
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else
        if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{

        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kbSize;
        rect.size.height += kbSize;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kbSize;
        rect.size.height -= kbSize;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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

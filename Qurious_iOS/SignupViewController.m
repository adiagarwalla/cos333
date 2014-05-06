//
//  SignupViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/13/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "SignupViewController.h"
#import "QApiRequests.h"

@interface SignupViewController (){
    CGFloat kbSize;
}

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
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
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

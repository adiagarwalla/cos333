//
//  EditViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//
#import "EditViewController.h"
#import "Person.h"
#import <QuartzCore/QuartzCore.h>

@interface EditViewController ()
@end

@implementation EditViewController

@synthesize detailItem = _detailItem;
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize emailField = _emailField;
@synthesize bioField = _bioField;
@synthesize selectedImage;

- (void)setDetailItem:(id)detailItem {
    if (_detailItem != detailItem) {
        _detailItem = detailItem;
        [self configureView];
    }
}

- (void)configureView {
    if (self.detailItem && [self.detailItem isKindOfClass:[Person class]]) {
        self.firstNameField.text = [self.detailItem firstName];
        self.lastNameField.text = [self.detailItem lastName];
        self.emailField.text = [self.detailItem email];
        self.bioField.text = [self.detailItem bio];
        self.selectedImage.image = [self.detailItem profPic];
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.firstNameField) ||
        (textField == self.lastNameField) ||
        (textField == self.emailField)){
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    [_bioField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_bioField.layer setBorderWidth:1.0];
    _bioField.layer.cornerRadius = 5;
    _bioField.clipsToBounds = YES;

}

-(IBAction) buttonClicked {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self; //ignore this warning
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    //[[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[Picker release];
} //uhhh does not work

- (void)imagePickerController:(UIImagePickerController *) Picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
    selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[[Picker parentViewController] dismissModalViewControllerAnimated:YES];
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[Picker release];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
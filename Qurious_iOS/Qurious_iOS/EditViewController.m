//
//  EditViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "EditViewController.h"
#import "Person.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize detailItem = _detailItem;
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize emailField = _emailField;
@synthesize bioField = _bioField;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
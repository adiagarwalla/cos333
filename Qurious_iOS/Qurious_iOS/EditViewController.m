//
//  EditViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//
#import "EditViewController.h"
#import "Person.h"

@interface EditViewController () {
    NSMutableArray *skills;
}
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
    skills = [self.detailItem skills];
//    int xposition = 20;
//    int yposition = 20;
//    for (NSString *skill in skills) {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(xposition, yposition, 200.0f, 21.0f);
//        label.text = skill;
//        // Do some stuff
//        [self.scrollView addSubview:label];
//        yposition += 30;
//    }
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


#pragma mark - Table View

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return skills.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:@"Cell"
//                             forIndexPath:indexPath];
//    NSString *skill = skills[indexPath.row];
//    cell.textLabel.text = skill;
//    return cell;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [skills removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
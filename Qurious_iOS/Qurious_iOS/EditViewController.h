//
//  EditViewController.h
//  Qurious_iOS
//
//  Created by Helen Yu on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UITableViewController
<UITextFieldDelegate>
{
    UIImagePickerController *picker;
    IBOutlet UIImageView * selectedImage;
}
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextView *bioField;
@property (nonatomic, retain) UIImageView * selectedImage;

- (IBAction) buttonClicked;

@end

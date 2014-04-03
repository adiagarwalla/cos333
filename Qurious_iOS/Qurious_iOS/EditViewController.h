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
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextView *bioField;
@property (nonatomic, retain) UIImageView * selectedImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction) buttonClicked;

@end

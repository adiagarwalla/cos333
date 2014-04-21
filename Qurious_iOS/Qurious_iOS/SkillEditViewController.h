//
//  SkillEditViewController.h
//  Qurious_iOS
//
//  Created by Helen Yu on 4/21/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillEditViewController : UITableViewController
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UISwitch *forSaleSwitch;
@property (strong, nonatomic) IBOutlet UITextView *descField;

@end

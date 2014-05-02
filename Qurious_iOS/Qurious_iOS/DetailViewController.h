//
//  DetailViewController.h
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

//- (IBAction)cancel:(UIStoryboardSegue *)segue;
-(IBAction) sessionButtonClicked;
@end

//
//  DetailViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "DetailViewController.h"
#import "Person.h"
#import "EditViewController.h"
@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
@synthesize detailItem = _detailItem;
@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize bioLabel = _bioLabel;
@synthesize imageView = _imageView;
- (void)configureView {
    if (self.detailItem &&
        [self.detailItem isKindOfClass:[Person class]]) {
        NSString *name = [NSString stringWithFormat:@"%@ %@",
                          [self.detailItem firstName],
                          [self.detailItem lastName]];
        self.nameLabel.text = name;
        self.emailLabel.text = [self.detailItem email];
        self.bioLabel.text = [self.detailItem bio];
        self.imageView.image = [self.detailItem profPic];
    }
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editDetail"]) {
        NSArray *navigationControllers = [[segue destinationViewController] viewControllers];
        EditViewController *editViewController = [navigationControllers objectAtIndex:0];
        [editViewController setDetailItem:self.detailItem];
    }
}

- (IBAction)save:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"saveInput"]) {
        EditViewController *editController = [segue sourceViewController];
        [self.detailItem setFirstName:editController.firstNameField.text];
        [self.detailItem setLastName:editController.lastNameField.text];
        [self.detailItem setEmail:editController.emailField.text];
        [self.detailItem setBio:editController.bioField.text];
        [self configureView];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"cancelInput"]) {
        // Custom cancel handling can go here.
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    NSMutableArray *skills = [self.detailItem skills];
    int xposition = 20.0f;
    int yposition = 0;
    int count = 0;
    int xdisplacement;
    for (NSString *skill in skills) {
        if (count%3 == 0) xdisplacement = 0;
        else if (count%3 == 1) xdisplacement = 100.f;
        else xdisplacement = 200.f;
        UIColor * color;
        if (count%2 == 0) color = [UIColor redColor];
        if (count%2 == 1) color = [UIColor blueColor];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:skill forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:color];
        //UIImage* image = [UIImage imageNamed:@"img1.png"];
        //[button setBackgroundImage:image forState:UIControlStateNormal];
        
        button.frame = CGRectMake(xposition + xdisplacement, yposition, 75.0f, 75.0f);
        if (count%3 == 2) yposition += 100.f;
        count++;
        [self.scrollView addSubview:button];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

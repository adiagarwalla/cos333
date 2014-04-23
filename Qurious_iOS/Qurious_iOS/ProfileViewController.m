//
//  ProfileViewController.m
//  Qurious_iOS
//
//  Created by Helen Yu on 4/14/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "ProfileViewController.h"
#import "Person.h"
#import "EditViewController.h"
#import "SkillViewController.h"
#import "Skill.h"
#import "QApiRequests.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()

@end

void saveCallback (id arg) {
    NSLog(@"Save profile JSON: %@", arg);
    printf("%s", "Saved a profile");
}



void pictureCallback(id arg) {
    NSLog(@"Save picture JSON: %@", arg);
    printf("%s", "Saved a picture");
}


@implementation ProfileViewController
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
        if ([name isEqualToString: @" "]) self.nameLabel.text = [self.detailItem username];
        else self.nameLabel.text = name;
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
    if ([[segue identifier] isEqualToString:@"editProfile"]) {
        NSArray *navigationControllers = [[segue destinationViewController] viewControllers];
        EditViewController *editViewController = [navigationControllers objectAtIndex:0];
        [editViewController setDetailItem:self.detailItem];
    }
    if ([[segue identifier] isEqualToString:@"showSkillEdit"]) {
        [[segue destinationViewController] setDetailItem:self.detailItem];
    }
    
}



- (IBAction)save:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"saveInput"]) {
        EditViewController *editController = [segue sourceViewController];
        [self.detailItem setFirstName:editController.firstNameField.text];
        [self.detailItem setLastName:editController.lastNameField.text];
        [self.detailItem setEmail:editController.emailField.text];
        [self.detailItem setBio:editController.bioField.text];
        [self.detailItem setProfPic:editController.selectedImage.image];
        
        [QApiRequests editProfile: [self.detailItem firstName] andLastName: [self.detailItem lastName] andBio:[self.detailItem bio] andEmail:[self.detailItem email] andProfile:[NSString stringWithFormat:@"%@ %@", [self.detailItem firstName], [self.detailItem lastName]] andCallback: saveCallback];
        
        if (editController.hasNewImage == YES) {
            [QApiRequests uploadImage:[self.detailItem profPic] andId:[NSString stringWithFormat: @"%i",[self.detailItem userID]] andCallback:pictureCallback];
        }
        [self configureView];
    }
    
}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
    
}


-(void) loadButtons {
    for(UIView *view in self.scrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            [view  removeFromSuperview];
        }
    }
    
    NSArray *buttonImg = @[@"img1.png", @"img2.png", @"img3.png", @"img4.png", @"img5.png", @"img6.png"];
    NSMutableArray *skills = [self.detailItem skills];
    int xposition = 20.0f;
    int yposition = 0;
    int count = 0;
    int xdisplacement;
    for (Skill *skill in skills) {
        if (count%3 == 0) xdisplacement = 0;
        else if (count%3 == 1) xdisplacement = 100.f;
        else xdisplacement = 200.f;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:skill.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.titleLabel.numberOfLines = 4;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UIImage* image = [UIImage imageNamed:buttonImg[count%6]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        button.frame = CGRectMake(xposition + xdisplacement, yposition, 75.0f, 75.0f);
        if (count%3 == 2) yposition += 100.f;
        count++;
        [self.scrollView addSubview:button];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Change button color
    //_sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self loadButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

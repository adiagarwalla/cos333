//
//  DetailViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewController.h"
#import "Person.h"
#import "Skill.h"
#import "QApiRequests.h"


@interface DetailViewController ()
- (void)configureView;
- (void)loadButtons;

@end

@implementation DetailViewController
@synthesize detailItem = _detailItem;
@synthesize nameLabel = _nameLabel;
@synthesize emailLabel = _emailLabel;
@synthesize bioLabel = _bioLabel;
@synthesize imageView = _imageView;

static UIActivityIndicatorView* detailSpinner;
static UITableViewController * me;

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
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self loadButtons];
    detailSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [detailSpinner setCenter:CGPointMake(160.0f, 188.0f)];
    [self.view addSubview:detailSpinner];
    
    self.navigationItem.title = self.nameLabel.text;

}

void detail_callback (id arg) {
    // do nothing valuable
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    NSString * kSession = ((NSDictionary*) arg)[@"session_id"];
    [detailSpinner stopAnimating];
    [ViewController setSessionToken: kSession];
    [me performSegueWithIdentifier: @"SessionSegue" sender: me];
}

-(IBAction) sessionButtonClicked {
    me = self;
    [detailSpinner startAnimating];
    [QApiRequests createSession:[NSString stringWithFormat:@"%i", [self.detailItem userID]] andMinutes:@"15" andCallback:&detail_callback];

}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SessionOver"]) {
        ViewController *sessionController = [segue sourceViewController];
        [sessionController.session disconnect];
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

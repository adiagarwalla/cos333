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
#import "PIctureNameButtonTableViewCell.h"


@interface DetailViewController () {
    UIButton * enterSessionButton;
}

@end

@implementation DetailViewController
@synthesize detailItem = _detailItem;
//@synthesize enterSession = _enterSessionButton;
//@synthesize nameLabel = _nameLabel;
//@synthesize emailLabel = _emailLabel;
//@synthesize imageView = _imageView;
//@synthesize bioLabel = _bioLabel;

static UIActivityIndicatorView* detailSpinner;
static UITableViewController * me;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
    }
}

/*
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[self.detailItem profPic]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.imageView.image = [UIImage imageWithData:imageData];
            });
        });
        
    }
    
}

-(void) loadButtons {
    NSMutableArray *skills = [self.detailItem skills];
    for (Skill *skill in skills) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SkillCell"];
        cell.textLabel.text = skill.name;
        [self.tableView addSubview:cell];
    }
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailItem skills].count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 369.0f;
    }
    // "Else"
    return 63.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView
    //                             dequeueReusableCellWithIdentifier:@"Cell"
    //                             forIndexPath:indexPath];
    
    static NSString *picIdentifier = @"PictureCell";
    static NSString *bioIdentifier = @"BioCell";
    static NSString *skillIdentifier = @"SkillCell";
    if (indexPath.row == 0) {
        PIctureNameButtonTableViewCell* cell = (PIctureNameButtonTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:picIdentifier];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[self.detailItem profPic]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                cell.picture.image = [UIImage imageWithData:imageData];
            });
        });
        
        NSString *name = [NSString stringWithFormat:@"%@ %@",
                          [self.detailItem firstName],
                          [self.detailItem lastName]];
        if ([name isEqualToString: @" "]) cell.name.text = [self.detailItem username];
        else cell.name.text = name;
        cell.email.text = [self.detailItem email];
        enterSessionButton = cell.enterSessionButton;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger myID = [defaults integerForKey:@"myID"];
        if (myID == [self.detailItem userID]) {
            enterSessionButton.hidden = YES;
        }
        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:bioIdentifier];
        UILabel* label = (UILabel *)[cell.contentView viewWithTag:100];
        label.text = [self.detailItem bio];
        return cell;
    } else {
        UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:skillIdentifier];
        int row = indexPath.row - 2;
        UILabel* label = (UILabel *)[cell.contentView viewWithTag:10];
        label.text = [[[self.detailItem skills] objectAtIndex:row] name];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self configureView];
    //[self loadButtons];
	// Do any additional setup after loading the view, typically from a nib.
    detailSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [detailSpinner setCenter:CGPointMake(160.0f, 188.0f)];
    [self.view addSubview:detailSpinner];
    
    self.navigationItem.title = [[self.detailItem firstName] isEqualToString:@""] && [[self.detailItem lastName] isEqualToString:@""] ? [self.detailItem username] : [NSString stringWithFormat:@"%@ %@", [self.detailItem firstName], [self.detailItem lastName]];
    

}

void detail_callback (id arg) {
    // do nothing valuable
    NSLog(@"Starting session JSON: %@", arg);
    if ([arg isKindOfClass: [NSDictionary class]] &&  [arg objectForKey:@"session_id"] != nil){
        NSString * kSession = ((NSDictionary*) arg)[@"session_id"];
        [detailSpinner stopAnimating];
        [ViewController setSessionToken: kSession];
        [me performSegueWithIdentifier: @"SessionSegue" sender: me];
    }
}

-(IBAction) sessionButtonClicked {
    me = self;
    [detailSpinner startAnimating];
    [QApiRequests createSession:[NSString stringWithFormat:@"%i", [self.detailItem userID]] andMinutes:@"15" andCallback:&detail_callback];

}

/*- (IBAction)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SessionOver"]) {
        ViewController *sessionController = [segue sourceViewController];
        [sessionController.session disconnect];
    }

}*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

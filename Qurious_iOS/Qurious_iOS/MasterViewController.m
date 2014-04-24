//
//  MasterViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 3/31/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "MasterViewController.h"
#import "Person.h"
#import "DetailViewController.h"
#import "QApiRequests.h"
#import "Skill.h"
#import "SWRevealViewController.h"

@interface MasterViewController ()
@end

@implementation MasterViewController

static NSMutableArray *_objects;
static UITableView *view;
static Person * me;
- (void)awakeFromNib
{
    [super awakeFromNib];
}



void mastercallback(id arg) {
    
    // do nothing valuable
    NSLog(@"Pulling all profiles JSON: %@", arg);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger myID = [defaults integerForKey:@"myID"];
    if (arg != NULL) {
        _objects = [[NSMutableArray alloc] init];
        
        NSDictionary * results = arg;
        for (NSDictionary *jsonobject in results) {
            NSDictionary *fields = jsonobject[@"profile"][0][@"fields"];
            Person *friend = [[Person alloc] init];
            friend.firstName = fields[@"profile_first"];
            friend.lastName = fields[@"profile_last"];
            friend.email = fields[@"user_email"];
            friend.bio = fields[@"user_bio"];
            friend.userID = [fields[@"user"] intValue];
            if (friend.userID == myID) {
                me = friend;
            }
            friend.username = fields[@"profile_name"];
            NSDictionary *skills = jsonobject[@"skills"];
            NSMutableArray * allmyskills = [[NSMutableArray alloc] init];
            for (NSDictionary * skill in skills) {
                Skill * mySkill = [[Skill alloc] init];
                mySkill.name = skill[@"fields"][@"name"];
                mySkill.desc = skill[@"fields"][@"desc"];
                mySkill.price = skill[@"fields"][@"price"];
                mySkill.skillID = [skill[@"pk"] intValue];
                if ([skill[@"fields"][@"is_marketable"] intValue] == 1) mySkill.isMarketable = YES;
                else mySkill.isMarketable = NO;
                [allmyskills insertObject:mySkill atIndex:0];
            }
            friend.skills = allmyskills; // not releasing old array uhhhh
            [_objects insertObject:friend atIndex:0];
        }
        [view reloadData];
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
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    view = (UITableView *)self.view;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [QApiRequests getAllProfiles:&mastercallback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"Cell"
                             forIndexPath:indexPath];
    Person *friend = _objects[indexPath.row];
    if ([friend.firstName isEqualToString: @""] && [friend.lastName isEqualToString: @""]) {
        cell.textLabel.text = friend.username;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Person *friend = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:friend];
    }
    if ([[segue identifier] isEqualToString:@"showProfile"]) {
        [[segue destinationViewController] setDetailItem:me];
    }
}

@end

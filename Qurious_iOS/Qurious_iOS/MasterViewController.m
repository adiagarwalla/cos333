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
static NSMutableArray *_skills;
static UITableView *view;
- (void)awakeFromNib
{
    [super awakeFromNib];
}



void callback(id arg) {
    
    // do nothing valuable
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
    if (arg != NULL) {
        _objects = [[NSMutableArray alloc] init];
        
        NSDictionary * results = arg;
        for (NSDictionary *jsonobject in results) {
            NSDictionary *fields = jsonobject[@"fields"];
            Person *friend = [[Person alloc] init];
            friend.firstName = fields[@"profile_first"];
            friend.lastName = fields[@"profile_last"];
            friend.email = fields[@"user_email"];
            friend.bio = fields[@"user_bio"];
            friend.username = fields[@"profile_name"];
            friend.userID = [fields[@"user"] intValue];
            [_objects insertObject:friend atIndex:0];
            
        }
        
        [view reloadData];
    }
}

void skillCallback(id arg) {
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
    if (arg != NULL) {
        for (NSDictionary * object in arg)
        {
            Skill * skill = [[Skill alloc] init];
            NSDictionary *fields = object[@"fields"];
            skill.desc = fields[@"name"];
            if ([fields[@"is_marketable"]  isEqual: @"1"]) skill.isMarketable = YES;
            skill.price = fields[@"price"];
            skill.skillID = [object[@"pk"] intValue];
            [_skills addObject: skill];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    // test the server requests right here
    // THIS IS SUPPOSED TO JUST SHOW YOU HOW THIS WORKS!!!
    //[QApiRequests getProfiles:2 andCallback:&callback];
    
    view = (UITableView *)self.view;
    
    [QApiRequests getAllProfiles:&callback];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [view reloadData];
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


void profileCallback(id arg) {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Person *friend = _objects[indexPath.row];
        _skills = [[NSMutableArray alloc] init];
        [friend setSkills: _skills];
        [QApiRequests getAllSkills: [friend userID] andCallback: &skillCallback];
        [[segue destinationViewController] setDetailItem:friend];
    }
//    if ([[segue identifier] isEqualToString:@"showProfile"]) {
//        
//        int myID;
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        [QApiRequests getProfiles: myID andCallback:&profileCallback];
//        Person *me =;
//        _skills = [[NSMutableArray alloc] init];
//        [me setSkills: _skills];
//        [QApiRequests getAllSkills: myID andCallback: &skillCallback];
//        [[segue destinationViewController] setDetailItem:me];
//    }
}

@end

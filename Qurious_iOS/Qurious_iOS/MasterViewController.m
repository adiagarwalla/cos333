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

@interface MasterViewController ()
@end

@implementation MasterViewController

static NSMutableArray *_objects;
static UITableView *view;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

void skillCallback(id arg) {
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
    // to edit to create NSMutableArray of Skills
}

void callback(id arg) {
    
    // do nothing valuable
    NSLog(@"JSON: %@", arg);
    printf("%s", "Hi");
    
    _objects = [[NSMutableArray alloc] init];
    
    NSDictionary * results = arg;
    for (NSDictionary *jsonobject in results) {
        NSDictionary *fields = jsonobject[@"fields"];
        Person *friend = [[Person alloc] init];
        friend.firstName = fields[@"profile_first"];
        friend.lastName = fields[@"profile_last"];
        friend.email = fields[@"user_email"];
        friend.bio = fields[@"user_bio"];
        friend.userID = (int) fields[@"user"];
        
        // broken: returning (null) JSON
        [QApiRequests getAllSkills: friend.userID andCallback: &skillCallback];
        [_objects insertObject:friend atIndex:0];
        printf("%s", "Hi");
        
        
    }

    [view reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           friend.firstName, friend.lastName];
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
}

@end

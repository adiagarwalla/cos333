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
static NSMutableArray *_searchObjects;
static UITableView *view;
//static Person * me;
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
        _searchObjects = [[NSMutableArray alloc] init];
        
        NSDictionary * results = arg;
        for (NSDictionary *jsonobject in results) {
            NSDictionary *fields = jsonobject[@"profile"][0][@"fields"];
            Person *friend = [[Person alloc] init];
            friend.firstName = fields[@"profile_first"];
            friend.lastName = fields[@"profile_last"];
            if (![fields[@"profile_pic"]  isEqual: @""]) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://qurious.info:8080/%@", fields[@"profile_pic"]]];
                friend.profPic = url;
            }
            friend.email = fields[@"user_email"];
            friend.bio = fields[@"user_bio"];
            friend.userID = [fields[@"user"] intValue];
//            if (friend.userID == myID) {
//                me = friend;
//            }
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
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
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
    
    
    
    view = (UITableView *)self.view;

    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    for (Person* p in [_objects reverseObjectEnumerator]) {
        if ([p.firstName rangeOfString:searchText].location == NSNotFound && [p.lastName rangeOfString:searchText].location == NSNotFound && [p.username rangeOfString:searchText].location == NSNotFound) {
            // do nothing in this case
            if ([_searchObjects containsObject:p]) {
                [_searchObjects removeObject:p];
            }
        } else {
            if (![_searchObjects containsObject:p]) {
                [_searchObjects insertObject:p atIndex:0];
            }
        }
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchObjects.count;
        
    } else {
        return _objects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView
//                             dequeueReusableCellWithIdentifier:@"Cell"
//                             forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Person *friend = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friend = [_searchObjects objectAtIndex:indexPath.row];
    } else {
        friend = [_objects objectAtIndex:indexPath.row];
    }
    
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


- (Person*) findPersonForName:(NSString*)name {
    for (Person* p in _objects) {
        if ([p.firstName isEqualToString:name] || [p.lastName isEqualToString:name] || [p.username isEqualToString:name]) {
            return p;
        }
    };
        
    return nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        UITableViewCell* cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
        Person* friend = [self findPersonForName:cell.textLabel.text];
        [[segue destinationViewController] setDetailItem:friend];
    }

}

@end

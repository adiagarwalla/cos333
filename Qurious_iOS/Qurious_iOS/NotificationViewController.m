//
//  NotificationViewController.m
//  Qurious_iOS
//
//  Created by Aditya Agarwalla on 4/23/14.
//  Copyright (c) 2014 Qurious. All rights reserved.
//

#import "NotificationViewController.h"
#import "SWRevealViewController.h"
#import "QApiRequests.h"
#import "Person.h"
#import "Notification.h"
#import "ViewController.h"
#import "SidebarViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize detailItem = _detailItem;

static NSMutableArray * _notifications;
static UITableViewController * _self;
static int _userID;
static UIRefreshControl *refresh1;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

void getNotificationsCallback(id arg){
    NSLog(@"Get notifications JSON: %@", arg);
    printf("%s", "Fetching notifications");
    _notifications = [[NSMutableArray alloc]init];
    if ([arg isKindOfClass: [NSArray class]]) {
        for (NSDictionary * notification in (NSArray *)arg) {
            Notification * myNotification = [[Notification alloc] init];
            NSString* tmp = notification[@"fields"][@"attachedjson"];
            myNotification.notificationID = [notification[@"pk"]intValue];
            myNotification.session_token = [tmp substringWithRange:NSMakeRange(16, [tmp length] - 18)];
            myNotification.from = notification[@"f"];
            myNotification.message = notification[@"fields"][@"message"];
            if ([notification[@"fields"][@"is_expired"] intValue] == 0) myNotification.isExpired = NO;
            [_notifications insertObject:myNotification atIndex:0];
        }
    }
    [_self.tableView reloadData];
    [refresh1 endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger myID = [defaults integerForKey:@"myID"];
    _userID = myID;
    NSLog(@"Get user id: %d", _userID);
    
    [QApiRequests getNotification:_userID andCallback: &getNotificationsCallback];

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
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    _self = self;
    refresh1 = [[UIRefreshControl alloc] init];
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh1 addTarget:self action:@selector(viewWillAppear:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh1;
    [self viewWillAppear:TRUE];
    //_notifications = [self.detailItem notifications];
    
}
- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Notification * notification = _notifications[indexPath.row];
    cell.textLabel.text = notification.message;
    if (notification.isExpired) cell.textLabel.textColor = [UIColor lightGrayColor];
    else cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

void deleteNotificationCallback (id arg){
    NSLog(@"Delete notification callback %@", arg);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _notifications = [_notifications mutableCopy];
        int notificationID = [[_notifications objectAtIndex:indexPath.row] notificationID];
        [_notifications removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [QApiRequests deleteNotification: notificationID andCallback: &deleteNotificationCallback];
        

    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"notification"]) {
//        NSLog(@"Lol");
//        SidebarViewController *destViewController = segue.destinationViewController;
//        destViewController.count = [NSString stringWithFormat:@"%.0lu", (unsigned long)_notifications.count];
//        NSLog(@"Get notifications JSON: %d", _notifications.count);
//    }
    
    
    if ([segue.identifier isEqualToString:@"acceptSession"]) {
        NSLog(@"Lol");

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Notification * notification = _notifications[indexPath.row];
    NSString* kSession = notification.session_token;
    [ViewController setSessionToken: kSession];
    }
}

/*- (IBAction)cancel:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"SessionOver"]) {
        ViewController *sessionController = [segue sourceViewController];
        [sessionController.session disconnect];
    }
    
}*/

@end

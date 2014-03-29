//
//  QuriousViewController.m
//  qurious 333
//
//  Created by Qurious iOS on 3/29/14.
//  Copyright (c) 2014 Qurious iOS Team. All rights reserved.
//

#import "QuriousViewController.h"

@interface QuriousViewController ()

@end

@implementation QuriousViewController

NSArray* tableData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    tableData = [NSArray arrayWithObjects:@"Abhinav Khanna", @"Helen Yu", @"Johnathon Kwok", @"Aditya Agarwalla", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

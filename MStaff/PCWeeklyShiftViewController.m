//
//  PCWeeklyShiftViewController.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/21/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCWeeklyShiftViewController.h"
#import "PCCellWeeklyShift.h"

@interface PCWeeklyShiftViewController ()

@end

@implementation PCWeeklyShiftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *bg = [[UIView alloc] init];
    [bg setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:210.0/255.0 blue:216.0/255.0 alpha:1.0]];
    [bg setFrame:self.view.frame];
    
    self.tableView.backgroundView = bg;
    
    [self.tableView registerClass:[PCCellWeeklyShift class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_objects objectAtIndex:section] objectForKey:@"shifts"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_objects objectAtIndex:section] objectForKey:@"dateString"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCCellWeeklyShift *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dict = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"shifts"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];
    
    if ([[dict objectForKey:@"active"] boolValue])
    {
        [cell setActive:YES];
        [cell.imageView setImage:[UIImage imageNamed:@"alert"]];
    }
    else
    {
        [cell setActive:NO];
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

@end

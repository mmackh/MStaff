//
//  PCFirstViewController.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCFirstViewController.h"

#import "PCWhenIWorkDateHelper.h"

@interface PCFirstViewController ()
{
    UIRefreshControl *refreshControl;
    
    NSArray *objects;
    
    RequestByStaff staff;
    
    NSString *startDate;
    NSString *endDate;
    NSDate *rawDate;
    
    NSString *selectedName;
}

@end

@implementation PCFirstViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toDatePicker"])
    {
        PCDatePickerViewController *dvc = segue.destinationViewController;
        [dvc setDelegate:self];
    }
    
    if ([segue.identifier isEqualToString:@"toWeekShift"])
    {
        PCWeeklyShiftViewController *wsc = segue.destinationViewController;
        wsc.title = selectedName;
        [wsc setObjects:sender];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForDateCorrection) name:UIApplicationDidBecomeActiveNotification object:nil];

    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadSchedule) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    
    _whenIWork = [[PCWhenIWorkController alloc] init];
    [_whenIWork setDelegate:self];
    [_whenIWork loginOnBehalf:RequestByStaffDesk];
    
    _whenIWorkShiftParser = [[PCWhenIWorkShiftParser alloc] init];
    [_whenIWorkShiftParser setDelegate:self];
    
    [_tableView registerClass:[PCCell class] forCellReuseIdentifier:@"Cell" ];
    
    staff = RequestByStaffDesk;
    
    startDate = [PCWhenIWorkDateHelper today];
    endDate = [PCWhenIWorkDateHelper tomorrow];
    rawDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self adjustForDateCorrection];
}

- (void)adjustForDateCorrection
{
    NSDate *now = [NSDate date];
    if (![PCWhenIWorkDateHelper date:rawDate IsOnDate:now])
    {
        //App resets when you open it on a different day
        startDate = [PCWhenIWorkDateHelper today];
        endDate = [PCWhenIWorkDateHelper tomorrow];
        rawDate = now;
        [self loadSchedule];
    }
}

- (void)loadSchedule
{
    [_whenIWork requestScheduleOnBehalf:staff From:startDate Until:endDate];
}

- (void)whenIWorkLogInProcessSuccess:(BOOL)success
{
    if (success)
    {
        [self loadSchedule];
    }
}

- (void)whenIWorkScheduleLoaded:(NSDictionary *)schedule
{
    [_whenIWorkShiftParser setArrayToParse:schedule];
    [_whenIWorkShiftParser parseMultipleShifts];
}

- (void)whenIWorkScheduleLoaded:(NSDictionary *)schedule ID:(int)userID
{
    [_whenIWorkShiftParser setArrayToParse:schedule];
    [_whenIWorkShiftParser parseSingleShift];
}

- (void)whenIWorkMultipleShiftsParsed:(NSArray *)shifts
{
    [refreshControl endRefreshing];
    objects = shifts;
    [_tableView reloadData];
}

- (void)whenIWorkSingleShiftParsed:(NSArray *)shift
{
    [self.view setUserInteractionEnabled:YES];
    [self performSegueWithIdentifier:@"toWeekShift" sender:shift];
}

#pragma mark -
#pragma mark TableView Delegate & Datasource

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [objects count];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[objects objectAtIndex:section] objectForKey:@"shifts"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[objects objectAtIndex:section] objectForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PCCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *dict = [[[objects objectAtIndex:indexPath.section] objectForKey:@"shifts"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text = [dict objectForKey:@"detail"];
    
    if ([[dict objectForKey:@"active"] boolValue])
    {
        [cell.lightOverlay setBackgroundColor:[UIColor colorWithRed:1.00f green:0.96f blue:0.45f alpha:0.20f]];
        [cell.imageView setImage:[UIImage imageNamed:@"alert"]];
    }
    else
    {
        [cell.lightOverlay setBackgroundColor:[UIColor clearColor]];
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    selectedName = [[[[objects objectAtIndex:indexPath.section] objectForKey:@"shifts"] objectAtIndex:indexPath.row] objectForKey:@"detail"];
    [self.view setUserInteractionEnabled:NO];
    [_whenIWork requestScheduleOnBehalf:staff ID:[[[[[objects objectAtIndex:indexPath.section] objectForKey:@"shifts"] objectAtIndex:indexPath.row] objectForKey:@"user_id"] intValue] From:startDate Until:[PCWhenIWorkDateHelper offsetDateStringByDays:8 FromDateString:startDate InputFormat:kWhenIWorkShiftRequestTimeStampFormat]];
}

#pragma mark -
#pragma mark Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)positionChanged:(id)sender
{
    UISegmentedControl *sC = sender;
    
    switch (sC.selectedSegmentIndex) {
        case 0:
        {
            staff = RequestByStaffDesk;
            if ([_whenIWork canRequestScheduleOnBehalf:RequestByStaffDesk])
            {
                [self loadSchedule];
            }
            else
            {
                [_whenIWork loginOnBehalf:RequestByStaffDesk];
            }
            break;
        }
        case 1:
        {
            staff = RequestByStaffService;
            if ([_whenIWork canRequestScheduleOnBehalf:RequestByStaffService])
            {
                [self loadSchedule];
            }
            else
            {
                [_whenIWork loginOnBehalf:RequestByStaffService];
            }
            break;
        }
        case 2:
        {
            staff = RequestByStaffKitchen;
            if ([_whenIWork canRequestScheduleOnBehalf:RequestByStaffKitchen])
            {
                [self loadSchedule];
            }
            else
            {
                [_whenIWork loginOnBehalf:RequestByStaffKitchen];
            }
            break;
        }
        case 3:
        {
            staff = RequestByStaffCleaning;
            if ([_whenIWork canRequestScheduleOnBehalf:RequestByStaffCleaning])
            {
                [self loadSchedule];
            }
            else
            {
                [_whenIWork loginOnBehalf:RequestByStaffCleaning];
            }
        }
        break;
    }
    
}

#pragma mark -
#pragma mark PCDatePicker Delegate

- (NSDate *)datePickerInitWithDate
{
    return rawDate;
}

- (void)datePickerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)datePickerDidPickStartDate:(NSString *)start EndDate:(NSString *)end RawDate:(NSDate *)raw
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    startDate = start;
    endDate = end;
    rawDate = raw;
    
    [self loadSchedule];
}

@end

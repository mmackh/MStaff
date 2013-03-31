//
//  PCFirstViewController.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCWhenIWorkController.h"
#import "PCWhenIWorkShiftParser.h"
#import "PCDatePickerViewController.h"
#import "PCWeeklyShiftViewController.h"

#import "PCCell.h"

@interface PCFirstViewController : UIViewController <PCWhenIWorkDelegate, PCWhenIWorkShiftParserDelegate, UITableViewDataSource, UITableViewDelegate, PCDatePickerDelegate>

@property (strong, nonatomic) PCWhenIWorkController *whenIWork;
@property (strong, nonatomic) PCWhenIWorkShiftParser *whenIWorkShiftParser;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)positionChanged:(id)sender;

@end

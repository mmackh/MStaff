//
//  PCDatePickerViewController.h
//  MStaff
//
//  Created by Maximilian Mackh on 3/21/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCDatePickerDelegate <NSObject>

- (NSDate *)datePickerInitWithDate;

- (void)datePickerDidPickStartDate:(NSString *)start EndDate:(NSString *)end RawDate:(NSDate *)raw;
- (void)datePickerDidCancel;

@end

@interface PCDatePickerViewController : UIViewController

@property (strong, nonatomic) id <PCDatePickerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

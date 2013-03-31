//
//  PCCell.m
//  MStaff
//
//  Created by Maximilian Mackh on 3/20/13.
//  Copyright (c) 2013 Professional Consulting & Trading GmbH. All rights reserved.
//

#import "PCCell.h"

@implementation PCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _lightOverlay = [[UIView alloc] initWithFrame:self.contentView.frame];
        [_lightOverlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_lightOverlay setBackgroundColor:[UIColor colorWithRed:1.00f green:0.96f blue:0.45f alpha:0.20f]];
        [self addSubview:_lightOverlay];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setActive:(BOOL)active
{
    [_lightOverlay setHidden:!active];
}

@end

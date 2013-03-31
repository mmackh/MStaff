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
        [self addSubview:_lightOverlay];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

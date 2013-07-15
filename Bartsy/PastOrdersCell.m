//
//  PastOrdersCell.m
//  Bartsy
//
//  Created by Techvedika on 7/15/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PastOrdersCell.h"

@implementation PastOrdersCell
@synthesize statusimage,title,address,no_drinks,drinkslbl;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    
        statusimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25,25)];
        [self.contentView addSubview:statusimage];
        
        title=[[UILabel alloc]initWithFrame:CGRectMake(50,2,200,30)];
        title.textAlignment=NSTextAlignmentLeft;
        title.textColor=[UIColor colorWithRed:191.0/255.0 green:187.0/255.0 blue:188.0/255.0 alpha:1.0];
        title.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:title ];
        
        address=[[UILabel alloc]initWithFrame:CGRectMake(50,27,250,25)];
        address.textAlignment=NSTextAlignmentLeft;
        address.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        address.font=[UIFont systemFontOfSize:13];
        address.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:address];
        
        no_drinks=[[UILabel alloc]initWithFrame:CGRectMake(290,2,50,30)];
        no_drinks.textAlignment=NSTextAlignmentLeft;
        no_drinks.textColor=[UIColor colorWithRed:0 green:0.686f blue:0.87f alpha:1.0];
        no_drinks.backgroundColor=[UIColor clearColor];
        no_drinks.font=[UIFont systemFontOfSize:22];
        [self.contentView addSubview:no_drinks ];
        
        drinkslbl=[[UILabel alloc]initWithFrame:CGRectMake(275,26,70,30)];
        drinkslbl.textAlignment=NSTextAlignmentLeft;
        drinkslbl.textColor=[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:145.0/255.0 alpha:1.0];
        drinkslbl.backgroundColor=[UIColor clearColor];
        drinkslbl.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:drinkslbl ];
    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
    [statusimage release];
    [title release];
    [address release];
    [no_drinks release];
    [drinkslbl release];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

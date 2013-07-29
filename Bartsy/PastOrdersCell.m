//
//  PastOrdersCell.m
//  Bartsy
//
//  Created by Techvedika on 7/15/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import "PastOrdersCell.h"

@implementation PastOrdersCell
@synthesize statusimage,title,description,lblTotalPrice,lblOrderId,lblRecepient,lblSender,lblTime,venuename,lblPickedtime;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    
        statusimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,25,25)];
        [self.contentView addSubview:statusimage];
        
        venuename=[[UILabel alloc]initWithFrame:CGRectMake(10, 3, 250, 18)];
        venuename.textAlignment=NSTextAlignmentLeft;
        venuename.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        venuename.font=[UIFont systemFontOfSize:13];
        venuename.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:venuename ];
        
        title=[[UILabel alloc]initWithFrame:CGRectMake(10, venuename.frame.origin.y+venuename.frame.size.height, 250, 15)];
        title.textAlignment=NSTextAlignmentLeft;
        title.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        title.font=[UIFont systemFontOfSize:13];
        title.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:title ];

        description=[[UILabel alloc]initWithFrame:CGRectMake(10, title.frame.origin.y+title.frame.size.height,250, 35)];
        description.textAlignment=NSTextAlignmentLeft;
        description.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        description.font=[UIFont systemFontOfSize:15];
        description.backgroundColor=[UIColor clearColor];
        description.numberOfLines=2;
        [self.contentView addSubview:description];
        
        lblTime=[[UILabel alloc]initWithFrame:CGRectMake(10, description.frame.origin.y+description.frame.size.height, 280, 15)];
        lblTime.textAlignment=NSTextAlignmentLeft;
        lblTime.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        lblTime.backgroundColor=[UIColor clearColor];
        lblTime.font=[UIFont systemFontOfSize:14];
        lblTime.tag = 1234234567;
        [self.contentView addSubview:lblTime ];
        
        lblPickedtime=[[UILabel alloc]initWithFrame:CGRectMake(10, lblTime.frame.origin.y+lblTime.frame.size.height, 280, 15)];
        lblPickedtime.textAlignment=NSTextAlignmentLeft;
        lblPickedtime.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        lblPickedtime.backgroundColor=[UIColor clearColor];
        lblPickedtime.font=[UIFont systemFontOfSize:14];
        lblPickedtime.tag = 1234234567;
        [self.contentView addSubview:lblPickedtime ];

        
        lblSender=[[UILabel alloc]initWithFrame:CGRectMake(10, lblPickedtime.frame.origin.y+lblPickedtime.frame.size.height, 280, 15)];
        lblSender.textAlignment=NSTextAlignmentLeft;
        lblSender.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        lblSender.backgroundColor=[UIColor clearColor];
        lblSender.font=[UIFont systemFontOfSize:14];
        lblSender.tag = 1234234567;
        [self.contentView addSubview:lblSender ];
        [lblSender release];
        
        lblRecepient = [[UILabel alloc]initWithFrame:CGRectMake(10, lblSender.frame.origin.y+lblSender.frame.size.height, 280, 20)];
        lblRecepient.font = [UIFont systemFontOfSize:14];
        //lblRecepient.text = [NSString stringWithFormat:@"Recipient : %@",[dictForOrder objectForKey:@"recipientNickname"]];
        lblRecepient.tag = 1234234567;
        lblRecepient.backgroundColor = [UIColor clearColor];
        lblRecepient.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0] ;
        lblRecepient.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lblRecepient];
        [lblRecepient release];
        
        lblTotalPrice= [[UILabel alloc]initWithFrame:CGRectMake(270, 2, 200, 15)];
        lblTotalPrice.font=[UIFont systemFontOfSize:11];
        lblTotalPrice.textColor=[UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        lblTotalPrice.backgroundColor=[UIColor clearColor];
        lblTotalPrice.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lblTotalPrice];
        [lblTotalPrice release];
        
        lblOrderId = [[UILabel alloc]initWithFrame:CGRectMake(10, lblRecepient.frame.origin.y+lblRecepient.frame.size.height-2, 280, 20)];
        lblOrderId.font = [UIFont systemFontOfSize:14];
        lblOrderId.backgroundColor = [UIColor clearColor];
        lblOrderId.textColor = [UIColor colorWithRed:204.0/225.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        lblOrderId.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:lblOrderId];
        [lblOrderId release];

    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
    
       
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

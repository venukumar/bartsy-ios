//
//  MyAnnotation.m
//  MapView
//
//  Created by Nagendra on 18/12/12.
//  Copyright (c) 2012 Nagendra. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate,title,subtitle,tagValue;

-(id)initWithCoordinate:(CLLocationCoordinate2D)location title:(NSString*)strTitle subtitle:(NSString*)strSubTitle
{
    self.coordinate=location;
    self.title=strTitle;
    self.subtitle=strSubTitle;
    return self;
}
@end

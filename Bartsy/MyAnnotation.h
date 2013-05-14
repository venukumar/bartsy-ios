//
//  MyAnnotation.h
//  MapView
//
//  Created by Nagendra on 18/12/12.
//  Copyright (c) 2012 Nagendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface MyAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSInteger tagValue;
}
@property(nonatomic,assign)NSInteger tagValue;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)NSString *title;
@property(nonatomic,retain)NSString *subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)location title:(NSString*)strTitle subtitle:(NSString*)strSubTitle;

@end

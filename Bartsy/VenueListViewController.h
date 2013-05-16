//
//  VenueListViewController.h
//  Bartsy
//
//  Created by Sudheer Palchuri on 14/05/13.
//  Copyright (c) 2013 TechVedika Software Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyAnnotation.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"

@interface VenueListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *arrVenueList;
    CLLocationCoordinate2D currentLocaion;
}
-(void)reloadMapView;
@end
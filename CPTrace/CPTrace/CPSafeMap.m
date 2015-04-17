//
//  CPSafeMap.m
//  CPTrace
//
//  Created by li xiao on 15-3-26.
//  Copyright (c) 2015年 buptLab618. All rights reserved.
//

#import "CPSafeMap.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <QuartzCore/QuartzCore.h>
#define APIKey      @"5edf396e3b9ed4b4687e28787c1bd1cb"

@interface CPSafeMap ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    UIButton *_locationButton;
    AMapSearchAPI *_search;
   // CLLocation *_currentLocation;
    UILabel *_label;
    NSArray *_pois;
    NSMutableArray *_annotations;
    int tag;
    bool tag_2;
}

@end

@implementation CPSafeMap

@synthesize currentLocation = _currentLocation;


#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initTextField
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 80, 40)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 5;
    _label.text = @"选择城市";
    
    [_mapView addSubview:_label];
    
}

-(void)initAttributes
{
    _annotations = [NSMutableArray array];
    _pois = nil;
    tag = 0;
}



- (void)initControls
{
    //定位按钮
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(20, CGRectGetHeight(_mapView.bounds)- 60, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    
    [_locationButton addTarget:self action:@selector(locateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationButton setImage:[UIImage imageNamed:@"location_no1"] forState:UIControlStateNormal];
    
    [_mapView addSubview:_locationButton];
    
    /*
     //搜索按钮
     UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     searchButton.frame = CGRectMake(80, CGRectGetHeight(_mapView.bounds)-80, 40,40);
     searchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
     searchButton.backgroundColor = [UIColor whiteColor];
     searchButton.layer.cornerRadius = 5;
     [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
     [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
     [_mapView addSubview:searchButton];
     
     */
    
    //城市选择按钮
    UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cityButton.frame = CGRectMake(30, 5, 95,40);
    cityButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    cityButton.backgroundColor = [UIColor whiteColor];
    cityButton.layer.cornerRadius = 5;
    [cityButton setImage:[UIImage imageNamed:@"select_city"] forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(showLocateView:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:cityButton];
    
    
    
}

- (void)initMapView
{
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,rect.size.height,CGRectGetWidth(self.view.bounds),CGRectGetHeight(self.view.bounds)-49-rect.size.height)];
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x,10);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x+60,CGRectGetHeight(_mapView.bounds) - 50);
    
    [self.view addSubview:_mapView];
    //开启定位
    _mapView.showsUserLocation = YES;
    //手势操作
    _mapView.zoomEnabled = YES;
    _mapView.scrollEnabled = YES;
    _mapView.rotateEnabled = YES;
    _mapView.rotateCameraEnabled = YES;
    
}


- (void)initSearch
{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // NSLog(@"tag :%i",tag);
    NSLog(@"userLocation: %@", userLocation.location);
    self.currentLocation = [userLocation.location copy];
 
    if(tag == 0 && tag_2)
    {
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
        
            [self searchAction];
            tag_2 = false;
        
        
    }
    
}





#pragma mark - Action

- (void)locateAction
{
    if(_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    tag = 0;
    tag_2 = true;
    
}


- (void)reGeoAction
{
    if(_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
    
    
}

//当前用户定位下搜索
-(void)searchAction
{
    //清空annotation
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
    
    if(_currentLocation == nil || _search ==nil)
    {
        NSLog(@"search failed");
        return;
    }
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    
    request.keywords = @"肯德基";
    [_search AMapPlaceSearch:request];
    
}

//选择城市后搜索
-(void)searchActionByLatitude:(double)latitude ByLongitude:(double)longitude
{
    //清空annotation
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
    
    if(_search ==nil)
    {
        NSLog(@"search failed");
        return;
    }
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    
    request.keywords = @"肯德基";
    [_search AMapPlaceSearch:request];
    
}

#pragma mark - MAMapViewDelegate

-(void) mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if(mode == MAUserTrackingModeNone)
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_no1"] forState:UIControlStateNormal];
    }
    else
    {
        [_locationButton setImage:[UIImage imageNamed:@"location_yes1"] forState:UIControlStateNormal];
        _label.text = @"选择城市";
    }
    
}

-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{    // 选中定位annotation的时候进行逆地理编码查询
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        [self reGeoAction];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    tag_2 = true;
    tag=0;
    
}

//在MAMapView的回调函数中，取得或创建annotationView
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIdentifier = @"annotationReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        if(annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        
        annotationView.canShowCallout = YES;
        return annotationView;
        
    }
    
    return nil;
    
}



#pragma mark - AMapSearchDelegate


-(void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"request :%@,error :%@",request,error);
    
}

-(void)onReGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@",response);
    NSString *title = response.regeocode.addressComponent.city;
    if (title.length == 0)
    {
        title = response.regeocode.addressComponent.province;
    }
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
    
    
}

//实现POI搜索对应的回调函数
-(void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    NSLog(@"request: %@",request);
    NSLog(@"response: %@",response);
    /*
     if(response.pois.count == 0)
     {
     return;
     }
     */
    if(response.pois.count > 0)
    {
        _pois = response.pois;
        for(AMapPOI *poi in _pois)
        {
            
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            annotation.title = poi.name;
            annotation.subtitle = poi.address;
            [_mapView addAnnotation:annotation];
            [_annotations addObject:annotation];
            
        }
        
    }
    
}

#pragma mark - SearchCityDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    NSLog(@"city:%@ lat:%f lon:%f", location.city, location.latitude, location.longitude);
    
    //You can uses location to your application.
    if(buttonIndex == 0) {
        NSLog(@"Cancel");
        tag = 1;
        tag_2 = true;
        //  [self searchAction];
        
    }else {
        NSLog(@"Select");
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(location.latitude,location.longitude);
        tag =1;
        _label.text = location.city;
        [self searchActionByLatitude:location.latitude ByLongitude:location.longitude];
        
    }
}

- (IBAction)showLocateView:(id)sender {
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    [locateView showInView:self.view];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    tag_2 = true;
	// Do any additional setup after loading the view, typically from a nib.
    [self initMapView];
    [self initControls];
    [self initSearch];
    [self initAttributes];
    [self initTextField];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

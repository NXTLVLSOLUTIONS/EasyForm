//
//  TSBathroomAnnotation.h
//  ClusterDemo
//
//  Created by Adam Share on 1/13/15.
//  Copyright (c) 2015 Applidium. All rights reserved.
//

#import "ADBaseAnnotation.h"

@interface DoctorAnnotation : ADBaseAnnotation
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *speciality;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic) CLLocationDegrees latitude;
@end

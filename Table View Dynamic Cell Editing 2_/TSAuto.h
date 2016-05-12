//
//  TSAuto.h
//  Table View Dynamic Cell Editing 2_
//
//  Created by Mac on 18.12.15.
//  Copyright © 2015 Tsvigun Alexandr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAuto : NSObject

@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *color;
@property (assign, nonatomic) NSInteger age;

+(TSAuto *)randomAuto;

@end

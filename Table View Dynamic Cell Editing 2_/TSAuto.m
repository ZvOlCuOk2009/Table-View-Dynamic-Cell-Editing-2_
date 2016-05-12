//
//  TSAuto.m
//  Table View Dynamic Cell Editing 2_
//
//  Created by Mac on 18.12.15.
//  Copyright © 2015 Tsvigun Alexandr. All rights reserved.
//

#import "TSAuto.h"

@implementation TSAuto

static NSString *avto [] = {
    
    @"Buick", @"Cadillac", @"Chevrolet", @"Chrysler", @"Dodge", @"Ford", @"GMC", @"Jeep", @"Lincoln", @"Tesla", @"Nissan", @"Audi", @"Renault", @"Bugatti", @"KIA", @"BMW", @"Borgward", @"Neoplan", @"Opel", @"Porsche", @"Honda", @"Mazda", @"Mithubishi", @"Volkswagen", @"Toyota", @"Hummer", @"Maybach", @"MAN", @"Mercedes-Benz", @"Multicar", @"Aston Martin", @"Bentley", @"Peugeot", @"Jaguar", @"Land Rover"
};

static NSString *color [] = {
    
    @"Black", @"Red", @"Chrome", @"Green", @"White", @"Blue", @"Gray", @"Brown", @"Orange", @"Purple", @"White", @"Yellow"
};

+(TSAuto *)randomAuto; {
    
    NSInteger rndAvto = arc4random() % 35;
    NSString *randomAvto = (NSString *)avto[rndAvto];
    
    NSInteger rndColor = arc4random() % 12;
    NSString *randomColor = (NSString *)color[rndColor];
    
    TSAuto *avto = [[TSAuto alloc] init];
    avto.model = randomAvto;
    avto.color = randomColor;
    avto.age = (arc4random() % 30) + 1985;
    
    return avto;
};

@end

//
//  VIRStudent.h
//  SearchTableHomeWork
//
//  Created by Administrator on 03.02.14.
//  Copyright (c) 2014 Konstantin Kokorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIRStudent : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDay;

+ (VIRStudent *)newStudent;


@end

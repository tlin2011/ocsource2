//
//  Person.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "Person.h"

@implementation Person
+ (Person *)personByJson:(NSDictionary *)json {
    Person *person = [[Person alloc] init];
    person.uid = [NSString stringWithFormat:@"%ld", (long)[json[@"uid"] integerValue]];
    person.name = [NSString stringWithFormat:@"%@", json[@"name"]];
    person.imageId = [NSString stringWithFormat:@"%ld", (long)[json[@"tx_id"] integerValue]];
    
    return person;
}
@end

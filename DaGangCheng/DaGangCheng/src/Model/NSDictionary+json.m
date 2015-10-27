//
//  NSDictionary+json.m
//  DaGangCheng
//
//  Created by huaxo on 15-5-13.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "NSDictionary+json.h"

@implementation NSDictionary (json)

- (NSString*)JsonString
{
    if (!self) {
        return nil;
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

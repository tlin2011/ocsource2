//
//  zbmsg.h
//  zbmsg
//
//  Created by huaxo2 on 15/8/4.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zbmsg : NSObject


-(NSString*) decryptUseDES:(NSData*)cipherData;


-(NSData *) encryptUseDES:(NSString *)clearText;

@end

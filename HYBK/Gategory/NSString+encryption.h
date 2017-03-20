//
//  NSString+encryption.h
//  HYBK
//
//  Created by 钟亮 on 2017/2/3.
//  Copyright © 2017年 zhongliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encryption)
- (NSString *)stringToMD5:(NSString *)str;
- (NSString *)stringToBASE64:(NSString *)str;
-(NSString *)base64DecodeString:(NSString *)str;
@end

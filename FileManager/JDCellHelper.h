//
//  JDCellHelper.h
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDCellHelper : NSObject

+ (NSString*) getFormattedDateFor: (NSDate*) date;
+ (NSString*) getFormattedStringForSize: (unsigned long long) fileSize;
+ (NSString *)getFolderSizeForPath:(NSString *)folderPath;

@end

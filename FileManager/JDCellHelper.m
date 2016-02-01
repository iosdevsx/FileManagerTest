//
//  JDCellHelper.m
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import "JDCellHelper.h"

@implementation JDCellHelper

+ (NSString*) getFormattedDateFor: (NSDate*) date;
{
    static NSDateFormatter* formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy hh:mm a"];
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString*) getFormattedStringForSize: (unsigned long long) fileSize;
{
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeStr;
}

+ (NSString *)getFolderSizeForPath:(NSString *)folderPath
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [fileAttributes fileSize];
    }
    
    return [self getFormattedStringForSize:folderSize];
}

@end

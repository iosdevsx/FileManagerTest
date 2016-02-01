//
//  JDFolderCell.h
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDFolderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* folderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *folderSizeLabel;

@end

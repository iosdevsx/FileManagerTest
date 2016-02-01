//
//  JDFileCell.h
//  FileManager
//
//  Created by jsd on 28.12.15.
//  Copyright © 2015 jsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* fileNamelabel;
@property (weak, nonatomic) IBOutlet UILabel* fileDateModifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel* fileSizeLabel;

@end

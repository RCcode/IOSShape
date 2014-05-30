//
//  PRJ_MoreTableViewCell.h
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-21.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

@interface PHO_AboutUsTableViewCell : UITableViewCell

//@property (nonatomic ,strong) UIImageView *contentImageView;
//@property (nonatomic ,strong) UILabel *contentLabel;

+ (instancetype)moreTabelViewCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

- (void)setImageName:(NSString *)imageName AndTitle:(NSString *)title;

@end

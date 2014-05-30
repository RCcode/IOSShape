//
//  PRJ_MoreTableViewCell.m
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-21.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "PHO_AboutUsTableViewCell.h"
#import "CMethods.h"

@interface PHO_AboutUsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PHO_AboutUsTableViewCell


+ (instancetype)moreTabelViewCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"AboutUsTableViewCell";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [tableView registerNib:[UINib nibWithNibName:@"PHO_AboutUsTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    });
    return [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    //延时取消选中
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super setSelected:NO animated:animated];
    });
}

- (void)setImageName:(NSString *)imageName AndTitle:(NSString *)title{
    
    _iconView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
}

@end

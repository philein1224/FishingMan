//
//  FMCommentListCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMCommentListCell.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"

@interface FMCommentListCell()

@property (weak, nonatomic) IBOutlet UIButton *fromAvatar;
@property (weak, nonatomic) IBOutlet UILabel *fromUserNameLabel;

@property (weak, nonatomic) IBOutlet UIView *toContentLabelContainer;
@property (weak, nonatomic) IBOutlet UIButton *toUserNameButton;
@property (weak, nonatomic) IBOutlet UILabel *toContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromContentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceToToContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateTimeAddLabel;

@end

@implementation FMCommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)reloadData{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.commentModel.created / 1000];
    _dateTimeAddLabel.text = [NSString stringWithFormat:@"%@", [ZXHTool dateAndTimeToMinuteStringFromDate:date]];
    
    [_toUserNameButton setTitle:self.commentModel.toUserName forState:UIControlStateNormal];
    _fromContentLabel.text = self.commentModel.content;
    [self setupToName:self.commentModel.toUserName ToContentLabelStyle:self.commentModel.toContent];
    
    if([ZXHTool isEmptyString:self.commentModel.toContent]){
        self.toContentLabelContainer.hidden = YES;
        
        self.spaceToToContentLabel.priority = 250;
        self.spaceToNameLabel.priority = 750;
    }
    else{
        self.toContentLabelContainer.hidden = NO;
        
        self.spaceToNameLabel.priority = 250;
        self.spaceToToContentLabel.priority = 750;
    }
}

- (void)setupToName:(NSString *)name ToContentLabelStyle:(NSString *)content{
    
    double fontSizeOffset = 0.0;
    NSString * info = @"";
    NSString * fontName = self.toContentLabel.font.fontName;
    CGFloat fontSize = self.toContentLabel.font.pointSize;
    
    NSDictionary* style = @{@"size":[UIFont fontWithName:fontName size:fontSize - fontSizeOffset],
                            @"color":[UIColor clearColor],@"color1":[UIColor darkGrayColor]};
    
    if([ZXHTool isEmptyString:name]){
        name = @"围观者";
    }
    
    info = [NSString stringWithFormat:@"<size><color>%@:</color></size><size><color1>%@</color1></size>", name, content];
    
    self.toContentLabel.attributedText = [info attributedStringWithStyleBook:style];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)toUserNameButtonAction:(id)sender {
    
    if(self.actionBlock){
        self.actionBlock(CommentActionTypeOpenUserPage, self.commentModel);
    }
}

- (IBAction)commentButtonAction:(id)sender {

    if(self.actionBlock){
        self.actionBlock(CommentActionTypeReplay, self.commentModel);
    }
}

- (IBAction)likeButtonAction:(id)sender {
    
    if(self.actionBlock){
        self.actionBlock(CommentActionTypePraise, self.commentModel);
    }
}

@end

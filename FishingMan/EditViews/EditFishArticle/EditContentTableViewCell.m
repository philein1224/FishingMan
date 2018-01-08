//
//  EditContentTableViewCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditContentTableViewCell.h"

@interface EditContentTableViewCell()<UITextViewDelegate>
{
    float cellHeight;
}

@property (assign, nonatomic) EditContentType contentType;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextView  *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation EditContentTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.contentTextView.delegate = self;
    
//    if(self.contentType == EditContentTextType){
//        
//        self.contentTextView.hidden = NO;
//        self.contentImageView.hidden = YES;
//    }
//    else if(self.contentType == EditContentImageType){
//        self.contentTextView.hidden = YES;
//        self.contentImageView.hidden = NO;
//    }
//    else{
//        self.contentTextView.hidden = YES;
//        self.contentImageView.hidden = YES;
//    }
}
+ (float)cellHeight:(float)height{
    
    return height;
}

- (BOOL)closeKeyboard{
    if([self.contentTextView isFirstResponder]){
        [self.contentTextView resignFirstResponder];
        return YES;
    }
    return NO;
}

- (void)reloadData{
    
    if(_editModel.editContentType == EditContentTypeImage){
        
        self.contentTextView.hidden = YES;
        self.contentImageView.hidden = NO;
        self.contentImageView.image = self.editModel.image;
    }
    
    else if(_editModel.editContentType == EditContentTypeText){
        
        self.contentTextView.layer.borderWidth = 0.5;
        self.contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.contentTextView.hidden = NO;
        self.contentImageView.hidden = YES;
        self.contentTextView.text = self.editModel.text;
        
        self.placeHolderLabel.text = @"";
        self.placeHolderLabel.hidden = YES;
    }
    
    else{
        self.contentTextView.hidden = YES;
        self.contentImageView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

#pragma mark UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeHolderLabel.text = @"请输入您的分享";
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.text = @"";
        self.placeHolderLabel.hidden = YES;
    }
}
@end

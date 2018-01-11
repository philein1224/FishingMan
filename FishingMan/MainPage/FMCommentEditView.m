//
//  FMCommentEditView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/19.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMCommentEditView.h"

@interface FMCommentEditView ()
{
    float commentViewHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton   *sendButton;
@property (weak, nonatomic) IBOutlet UIButton   *qqExpressionButton;

@end

@implementation FMCommentEditView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    commentViewHeight = ZXHScreenHeight;//160;
    
    //利用通知中心监听键盘的显示和消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self addGestureRecognizer:pan];
}

- (void)closeKeyboard{
    
    if(self.commentEditViewStatusBlock){
        self.commentEditViewStatusBlock(NO);
    }
    
    [_commentTextField resignFirstResponder];
    [self removeFromSuperview];
}

+ (instancetype)shareCommentViewWithTarget:(id)target
                                  callback:(CommentEditViewStatusBlock) statusBlock
                                  callback:(CommentEditViewSendBlock) sendBlock;{
    
    FMCommentEditView *commentView = [[[NSBundle mainBundle]loadNibNamed:@"FMCommentEditView" owner:self options:nil] firstObject];
    
    commentView.supper = target;
    commentView.commentEditViewStatusBlock = statusBlock;
    commentView.commentEditViewSendBlock = sendBlock;
    
    commentView.frame = CGRectMake(0,
                                   ZXHScreenHeight - commentView->commentViewHeight,
                                   ZXHScreenWidth, commentView->commentViewHeight);
    
    [commentView.commentTextField becomeFirstResponder];
    
    commentView.commentTextField.layer.cornerRadius = 3;
    commentView.commentTextField.layer.masksToBounds = YES;
    commentView.commentTextField.layer.borderWidth = 0.5;
    commentView.commentTextField.layer.borderColor = ZXHColorHEX(@"EFEFF4", 1).CGColor;
    
    [((UIViewController *)target).view addSubview:commentView];
    
    /*** 背景高斯模糊 ***/
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [commentView.bgImageView addSubview:effectView];
    
    return commentView;
}

- (void)dealloc {
    
    CLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
}

- (IBAction)sendButtonAction:(id)sender {
    
    if([ZXHTool isEmptyString:self.commentTextField.text]){
        [CDTopAlertView showMsg:@"内容不能为空" isErrorState:YES];
        return;
    }
    
    if(self.commentEditViewSendBlock){
        
        self.commentEditViewSendBlock(self.commentTextField.text);
    }
    
    [self closeKeyboard];
}

- (IBAction)cancellButtonAction:(id)sender {
    
    [self closeKeyboard];
}

- (void)handleKeyBoardAction:(NSNotification *)notification {
    NSLog(@"%@",notification);
    
    //1、计算动画前后的差值
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat detalY = endFrame.origin.y - beginFrame.origin.y;
    
    NSLog(@"%f, %f", self.frame.origin.y, detalY);
    
    //2、根据差值更改_textView的高度
    CGFloat frame = self.frame.origin.y;
    frame += detalY;
    
    //关闭时要做隐藏
    if (detalY > 0) {
        frame += commentViewHeight;
    }
    
    self.frame = CGRectMake(0, frame, ((FMArticleDetailViewController *)self.supper).view.frame.size.width, commentViewHeight);
    
}
@end

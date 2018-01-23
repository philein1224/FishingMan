//
//  FMShareView.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMShareView.h"
#import "UIImageView+WebCache.h"
#import "FMShareCollectionCell.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "ZXHWKWebViewController.h"

#define kRowHeight  72.00 * ZXHRatioWithReal375

@interface FMShareView (){
    
    NSMutableArray *shareTypeArray;
}

@property (weak, nonatomic) IBOutlet UIImageView      *alphaBGImageView;
@property (weak, nonatomic) IBOutlet UIView           *alphaBGView;
@property (weak, nonatomic) IBOutlet UIImageView      *shareAdImgView;
@property (weak, nonatomic) IBOutlet UICollectionView *shareCollectionView;
@property (weak, nonatomic) IBOutlet UIView           *advertiseFlag;       //广告标签

@end

@implementation FMShareView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    /*** 组装数组 ***/
    [self setupShareTypeArray];
    
    /*** 点击空白区域关闭视图 ***/
    UITapGestureRecognizer *tap0Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeShareView)];
    [self.alphaBGView addGestureRecognizer:tap0Recognizer];
    
    /*** 注册cell ***/
    [self.shareAdImgView sd_setImageWithURL:nil placeholderImage:ZXHImageName(@"shareAd.jpg")];
    
    /*** 注册cell ***/
    [self.shareCollectionView registerNib:[UINib nibWithNibName:@"FMShareCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FMShareCollectionCell"];
    
    /*** 广告标签 ***/
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.advertiseFlag.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _advertiseFlag.bounds;
    maskLayer.path = maskPath.CGPath;
    _advertiseFlag.layer.mask = maskLayer;
    
    /*** 背景高斯模糊 ***/
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [_alphaBGImageView addSubview:effectView];
}

- (IBAction)adTapAction:(id)sender {
    
    [self closeShareView];
    
    ZXHWKWebViewController * webViewController = [[ZXHWKWebViewController alloc] initWithNibName:@"ZXHWKWebViewController" bundle:nil];
    webViewController.urlString = @"https://www.baidu.com";
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:webViewController animated:YES completion:nil];
}

/**
 *  @author zxh, 17-03-16 16:03:29
 *
 *
 */
- (void)setupShareTypeArray{
    
    shareTypeArray = [[NSMutableArray alloc] init];
    
//        //微信
//    if([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]){
//        
//    }
//    
//        //QQ
//    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]){
//        
//    }
        
    for(int i = 0; i<=8; i++){
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        
        switch (i) {
            case 0:
                
                [tempDic setObject:@"QQ" forKey:@"keyName"];
                [tempDic setObject:@"分享_qq" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 1:
                
                [tempDic setObject:@"微信好友" forKey:@"keyName"];
                [tempDic setObject:@"分享_微信" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 2:
                
                [tempDic setObject:@"微信朋友圈" forKey:@"keyName"];
                [tempDic setObject:@"分享_朋友圈" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 3:
                
                [tempDic setObject:@"新浪微博" forKey:@"keyName"];
                [tempDic setObject:@"分享_新浪" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 4:
                
                [tempDic setObject:@"QQ空间" forKey:@"keyName"];
                [tempDic setObject:@"分享_空间" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 5:
                
                [tempDic setObject:@"短信" forKey:@"keyName"];
                [tempDic setObject:@"分享_短信" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 6:
                [tempDic setObject:@"收藏" forKey:@"keyName"];
                [tempDic setObject:@"分享_收藏" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
            case 7:
                [tempDic setObject:@"举报" forKey:@"keyName"];
                [tempDic setObject:@"分享_举报" forKey:@"keyIconName"];
                [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"keyShareType"];
                [shareTypeArray addObject:tempDic];
                break;
                
            default:
                break;
        }
        
        
    }
}

/**
 *  @author zxh, 17-04-24 17:04:08
 *
 *  执行分享操作
 *
 */
- (void)dealWithShareActionWithType:(SSDKPlatformType)platType{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    id shareImageArray = @[[UIImage imageNamed:@"videoImage.png"]];
    UIImage * shareImage = [UIImage imageNamed:@"videoImage.png"];
    NSURL * shareUrl = [NSURL URLWithString:@"http://mob.com"];
    SSDKContentType shareContentMediaType = SSDKContentTypeAuto;
    NSString * shareContentStr = @"分享的内容 http://weibo.com/";
    NSString * shareTitleStr = @"分享的标题";
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    //使用客户端分享
    [shareParams SSDKEnableUseClientShare];
    
    [shareParams SSDKSetupShareParamsByText:shareContentStr
                                     images:shareImageArray
                                        url:shareUrl
                                      title:shareTitleStr
                                       type:shareContentMediaType];
    
    if (platType == SSDKPlatformTypeSinaWeibo){
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:shareContentStr
                                                   title:shareTitleStr
                                                   image:shareImage
                                                     url:shareUrl
                                                latitude:0
                                               longitude:0
                                                objectID:nil
                                                    type:shareContentMediaType];
    }
    else if (platType == SSDKPlatformSubTypeWechatTimeline ||
             platType == SSDKPlatformSubTypeWechatSession){
        
        [shareParams SSDKSetupWeChatParamsByText:shareContentStr
                                           title:shareTitleStr
                                             url:shareUrl
                                      thumbImage:nil
                                           image:shareImage
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                                            type:shareContentMediaType
                              forPlatformSubType:platType];
    }
    
    [ShareSDK share:platType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
                
            case SSDKResponseStateSuccess:{
                
                //成功
                CLog(@"分享成功");
            }
                break;
            case SSDKResponseStateCancel:{
                
                //取消
                CLog(@"分享取消");
            }
                break;
            case SSDKResponseStateFail:{
                
                CLog(@"分享失败");
                //失败
                
//                if (!(platformType == SSDKPlatformTypeSinaWeibo && error.code == 204)) {
//                }
            }
            default:
                break;
        }
        
    }];
}

/**
 *  @author zxh, 17-03-16 16:03:59
 *
 *  关闭退出分享页面
 */
- (void)closeShareView{
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.alpha = 0.0;
    }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                     }];
}


#pragma mark UICollection View delegate 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FMShareCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FMShareCollectionCell" forIndexPath:indexPath];
    [cell loadData:shareTypeArray[indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row+1) % 4 == 0) {
        
        return CGSizeMake(288*ZXHRatioWithReal375 - kRowHeight * 3, kRowHeight);
    }else {
        
        return CGSizeMake(kRowHeight, kRowHeight);
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * shareDic = [shareTypeArray objectAtIndex:indexPath.row];
    NSInteger shareType = [[shareDic objectForKey:@"keyShareType"] integerValue];
    
    NSLog(@"选中了：%ld", shareType);
    
    SSDKPlatformType PlatformType;
    
    switch (shareType) {
        case 0:
            PlatformType = SSDKPlatformSubTypeQQFriend;
            break;
        case 1:
            PlatformType = SSDKPlatformSubTypeWechatSession;
            break;
        case 2:
            PlatformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 3:
            PlatformType = SSDKPlatformTypeSinaWeibo;
            break;
        case 4:
            PlatformType = SSDKPlatformSubTypeQZone;
            break;
        case 5:
            PlatformType = SSDKPlatformTypeSMS;
            break;
        case 6:
        {
            //收藏
            [self closeShareView];
            PlatformType = SSDKPlatformTypeUnknown;
        }
            break;
        case 7:
        {
            //举报
            if (self.articleReportBlock) {
                self.articleReportBlock();
            }
        
            [self closeShareView];
            PlatformType = SSDKPlatformTypeUnknown;
        }
            break;
        default:
            PlatformType = SSDKPlatformTypeUnknown;
        break;
    }
    
    if (PlatformType != SSDKPlatformTypeUnknown) {
        [self dealWithShareActionWithType:PlatformType];
        [self closeShareView];
    }
}

@end

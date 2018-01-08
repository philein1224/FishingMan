//
//  EditTitleView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditTitleView.h"
#import "FMDatePickerView.h"
#import "FMPickerChooseMenu.h"
#import "FMMultiChooseMenu.h"

@interface EditTitleView ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) NSDate * fishTimeDate;     //钓鱼时间

@property (weak, nonatomic) IBOutlet UIView *secondaryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondaryViewHeight;

@property (weak, nonatomic) IBOutlet UIView *buttonGroup;
@property (weak, nonatomic) IBOutlet UIButton *addMoreInfoButton;

@end

@implementation EditTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _fishTimeBtn.tag = 1000;
    _fishWaterBtn.tag = 1001;
    _fishFoodBtn.tag = 1002;
    _fishTypeBtn.tag = 1003;
    
    _fishFuncBtn.tag = 1004;
    _fishLinesBtn.tag = 1005;
    _fishPoleLengthBtn.tag = 1006;
    _fishPoleBrandBtn.tag = 1007;
    
    _allItemsShowed = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self addGestureRecognizer:tap];
}

- (void)closeKeyboard{
    
    if ([self.articleTitleTextField isFirstResponder]) {
        [self.articleTitleTextField resignFirstResponder];
    }
}

- (void)setArticleType:(FMArticleType)type{
    
    _articleType = type;
    
    //晒鱼获文章类型
    if(self.articleType == FMArticleTypeHarvest){
        
        if(self.secondaryViewHeight.constant == 0.0){
            self.secondaryViewHeight.constant = 176;
        }
        else{
            self.secondaryViewHeight.constant = 0.0;
        }
    }
    //其他类型
    else{
        self.mainView.hidden = YES;
        self.secondaryView.hidden = YES;
        self.buttonGroup.hidden = YES;
    }
}

//钓鱼时间
- (IBAction)fishTimeButtonAction:(id)sender {
    
    if(self.closeKeyboardBlock){
        self.closeKeyboardBlock();
    }
    
    ZXH_WEAK_SELF
    FMDatePickerView * datePicker = [FMDatePickerView shareWithTarget:[UIApplication sharedApplication].keyWindow mode:UIDatePickerModeDateAndTime callback:^(NSDate *date) {
        weakself.fishTimeDate = date;
        NSString * valueStr = [ZXHTool dateAndTimeToMinuteStringFromDate:date];
        [weakself.fishTimeBtn setTitle:valueStr forState:UIControlStateNormal];
    }];
    
    [datePicker show];
}

- (IBAction)topTitleButtonAction:(UIButton *)sender {
    
    if(self.closeKeyboardBlock){
        self.closeKeyboardBlock();
    }
    
    switch (sender.tag) {
        case 1000:
        {
            //不执行这里
        }
            break;
        case 1001:
        {
            //水域
            NSArray *array = [[NSArray alloc]initWithObjects:@"湖库",@"江河",@"堰塘",@"野塘",@"收费塘",@"斤塘",@"黑坑",@"农家乐",@"小溪",@"深潭",@"大海",@"其他水域",nil];
            [self chooseWithArray:array button:sender];
        }
            break;
        case 1002:
        {
            //鱼饵
            NSArray *array = [[NSArray alloc]initWithObjects:@"蚯蚓",@"老鬼",@"丸九",@"化氏",@"钓鱼王",@"龙王恨",@"天元",@"自制饵料",@"红虫",@"拟饵",@"其他",nil];
            [self chooseWithArray:array button:sender];
        }
            break;
        case 1003:
        {
            //鱼种类
            NSArray *array = [[NSArray alloc]initWithObjects:@"鲫鱼",@"鲤鱼",@"草鱼",@"鳙鲢",@"罗非鱼",@"青鱼",@"黑鱼",@"翘嘴",@"鳜鱼",@"马口鱼",@"鲶鱼",@"鲈鱼",@"鲮鱼",@"黄颡鱼",@"鳊鱼",@"白鲦",@"其他鱼种",nil];
            [self muiltychooseWithArray:array button:sender];
        }
            break;
        case 1004:
        {
            //钓法
            NSArray *array = [[NSArray alloc]initWithObjects:@"传统钓",@"台钓",@"矶钓",@"海竿钓",@"竞技钓",@"溪流钓",@"远投钓",@"夜钓",@"路亚钓",@"筏钓",@"飞蝇钓",@"冰钓",@"其他",nil];
            [self chooseWithArray:array button:sender];
        }
            break;
        case 1005:
        {
            //主线组
            NSArray *array0 = [[NSArray alloc]initWithObjects:@"0.4",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",@"2.0",@"2.5",@"3.0",@"3.5",@"4.0",@"5.0",@"6.0",@"大力马",nil];
            //子线组
            NSArray *array1 = [[NSArray alloc]initWithObjects:@"0.4",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",@"2.0",@"2.5",@"3.0",@"3.5",@"4.0",@"5.0",@"6.0",@"大力马",nil];
            NSArray * array = [[NSArray alloc] initWithObjects:array0,array1,nil];
            
            [self doublechooseWithArray:array button:sender];
        }
            break;
        case 1006:
        {
            //鱼竿长度
            NSArray *array = [[NSArray alloc]initWithObjects:@"3米内",@"3.6米",@"3.9米",@"4.5米",@"5.4米",@"6.3米",@"7.2米",@"8.1米",@"9米以上",@"其他",nil];
            [self chooseWithArray:array button:sender];
        }
            break;
        case 1007:
        {
            //鱼竿品牌
            NSArray *array = [[NSArray alloc]initWithObjects:@"本汀",@"双宝",@"迪恩",@"蓝鲨",@"宝威",@"猛攻",@"光威",@"杰诺JE&RO",@"佳钓尼",@"Heron",@"天元",@"爱路亚",@"其他品牌",nil];
            [self muiltychooseWithArray:array button:sender];
        }
            break;
        default:
        {
        }
            break;
    }
}

//单选
- (void)chooseWithArray:(NSArray *)array button:(UIButton *)button{
    
    FMPickerChooseMenu * picker = [FMPickerChooseMenu shareWithTarget:self
                                                                array:array
                                                             callback:^(NSMutableArray * arrayOfDic){

                                                                 NSString * valueStr = arrayOfDic[0];
                                                                 [button setTitle:valueStr forState:UIControlStateNormal];
                                                             }];
    [picker show];
}
//双选
- (void)doublechooseWithArray:(NSArray *)array button:(UIButton *)button{
    
    FMPickerChooseMenu * picker = [FMPickerChooseMenu shareWithTarget:self
                                                           wholeArray:array
                                                           kindTitles:[NSArray arrayWithObjects:@"主线",@"子线",nil]
                                                             callback:^(NSMutableArray *arrayOfDic) {
                                                                 
                                                                 NSString *wholeStr = @"";
                                                                 for (int i = 0; i<arrayOfDic.count; i++) {
                                                                     
                                                                     NSString * value = arrayOfDic[i];
                                                                     if(i == 0){
                                                                         wholeStr = [NSString stringWithFormat:@"主线%@", value];
                                                                     }
                                                                     else{
                                                                         wholeStr = [wholeStr stringByAppendingString:[NSString stringWithFormat:@",子线%@", value]];
                                                                     }
                                                                 }
                                                                 
                                                                 [button setTitle:wholeStr forState:UIControlStateNormal];
                                                             }];
    [picker show];
}
//多选
- (void)muiltychooseWithArray:(NSArray *)array button:(UIButton *)button{
    
    FMMultiChooseMenu * picker = [FMMultiChooseMenu shareWithTarget:self array:array callback:^(NSArray *array) {
        
        NSString * valueStr = @"";
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                NSString * str = array[i];
                if (i == (array.count-1)) {
                  valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@", str]];
                }
                else{
                  valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@,", str]];
                }
            }
        }
        else{
            valueStr = @"";
        }
        
        [button setTitle:valueStr forState:UIControlStateNormal];
    }];
    [picker show];
}

//展开更多设置
- (IBAction)addMoreInfoButtonAction:(id)sender {
    
    CLog(@"鱼获的更多详情 %f", self.secondaryViewHeight.constant);
    if(self.moreMaterialShowAndHide){
        BOOL isShow = self.secondaryViewHeight.constant > 0.0 ? NO : YES;
        self.moreMaterialShowAndHide(isShow);
    }
    
    if(self.secondaryViewHeight.constant == 0.0){
        self.secondaryViewHeight.constant = 176;
        
        self.allItemsShowed = YES;//显示了所有设置项
        [self.addMoreInfoButton setTitle:@"收起" forState:UIControlStateNormal];
    }
    else{
        self.secondaryViewHeight.constant = 0.0;
        self.allItemsShowed = NO;//未显示了所有设置项
        [self.addMoreInfoButton setTitle:@"添加更多" forState:UIControlStateNormal];
    }
}





@end

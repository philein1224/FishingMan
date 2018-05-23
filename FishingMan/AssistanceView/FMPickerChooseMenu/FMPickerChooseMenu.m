//
//  FMPickerChooseMenu.m
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMPickerChooseMenu.h"

#define ZXHScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ZXHScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ContentYOffset  240

@interface FMPickerChooseMenu ()
{
    NSArray *dataArray;
    NSMutableArray * selectedRows;
}
@property (weak, nonatomic) IBOutlet UIView *alphaBGView;
@property (weak, nonatomic) IBOutlet UIView *activeContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeContainerHeight;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *kindsTitleBar;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;


@end

@implementation FMPickerChooseMenu

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:pan];
}

//单选
+ (instancetype)shareWithTarget:(id)target
                          array:(NSArray *)array
                       callback:(PickerChooseMenuCallback) callback{
    
    FMPickerChooseMenu *chooseMenu = [[[NSBundle mainBundle] loadNibNamed:@"FMPickerChooseMenu" owner:self options:nil] firstObject];
    
    chooseMenu->dataArray = [[NSArray alloc] initWithObjects:array, nil];
    chooseMenu->selectedRows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < chooseMenu->dataArray.count; i++) {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:@"0"
                                                         forKey:[NSString stringWithFormat:@"%d",i]];
        [chooseMenu->selectedRows addObject:dic];
    }
    
    chooseMenu.callback = callback;
    
    chooseMenu.alphaBGView.alpha = 0.0;
    chooseMenu.activeContainerView.frame = CGRectMake(0,
                                                      ZXHScreenHeight,
                                                      ZXHScreenWidth,
                                                      ContentYOffset);
    chooseMenu.frame = CGRectMake(0,
                                  0,
                                  ZXHScreenWidth,
                                  ZXHScreenHeight);
    
    /*** 背景高斯模糊 ***/
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
//    [commentView.bgImageView addSubview:effectView];
    
    return chooseMenu;
}

//双选
+ (instancetype)shareWithTarget:(id)target
                     wholeArray:(NSArray<NSArray *> *)array
                     kindTitles:(NSArray *)titles
                       callback:(PickerChooseMenuCallback) callback{
    
    FMPickerChooseMenu *chooseMenu = [[[NSBundle mainBundle] loadNibNamed:@"FMPickerChooseMenu" owner:self options:nil] firstObject];
    
    if(![ZXHTool isNilNullObject:titles] && titles.count > 0){
        chooseMenu.kindsTitleBar.hidden = NO;
        chooseMenu.leftTitleLabel.text = titles[0]?titles[0]:@"";
        chooseMenu.rightTitleLabel.text = titles[1]?titles[1]:@"";
    }
    
    chooseMenu->dataArray = [[NSArray alloc] initWithArray:array];
    chooseMenu->selectedRows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < chooseMenu->dataArray.count; i++) {
        
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:@"0"
                                                         forKey:[NSString stringWithFormat:@"%d",i]];
        [chooseMenu->selectedRows addObject:dic];
    }
    
    chooseMenu.callback = callback;
    
    chooseMenu.alphaBGView.alpha = 0.0;
    chooseMenu.activeContainerView.frame = CGRectMake(0,
                                                      ZXHScreenHeight,
                                                      ZXHScreenWidth,
                                                      ContentYOffset);
    chooseMenu.frame = CGRectMake(0,
                                  0,
                                  ZXHScreenWidth,
                                  ZXHScreenHeight);
    
    /*** 背景高斯模糊 ***/
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    //    [commentView.bgImageView addSubview:effectView];
    
    return chooseMenu;
}

- (void)show{
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.frame = CGRectMake(0, 0, ZXHScreenWidth, ZXHScreenHeight);
    self.alphaBGView.alpha = 0.0;
    
    self.activeContainerView.frame = CGRectMake(0,
                                                ZXHScreenHeight,
                                                ZXHScreenWidth,
                                                ContentYOffset);
    
    [UIView animateWithDuration:0.5 animations:^{
    
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight - ContentYOffset,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.4;
        
    } completion:^(BOOL finished) {
        
        [self.pickerView reloadAllComponents];
    }];
}

- (void)dismiss{
    
    self.alphaBGView.alpha = 0.4;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [self dismiss];
}

- (IBAction)confirmButtonAction:(id)sender {
    //回调
    NSMutableArray * callbackArray = [NSMutableArray array];
    for(int j = 0; j<dataArray.count; j++)
    {
        NSArray * valueArray = [dataArray objectAtIndex:j];
        
        NSDictionary * dic = selectedRows[j];
        NSArray * allKeys = [dic allKeys];
        for (int i = 0; i<allKeys.count; i++) {
            NSString * indexStr = [dic objectForKey:[NSString stringWithFormat:@"%@", allKeys[i]]];
            NSInteger index = [indexStr integerValue];
            NSString * value = valueArray[index];
            [callbackArray addObject:value];
        }
    }
    
    
    
    
    if(self.callback){
        self.callback(callbackArray);
    }
    
    [self dismiss];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return dataArray.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return [(NSArray *)dataArray[component] count];
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return @"别开枪";
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    NSArray * singleArray = (NSArray *)dataArray[component];
    pickerLabel.text = singleArray[row];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //重复的value重新赋值
    for (NSMutableDictionary * dic in selectedRows) {
        
        NSString * num = [[dic allKeys] firstObject];
        if(component == [num integerValue]) {
            
            NSLog(@"1 = %@", dic);
            [dic setObject:[NSString stringWithFormat:@"%ld",row] forKey:[NSString stringWithFormat:@"%ld",component]];
            NSLog(@"2 = %@", dic);
        }
    }
    
    NSLog(@"2 selectedRows = %@", selectedRows);
}

@end

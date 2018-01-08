//
//  LocalPageDataHandler.h
//  FishingMan
//
//  Created by zhangxh on 2017/6/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "LocalPageDataHandler.h"
#import "CDServerAPIs+FishSite.h"
#import "CDServerAPIs+FishStore.h"
#import "CDTopAlertView.h"

#import "FMFishSiteModel.h"

@implementation LocalPageDataHandler

+ (void)APIForFishSiteListWithPage:(int)page Callback:(void (^)(NSMutableArray * array)) listBlock{
    
    [[CDServerAPIs shareAPI] fishSiteListWithPage:page
                                          Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                           
                                           if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                               
                                               NSMutableArray *array = [FMFishSiteModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
                                               
                                               if(listBlock){
                                                   listBlock(array);
                                               }
                                           }
                                           else{
                                               if(listBlock){
                                                   listBlock(nil);
                                               }
                                           }
                                       }
                                          Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                           
                                           [CDServerAPIs httpDataTask:dataTask error:error.error];
                                           
                                           if(listBlock){
                                               listBlock(nil);
                                           }
                                          }];
}

@end

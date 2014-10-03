//
//  ViewController.h
//  EasyDinnerRestaurant
//
//  Created by ZhouMeng on 14-10-1.
//  Copyright (c) 2014年 DreamChou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray* names;
@property (strong, nonatomic)NSMutableArray* phone;
@property (strong, nonatomic)NSMutableArray* customertype;
@property (strong, nonatomic)NSMutableArray* deviceToken;
@property (nonatomic)NSInteger selectedrow;


- (void) UpdateInfo;

@end


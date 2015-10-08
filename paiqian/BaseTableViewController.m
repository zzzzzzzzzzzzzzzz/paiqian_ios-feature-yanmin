//
//  BaseTableViewController.m
//  paiqian
//
//  Created by LuoJiee on 15/9/24.
//  Copyright © 2015年 LuoJiee. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if ([self.navigationController  viewControllers].count > 1) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES ;
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self ;
        
    }
    
  
}

-(IBAction)backButtonClick:(id)sender{
    
    if ([self.navigationController childViewControllers].count > 1 ) {
        
        [self.navigationController  popViewControllerAnimated:YES] ;
        
    }else {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }]  ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

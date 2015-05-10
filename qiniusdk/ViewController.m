//
//  ViewController.m
//  qiniusdk
//
//  Created by YANG on 5/10/15.
//  Copyright (c) 2015 YANG. All rights reserved.
//

#import "ViewController.h"
#import "IBGCloudStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startUpload:(id)sender {
    NSString* meidaFilePath = [[NSBundle mainBundle] pathForResource:@"1"
                                                         ofType:@"mp4"];
    
    IBGCloudStorage* cs = [[IBGCloudStorage alloc] init];
    [cs uploadFile:meidaFilePath UserID:@"10098"
          complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {}
          progress:^(NSString *key, float percent) {
              NSLog(@"uplaod progress: %lf", percent);}
            cancel:FALSE];
}

@end

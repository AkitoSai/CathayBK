//
//  ObjCViewController.m
//  AkitosHome
//
//  Created by akito on 2022/6/3.
//  Copyright © 2022 蔡 易達. All rights reserved.
//
#import "CathayBK-Swift.h"

#import "ObjCViewController.h"


@implementation ObjCViewController

@synthesize myMainViewController = _myMainViewController;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    // 取得螢幕的尺寸
    CGSize fullSize = [[UIScreen mainScreen] bounds].size;
    
    // 計算畫面縮放的比例 以寬度375為基準
    zoomSize = fullSize.width/375.0;
    
    // 設定背景色
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    // 從畫面頂端偏移的Y的高度
    viewTopOffsetY = 0*zoomSize;
    
    // 頂端topBarImageViewHeight的高度
    topBarImageViewHeight = 85*zoomSize;
    
    // myUserUnitView的高度
    myUserUnitViewHeight = 80*zoomSize;
    
    // 底端topImageView的高度
    bottomImageViewHeight = 75*zoomSize;
    

    
    
    //======== 設置 myUserUnitView ========//
    myUserUnitView = [[UserUnitView alloc] initWithFrame:CGRectMake( 0, viewTopOffsetY+topBarImageViewHeight, self.view.frame.size.width, myUserUnitViewHeight)];
    myUserUnitView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    myUserUnitView.myObjCViewController = self;
    [self.view addSubview:myUserUnitView];
    //=====================================================//
    
    //======== 設置  myFriendsListView ========//
    myFriendsListView = [[FriendsListView alloc] initWithFrame:CGRectMake( 0, viewTopOffsetY+topBarImageViewHeight+myUserUnitViewHeight, self.view.frame.size.width, self.view.frame.size.height-viewTopOffsetY-topBarImageViewHeight-myUserUnitViewHeight-bottomImageViewHeight+15*zoomSize)];
    //myFriendsListView.backgroundColor = [UIColor yellowColor];
    myFriendsListView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    myFriendsListView.myObjCViewController = self;
    [self.view addSubview:myFriendsListView];
    //=====================================================//
    
    //======== 設置 topBarImageView ========//
    NSString *topBarImagPpath = [[NSBundle mainBundle] pathForResource:@"Paimg/img_1" ofType:@"png"];
    //UIImage *topBarImagPpath = [UIImage imageWithContentsOfFile:topImagPpath];
    UIImageView *topBarImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:topBarImagPpath]];
    [topBarImageView setFrame:CGRectMake( 0, viewTopOffsetY, self.view.frame.size.width, topBarImageViewHeight)];
    topBarImageView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    [self.view addSubview:topBarImageView];
    topBarImageView = nil;
    //=====================================================//
    
    //======== 設置 bottomImageView ========//
    NSString *bottomImagPpath = [[NSBundle mainBundle] pathForResource:@"Image/img_0" ofType:@"png"];
    //UIImage *bottomImage = [UIImage imageWithContentsOfFile:midImagPpath];
    UIImageView *bottomImageView=[[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:bottomImagPpath]];
    [bottomImageView setFrame:CGRectMake( 0, self.view.frame.size.height - bottomImageViewHeight, self.view.frame.size.width, bottomImageViewHeight)];
    //bottomImageView.backgroundColor = UIColor.grayColor;
    [self.view addSubview:bottomImageView];
    bottomImageView = nil;
    //=====================================================//

    
    
    
    //======== 設置mySegmentedControl ========//
    mySegmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(110*zoomSize, 50*zoomSize,200*zoomSize, 32*zoomSize)];
    [mySegmentedControl insertSegmentWithTitle:@"1" atIndex:0 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"2" atIndex:1 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"3" atIndex:2 animated:YES];
    [mySegmentedControl insertSegmentWithTitle:@"(+3)" atIndex:3 animated:YES];
    //mySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
    mySegmentedControl.tintColor = [UIColor redColor];
    mySegmentedControl.selectedSegmentIndex = 0;
    //mySegmentedControl.momentary = YES;
    mySegmentedControl.apportionsSegmentWidthsByContent = YES;
    [mySegmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySegmentedControl];
    //=====================================================//
    
    
    
    
    // 打開頁面時需執行的動作
    [self open];
    
    NSLog(@"ObjCViewController - viewDidLoad");
}


//=====================================================//
// 打開頁面時需執行的動作
//=====================================================//
 - (void)open{
     
     if(myUserUnitView != nil){
         [myUserUnitView doRequest];
     }
     if(myFriendsListView != nil && mySegmentedControl !=nil){
         [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
     }
     
 }


//=====================================================//
// 顯示提醒標語
//=====================================================//
- (void)showAlertWithMessage:(NSString*)messageString{
    
    UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"錯誤"
                                    message:messageString
                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction
                           actionWithTitle:@"確認"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:NO completion:nil];
                               // do something
                           }];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
    
}



//=====================================================//
// doSomethingInSegment
//=====================================================//
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    
    mySegmentedControl.selectedSegmentIndex = Index;
    switch (Index)
    {
        case 0:
            //(4)- (1) 無好友畫面:request API 2-(5)
            //mySegmentedControl.selectedSegmentIndex = 0;
            if(myFriendsListView != nil){
                [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
            }
            
            break;
        case 1:
            //(4)- (2) 只有好友列表:request API 2-(2) 2-(3)
            //mySegmentedControl.selectedSegmentIndex = 1;
            if(myFriendsListView != nil){
                [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
            }
            break;
        case 2:
            //(4) - (3) 好友列表含邀請:request API 2-(4)
            //mySegmentedControl.selectedSegmentIndex = 2;
            if(myFriendsListView != nil){
                [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
            }
            break;
        case 3:
            // 4. 加分項目(3) 邀請列表支援縮合操作 全屏方式實現
            //mySegmentedControl.selectedSegmentIndex = 2;
            if(myFriendsListView != nil){
                [myFriendsListView doRequestWithType:(int)mySegmentedControl.selectedSegmentIndex];
            }
            break;
        default:
            break;
    }
}


//=====================================================//
// dealloc
//=====================================================//
- (void)dealloc {
    
    // myUserUnitView
    myUserUnitView = nil;
    
    // myFriendsListView
    myFriendsListView = nil;

    //mySegmentedControl
    mySegmentedControl = nil;
    
}

//=====================================================//
// 收到記憶體錯誤的動作
//=====================================================//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil) {
              self.view = nil;
    }
}

@end

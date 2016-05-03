//
//  ListViewController.m
//  TabBarTest2
//
//  Created by Sky on 14-7-23.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController
{
    NSString* requesturl;
}
@synthesize datadic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithURL:(NSString *)url
{
    if (self=[super init])
    {
        requesturl=[url copy];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataDict = self.datadic;
    NSLog(@"--------------%@",self.dataDict);
	// Do any additional setup after loading the view.
    /*
     gcd利用苹果公司封装的GCD(多线程编程技术,获取到程序的全局队列.（管理线程队列），开辟出一块异步执行的线程)
     通过DISPATCH_QUEUE_PRIORITY_DEFAULT通过全局队列,执行线程的优先级.
     
     */
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //将需要的异步执行的,比较耗时的代码写在这里
//        //创建一个网络地址
//        NSLog(@"原生JSON解析");
//        //从网络获取数据
//        NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:requesturl]];
//        //将请求URL数据存放到一个NSData对象中
//        NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        //自带了一个JSON解析的类 执行效率高，返回解析成功的一个字典对象NSJSONSerialization
//        //创建一个字典对象用于保存解析出来的数据
//        NSDictionary* dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dict:%@",dict);
//        
//        if (dict!=nil)
//        {
//            [self.dataDict removeAllObjects];
//            //表示下载成功
//            //数据传递给主线程 下载完毕以后回传给主线程
//            //拿到主线程的队列,通过后续的BLOCK，回到主线程中进行后续的UI操作
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //传值(主线程执行的代码)
//                NSArray* groups=[dict objectForKey:@"categories"];
//                for (NSObject* item in groups)
//                {
//                    if ([item isKindOfClass:[NSDictionary class]])
//                    {
//                        //NSLog(@"两级菜单");
//                        NSString* name=[(NSDictionary*)item objectForKey:@"category_name"];
//                        NSArray* arr=[(NSDictionary*)item objectForKey:@"subcategories"];
//                        [self.dataDict setObject:arr forKey:name];
//                    }
////                    else
////                    {
////                        NSLog(@"一级菜单");
////                        CGRect frame=self.rightTableView.frame;
////                        frame.origin.x=0;
////                        frame.size.width=320;
////                        self.rightTableView.frame=frame;
////                        [self.dataDict setObject:groups forKey:self.title];
////                        //self.defaultText = [groups objectAtIndex:0];
////                        [self.leftTableView reloadData];
////                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                        [self tableView:self.leftTableView didSelectRowAtIndexPath:indexPath];
////
////                    }
//                }
//                [self.leftTableView reloadData];
//            });
//        }
//        else
//        {
//            NSLog(@"下载不成功,抛出异常");
//        }
//        
//    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

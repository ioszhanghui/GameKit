//
//  ViewController.m
//  GameKitDemo
//
//  Created by 小飞鸟 on 2018/1/27.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//


/*
 1.设置UI界面
 2、引入框架
 */

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,GKPeerPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property(nonatomic,strong)GKSession * session;
/*链接的用户的PeerID*/
@property(nonatomic,copy)NSString * peerId;

@end

@implementation ViewController

//链接设备
- (IBAction)connectDevice:(id)sender {

    //1、创建控制器
    GKPeerPickerController * pic = [GKPeerPickerController new];
    //2、链接设备 获取数据
    pic.delegate=self;
    pic.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [pic show];

}
#pragma mark 连接上一个设备
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    
    //连接上之后 撤销蓝牙搜索
    [picker dismiss];
    //通信的会话
    self.session=session;
    //连接上的蓝牙设备的ID
    self.peerId =peerID;
    [session setDataReceiveHandler:self withContext:nil];
}

#pragma mark 通知委托用户取消了 就是不在搜索附近的设备
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    
    NSLog(@"取消了链接");
}

#pragma mark 接收别人发送的数据
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context{
    
    UIImage * image =[[UIImage alloc]initWithData:data];
    self.photoImageView.image =image;
}


//选择图片
- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController * picker =[[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.photoImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//传递图片
- (IBAction)convertPhoto:(id)sender {
    
    
    NSData * data =UIImagePNGRepresentation(self.photoImageView.image);
    //GKSendDataReliable
//    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
    NSError * error;
    [self.session sendData:data toPeers:@[self.peerId] withDataMode:GKSendDataReliable error:&error];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
}


@end

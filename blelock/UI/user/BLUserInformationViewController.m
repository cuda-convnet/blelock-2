//
//  BLUserInformationViewController.m
//  blelock
//
//  Created by NetEase on 15/8/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLUserInformationViewController.h"
#import "UIViewController+Utils.h"

#import "BLUserNameChangeViewController.h"
#import "BLUserGenderChangeViewController.h"

@interface BLUserInformationViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, BLUserNameChangeViewControllerDelegate, BLUserGenderChangeViewControllerDelegate>

@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userGenderLabel;

@end

@implementation BLUserInformationViewController

- (void)loadView {
    
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"我的资料";
    
    //导航栏按钮
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = navLeftButton;

    _setTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    
    [view addSubview:_setTableView];
    self.view = view;
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _setTableView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = 0.0f;
    r1.size.width = rect.size.width;
    r1.size.height = 316.0f;
    _setTableView.frame = r1;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//列表需要的方法
//列表内容

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (row) {
            case 0: {
                _userImageView = [UIViewController customImageView:CGRectMake(120, 10, 80, 80) andImage:_user.img];
                [cell.contentView addSubview: _userImageView];
                break;
            }
            case 1: {
                cell.textLabel.text = @"姓名";
                _userNameLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.name andColor:[UIColor blackColor] andFont:16.0f];
                _userNameLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: _userNameLabel];
                break;
            }
            case 2: {
                cell.textLabel.text = @"性别";
                _userGenderLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.gender andColor:[UIColor blackColor] andFont:16.0f];
                _userGenderLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: _userGenderLabel];
                break;
            }
            case 3:{
                cell.textLabel.text = @"手机";
                UILabel *userPhoneLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.mobile andColor:[UIColor blackColor] andFont:16.0f];
                userPhoneLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: userPhoneLabel];
                break;
            }
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Tells the delegate that the specified row is now selected.
    [_setTableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0: {
            [self changeImage];
            break;
        }
        case 1: {
            BLUserNameChangeViewController *blUserNameChangeViewController = [[BLUserNameChangeViewController alloc] init];
            blUserNameChangeViewController.delegate = self;
            [self.navigationController pushViewController:blUserNameChangeViewController animated:YES];
            break;
        }
        case 2: {
            BLUserGenderChangeViewController *blUserGenderChangeViewController = [[BLUserGenderChangeViewController alloc] init];
            blUserGenderChangeViewController.delegate = self;
            blUserGenderChangeViewController.oldGenger = _user.gender;
            [self.navigationController pushViewController:blUserGenderChangeViewController animated:YES];
            break;
        }
        case 3: {
            break;
        }
        default:
            break;
    }
}

- (void)changeImage {
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"拍照", @"从相册选择",nil];
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //拍照
            [self takePhoto];
            break;
        case 1:
            //从相册选择
            [self LocalPhoto];
            break;
        default:
            break;
    }
}

//拍照
- (void)takePhoto {
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

//从相册选择
- (void)LocalPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    //[self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        _userImageView.image = image;
        
//        //以下是保存文件到沙盒路径下
//        //把图片转成NSData类型的数据来保存文件
//        NSData *data;
//        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        //保存
//        [[NSFileManager defaultManager] createFileAtPath:self.imagePath contents:data attributes:nil];
        
    }
    //关闭相册界面???????????
    [picker dismissViewControllerAnimated:YES completion:^{
        //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }];
}

//实现代理方法
- (void)changeUserName:(NSString *)newName {
    _user.name = newName;
    _userNameLabel.text = newName;
}

- (void)changeUserGender: (NSString *)newGender {
    _user.gender = newGender;
    _userGenderLabel.text = newGender;
}

@end
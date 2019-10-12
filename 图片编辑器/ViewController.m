//
//  ViewController.m
//  图片编辑器
//
//  Created by 张冲 on 2018/11/26.
//  Copyright © 2018 张冲. All rights reserved.
//

#import "ViewController.h"
#import "EditImageView.h"
#import "EditLabel.h"
#define SCREEWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEHEIGH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIImageView *_bgImageView;
    NSMutableArray *_editImageViewArray;
    EditLabel *_nameLabel;
    UIButton *_addButton;
    UIButton *_saveBtn;
    UIView *_toolBottomView;
    UIImagePickerController *_mainImagePicker;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addButton setTitle:@"添加照片" forState:UIControlStateNormal];
    [_addButton setFrame:CGRectMake(0, 0, 100, 100)];
    [_addButton setCenter:self.view.center];

    [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(imageTap:) forControlEvents:UIControlEventTouchUpInside];
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEWIDTH, SCREEHEIGH)];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;

    [self.view addSubview:_bgImageView];
    [self.view addSubview:_addButton];

    _editImageViewArray = [[NSMutableArray alloc] init];
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.backgroundColor = [UIColor orangeColor];
    _saveBtn.layer.cornerRadius = 5;
    _saveBtn.frame = CGRectMake(20,100, self.view.frame.size.width-40, 30);
    [_saveBtn setTitle:@"保存相册" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _saveBtn.hidden = YES;
    [self.view addSubview:_saveBtn];


    _toolBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEHEIGH, SCREEWIDTH, 100)];
    _toolBottomView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    [self.view addSubview:_toolBottomView];

    UIButton *delegateBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 60, 60)];
    [delegateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delegateBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_toolBottomView addSubview:delegateBtn];
    [delegateBtn addTarget:self action:@selector(deletaBtn:) forControlEvents:UIControlEventTouchUpInside];


    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 20, 60, 60)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_toolBottomView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *choicebtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 20, 100, 60)];
    [choicebtn setTitle:@"相册选取" forState:UIControlStateNormal];
    [_toolBottomView addSubview:choicebtn];
    [choicebtn addTarget:self action:@selector(choiceBtn:) forControlEvents:UIControlEventTouchUpInside];


    // Do any additional setup after loading the view, typically from a nib.
}
- (void)imageTap:(UIButton *)button{
    _mainImagePicker = [[UIImagePickerController alloc]init];
    _mainImagePicker.delegate = self;
    _mainImagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_mainImagePicker animated:YES completion:^{

    }];
}
- (void)choiceBtn:(UIButton *)button{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:^{

    }];
}
- (void)deletaBtn:(UIButton *)button{
    CGRect frame =  _bgImageView.frame;
    frame.origin.y += 100;
    _bgImageView.frame = frame;

    CGRect toolFrame = _toolBottomView.frame;
    toolFrame.origin.y += 100;
    _toolBottomView.frame = toolFrame;
}
- (void)pageUpglide{
//    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame =  _bgImageView.frame;
        frame.origin.y -= 100;
        _bgImageView.frame = frame;

        CGRect toolFrame = _toolBottomView.frame;
        toolFrame.origin.y -= 100;
        _toolBottomView.frame = toolFrame;
//    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSLog(@"info = %@",info);
    if (picker == _mainImagePicker) {
        _addButton.hidden = YES;
        _saveBtn.hidden = NO;
        //弹出页面
        [self pageUpglide];
        UIImage *orignImage = info[@"UIImagePickerControllerOriginalImage"];
        _bgImageView.image = orignImage;
        [self addCodeUI];
    }else{
        UIImage *editImage = info[@"UIImagePickerControllerEditedImage"];
        [self addEditImageView:editImage];
    }

    [picker dismissViewControllerAnimated:YES completion:^{

    }];


}
- (void)addEditImageView:(UIImage *)image{
        EditImageView *editImgView2 = [[EditImageView alloc] initWithFrame:CGRectMake(100,500, 100, 100)];
        editImgView2.image = image;
        [_bgImageView addSubview:editImgView2];
        [_editImageViewArray addObject:editImgView2];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消图片选择");
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)addCodeUI{
    _nameLabel  = [[EditLabel alloc]initWithFrame:CGRectMake(200  , 400, 200, 150)];
    _nameLabel.text = @"张冲冲 理财师 \n 17091087826" ;
    _nameLabel.numberOfLines = 2;
    _nameLabel.textColor = [UIColor grayColor];
    [_bgImageView addSubview:_nameLabel];
    _nameLabel.userInteractionEnabled = YES;
}

- (void)saveBtnClick:(UIButton *)button{
    [self saveToPhotosAlbum];
}
//保存到相册
- (void)saveToPhotosAlbum{
    UIImage *viewImage = [self imageThumb];
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);

}
- (void)addBtn:(UIButton *)button{
    UIImage *img = [UIImage imageNamed:@"b.png"];
    EditImageView *editImgView = [[EditImageView alloc] initWithFrame:CGRectMake(50, 400, img.size.width, img.size.height)];
    editImgView.image = img;
    [_bgImageView addSubview:editImgView];
    [_editImageViewArray addObject:editImgView];
}
//截图，获取到image
- (UIImage *)imageThumb{
    [self hideAllBtn];

    CGPoint point = [[_bgImageView superview] convertPoint:_bgImageView.frame.origin toView:_bgImageView];
    CGRect rect = CGRectMake(point.x, point.y, _bgImageView.frame.size.width, _bgImageView.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0);
    [_bgImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
- (void)hideAllBtn{
    for (EditImageView *editImgView in _editImageViewArray) {
        [editImgView hideEditBtn];
    }
    [_nameLabel hideEditBtn];
}@end

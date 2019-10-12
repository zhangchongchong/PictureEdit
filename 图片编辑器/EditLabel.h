//
//  EditLabel.h
//  图片编辑器
//
//  Created by 张冲 on 2018/11/26.
//  Copyright © 2018 张冲. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditLabel : UILabel
{
    BOOL _isMove;
    CGPoint _startTouchPoint;
    CGPoint _startTouchCenter;
    UIView *_borderView;
    UIImageView *_editImgView;
    UIButton *_closeImgView;
    CGFloat _len;
}
- (void)hideEditBtn;

@end

NS_ASSUME_NONNULL_END

//
//  YuvParam.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YuvParam : NSObject
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger pixelFomat;
@property (nonatomic, assign) NSInteger fps;

@end

NS_ASSUME_NONNULL_END

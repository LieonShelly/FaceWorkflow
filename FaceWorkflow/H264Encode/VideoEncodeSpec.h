//
//  VideoEncodeSpec.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoEncodeSpec : NSObject
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int pixFmt;
@property (nonatomic, assign) int fps;





@end

NS_ASSUME_NONNULL_END

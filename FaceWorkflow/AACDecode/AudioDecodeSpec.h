//
//  AudioDecodeSpec.h
//  FaceWorkflow
//
//  Created by lieon on 2021/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioDecodeSpec : NSObject
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int sampleFmt;
@property (nonatomic, assign) int chLayout;
@end

NS_ASSUME_NONNULL_END

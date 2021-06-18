//
//  PermenantThread.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import "PermenantThread.h"

@interface PermenantThread()
@property (nonatomic, strong) NSThread *innerThread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;
@end

@implementation PermenantThread

- (instancetype)init {
    if (self = [super init]) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[NSThread alloc]initWithBlock:^{
            // 往RunLoop里面添加Source\timer\Observer
            [[NSRunLoop currentRunLoop]addPort:[NSPort new] forMode:NSDefaultRunLoopMode];
            // while里面的代码不会多次执行，因为RunLoop已经让线程休眠了
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
        [self.innerThread start];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [self stop];
}

- (void)excuteTask:(void(^)(void))task  {
    if (!self.innerThread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop {
    if (!self.innerThread) {
        return;
    }
    //  在子线程调用stop（waitUntilDone设置为YES，代表子线程的代码执行完毕后，这个方法才会往下走）
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:true];
}

- (void)__stop {
    self.stopped = true;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(void(^)(void))task {
    task();
}
@end

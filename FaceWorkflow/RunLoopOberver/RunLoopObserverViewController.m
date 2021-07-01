//
//  RunLoopObserverViewController.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/1.
//

#import "RunLoopObserverViewController.h"

@interface RunLoopObserverViewController ()<UITableViewDataSource>
{
    dispatch_semaphore_t semaphore;
    NSInteger timeoutCount;
    CFRunLoopObserverRef obsever;
    CFRunLoopActivity activity;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RunLoopObserverViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView  = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self startMonitor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"卡顿";
    usleep(100000);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //主线程做耗时操作，模拟卡顿
        for (int i = 0; i < 1000000; i++) {
           i * 1000;
        }
    });
    return  cell;
}


void runLoopOberCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunLoopObserverViewController *monitor = (__bridge RunLoopObserverViewController*)info;
    monitor->activity = activity;
    long st = dispatch_semaphore_signal(monitor->semaphore);
    NSLog(@"dispatch_semaphore_signal:st=%ld,time:%@",st,[monitor getCurTime]);
    if (activity == kCFRunLoopEntry) {  // 即将进入RunLoop
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopEntry");
    } else if (activity == kCFRunLoopBeforeTimers) {    // 即将处理Timer
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeTimers");
    } else if (activity == kCFRunLoopBeforeSources) {   // 即将处理Source
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeSources");
    } else if (activity == kCFRunLoopBeforeWaiting) {   //即将进入休眠
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeWaiting");
    } else if (activity == kCFRunLoopAfterWaiting) {    // 刚从休眠中唤醒
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopAfterWaiting");
    } else if (activity == kCFRunLoopExit) {    // 即将退出RunLoop
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopExit");
    } else if (activity == kCFRunLoopAllActivities) {
        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopAllActivities");
    }
}

/**
 # RunLoop处理事件的两个主要阶段
     kCFRunLoopBeforeSouces和KCFRunLoopBeforeWating之间
     KCFRunLoopAfterwaiting之后
    - 如果每次检测runloop的状态一直停留在 kCFRunLoopBeforeSouces 或者 KCFRunLoopAfterwaiting，则runloop一直在处理事件（source0 source1）
 
 */
- (void)startMonitor {
    semaphore = dispatch_semaphore_create(1);
    CFRunLoopObserverContext context = { 0 , (__bridge  void*)self, NULL, NULL };
    obsever =  CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       true,
                                       0,
                                       runLoopOberCallback,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), obsever, kCFRunLoopCommonModes);
    
    // 在子线程中监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            // dispatch_semaphore_wait 使信号量减一，如果超时了，则返回了一个非0的值，然后往下执行
            // dispatch_semaphore_wait 往下执行的条件 信号量为0 或 等待超时
            // runloop状态改变，使用信号量 +1， 这边wait之后，信号量不为0，要么是在runloop不断改变状态，要么就是等待超时了
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 3 *NSEC_PER_MSEC));
            if (st != 0) { // 信号量超时了 - 即runloop的状态长时间没有发生变更，长期处于某一状态
                if (!self->obsever) {
                   self->timeoutCount = 0;
                    self->semaphore = 0;
                    self->activity = 0;
                    return;
                }
                if (self->activity == kCFRunLoopBeforeSources || self->activity == kCFRunLoopAfterWaiting) {
                    if (++self->timeoutCount < 5) {
                        continue; // 不足 5 次。直接 continue 当次循环，不将timtouotcount置为0
                    }
                    NSLog(@"-----卡顿了----上报栈信息");
                    self->timeoutCount = 0;
                }
            }
        }
    });
}


- (NSString*)getCurTime {
    return @"getCurTime";
}
@end

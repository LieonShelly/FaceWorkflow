#H264编码用到API说明
 - ffmpeg mp4转YUV
 
```C
ffmpeg -i in.MP4 -s 512x512 -pixel_format yuv420p in.yuv
```

- 获取一帧图片图片大小

```C++
    av_image_get_buffer_size((AVPixelFormat)input.pixFmt, input.width, input.height, 1)
```

- 获取libx264编码器

```C++
    codec = avcodec_find_encoder_by_name("libx264");
```

- 创建编码器上下文

```C++
   // 设置YUV参数
    ctx->width = input.width;
    ctx->height = input.height;
    ctx->pix_fmt = (AVPixelFormat)input.pixFmt;
    // 设置帧率
    ctx->time_base = {1, input.fps};
```

- 打开编码器

```C++
    ret = avcodec_open2(ctx, codec, nullptr);
```

- 创建输入缓冲区frame

```C++
    frame = av_frame_alloc();
    if (!frame) {
        goto end;
    }
    frame->width = ctx->width;
    frame->height = ctx->height;
    frame->format = ctx->pix_fmt;
    frame->pts = 0;
```

- 填充输入缓冲区frame数据

```C++
    av_image_alloc(frame->data,
                   frame->linesize,
                   input.width,
                   input.height,
                   AV_PIX_FMT_YUV420P,
                   1);
```

- 创建编码输出缓冲区

```C++
    pkt = av_packet_alloc();
```

- 发送数据到编码器

```C++
    int ret = avcodec_send_frame(ctx, frame);
```

- 从编码器中取出编码后的数据

```C++
    avcodec_receive_packet(ctx, pkt);
```

- 释放packet

```C++
    av_packet_free(&pkt);
```
- 释放frame

```C++
    av_frame_free(&frame);
```

- 关闭编码器

```C++
    avcodec_free_context(&ctx);
```


viewdidload {
print(1);
queue  // 串行
self.queue.async {
priint(2)
	self.queue.sync {
	print(3)
	}
	print(4)
}
print(5
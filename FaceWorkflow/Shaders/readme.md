
### 编译shader的方法
```
- ./shadercRelease  -f fs_image.sc -o Shaders.bundle/metal/fs_image.bin --depends -i src --varyingdef image.def --platform osx -p metal 120 --type fragment -O3

-   ./shadercRelease  -f vs_blueColor.sc -o Shaders.bundle/metal/vs_blueColor.bin --depends -i src --varyingdef blueColor.def --platform osx -p metal 120 --type vertex -O3

./shadercRelease  -f display_fs_cubes.sc -o Shaders.bundle/metal/display_fs_cubes.bin --depends -i src --varyingdef blueColor.def --platform osx -p metal 120 --type fragment -O3


# 
./shadercRelease  -f fs_cubes.sc -o Shaders.bundle/metal/fs_cubes.bin --depends -i src --varyingdef varying.def --platform osx -p metal 120 --type fragment -O3

./shadercRelease  -f vs_cubes.sc -o Shaders.bundle/metal/vs_cubes.bin --depends -i src --varyingdef varying.def --platform osx -p metal 120 --type vertex -O3

./shadercRelease  -f vs_cubes.sc -o Shaders.bundle/metal/vs_cubes.bin --depends -i src --varyingdef varying.def --platform osx -p metal 120 --type vertex -O3

./shadercRelease  -f display_fs_cubes.sc -o Shaders.bundle/metal/display_fs_cubes.sc.bin --depends -i src --varyingdef varying.def --platform osx -p metal 120 --type fragment -O3


```
- shadercRelease: 是bgfx编译后产生的
- shader文件中的 #include "common/common.sh" 必须包含，因为shader文件中添加bgfx的编译源码，编译shader时要依赖其中一些文件




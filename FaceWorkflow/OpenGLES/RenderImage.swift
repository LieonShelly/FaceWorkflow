//
//  RenderImage.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/3.
//

import Foundation
/**
 - 指定几何对象
 - 顶点处理
 - 图元组装
 - 栅格化操作
 - 片元处理
 - 帧缓冲操作
 
 ·Vertex Shader（顶点着色器）用来替换顶点处理阶段。
 ·Fragment Shader（片元着色器，又称像素着色器）用来替换片元处
 理阶段。
 
 3.创建显卡执行程序
 - 编译链接shader
 - 给显卡执行
 
 上下文环境搭建
 - OpenGL不负责窗口管理及上下文环境管理，该职责将由各个平台或者设备自行完成
 - 为了在OpenGL的输出与设备的屏幕之间架接起一个桥梁，Khronos创建了EGL的API，EGL是双缓冲的工作模式，即有一个Back Frame Buffer和一个Front Frame Buffer，正常绘制操作的目标都是Back FrameBuffer，操作完毕之后，调用eglSwapBuffer这个API，将绘制完毕的FrameBuffer交换到Front FrameBuffer并显示出来。
 */

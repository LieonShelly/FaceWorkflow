static const uint8_t fs_debugdraw_fill_lit_glsl[514] =
{
	0x46, 0x53, 0x48, 0x06, 0x0f, 0xc8, 0x56, 0x5f, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x75, // FSH...V_.......u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x02, 0x04, 0x00, 0x00, 0x04, 0x00, 0xe0, 0x01, 0x00, // _params.........
	0x00, 0x76, 0x61, 0x72, 0x79, 0x69, 0x6e, 0x67, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, // .varying highp v
	0x65, 0x63, 0x33, 0x20, 0x76, 0x5f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x3b, 0x0a, 0x75, 0x6e, 0x69, // ec3 v_world;.uni
	0x66, 0x6f, 0x72, 0x6d, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, // form vec4 u_para
	0x6d, 0x73, 0x5b, 0x34, 0x5d, 0x3b, 0x0a, 0x76, 0x6f, 0x69, 0x64, 0x20, 0x6d, 0x61, 0x69, 0x6e, // ms[4];.void main
	0x20, 0x28, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, 0x20, 0x76, 0x65, //  ().{.  highp ve
	0x63, 0x33, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x31, 0x3b, 0x0a, 0x20, 0x20, 0x74, // c3 tmpvar_1;.  t
	0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x31, 0x20, 0x3d, 0x20, 0x64, 0x46, 0x64, 0x78, 0x28, 0x76, // mpvar_1 = dFdx(v
	0x5f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x68, 0x69, 0x67, 0x68, 0x70, // _world);.  highp
	0x20, 0x76, 0x65, 0x63, 0x33, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x32, 0x3b, 0x0a, //  vec3 tmpvar_2;.
	0x20, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x32, 0x20, 0x3d, 0x20, 0x64, 0x46, 0x64, //   tmpvar_2 = dFd
	0x79, 0x28, 0x76, 0x5f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x6d, 0x65, // y(v_world);.  me
	0x64, 0x69, 0x75, 0x6d, 0x70, 0x20, 0x76, 0x65, 0x63, 0x34, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, // diump vec4 tmpva
	0x72, 0x5f, 0x33, 0x3b, 0x0a, 0x20, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x33, 0x2e, // r_3;.  tmpvar_3.
	0x78, 0x79, 0x7a, 0x20, 0x3d, 0x20, 0x28, 0x6d, 0x69, 0x78, 0x20, 0x28, 0x75, 0x5f, 0x70, 0x61, // xyz = (mix (u_pa
	0x72, 0x61, 0x6d, 0x73, 0x5b, 0x32, 0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x2c, 0x20, 0x75, 0x5f, 0x70, // rams[2].xyz, u_p
	0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x31, 0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x2c, 0x20, 0x28, 0x0a, // arams[1].xyz, (.
	0x20, 0x20, 0x20, 0x20, 0x28, 0x64, 0x6f, 0x74, 0x20, 0x28, 0x6e, 0x6f, 0x72, 0x6d, 0x61, 0x6c, //     (dot (normal
	0x69, 0x7a, 0x65, 0x28, 0x28, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x28, 0x74, 0x6d, 0x70, // ize((.      (tmp
	0x76, 0x61, 0x72, 0x5f, 0x31, 0x2e, 0x79, 0x7a, 0x78, 0x20, 0x2a, 0x20, 0x74, 0x6d, 0x70, 0x76, // var_1.yzx * tmpv
	0x61, 0x72, 0x5f, 0x32, 0x2e, 0x7a, 0x78, 0x79, 0x29, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x2d, // ar_2.zxy).     -
	0x20, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x28, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, //  .      (tmpvar_
	0x31, 0x2e, 0x7a, 0x78, 0x79, 0x20, 0x2a, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x32, // 1.zxy * tmpvar_2
	0x2e, 0x79, 0x7a, 0x78, 0x29, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x29, 0x29, 0x2c, 0x20, 0x75, 0x5f, // .yzx).    )), u_
	0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x30, 0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x29, 0x20, 0x2a, // params[0].xyz) *
	0x20, 0x30, 0x2e, 0x35, 0x29, 0x0a, 0x20, 0x20, 0x20, 0x2b, 0x20, 0x30, 0x2e, 0x35, 0x29, 0x29, //  0.5).   + 0.5))
	0x20, 0x2a, 0x20, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x33, 0x5d, 0x2e, 0x78, //  * u_params[3].x
	0x79, 0x7a, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x33, 0x2e, // yz);.  tmpvar_3.
	0x77, 0x20, 0x3d, 0x20, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x33, 0x5d, 0x2e, // w = u_params[3].
	0x77, 0x3b, 0x0a, 0x20, 0x20, 0x67, 0x6c, 0x5f, 0x46, 0x72, 0x61, 0x67, 0x43, 0x6f, 0x6c, 0x6f, // w;.  gl_FragColo
	0x72, 0x20, 0x3d, 0x20, 0x74, 0x6d, 0x70, 0x76, 0x61, 0x72, 0x5f, 0x33, 0x3b, 0x0a, 0x7d, 0x0a, // r = tmpvar_3;.}.
	0x0a, 0x00,                                                                                     // ..
};
static const uint8_t fs_debugdraw_fill_lit_spv[1517] =
{
	0x46, 0x53, 0x48, 0x06, 0x0f, 0xc8, 0x56, 0x5f, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x75, // FSH...V_.......u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x12, 0x04, 0x00, 0x00, 0x04, 0x00, 0xc8, 0x05, 0x00, // _params.........
	0x00, 0x03, 0x02, 0x23, 0x07, 0x00, 0x00, 0x01, 0x00, 0x08, 0x00, 0x08, 0x00, 0xda, 0x00, 0x00, // ...#............
	0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x06, // ................
	0x00, 0x01, 0x00, 0x00, 0x00, 0x47, 0x4c, 0x53, 0x4c, 0x2e, 0x73, 0x74, 0x64, 0x2e, 0x34, 0x35, // .....GLSL.std.45
	0x30, 0x00, 0x00, 0x00, 0x00, 0x0e, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, // 0...............
	0x00, 0x0f, 0x00, 0x08, 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x6d, 0x61, 0x69, // .............mai
	0x6e, 0x00, 0x00, 0x00, 0x00, 0x79, 0x00, 0x00, 0x00, 0x7c, 0x00, 0x00, 0x00, 0x87, 0x00, 0x00, // n....y...|......
	0x00, 0x10, 0x00, 0x03, 0x00, 0x04, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x03, 0x00, 0x03, // ................
	0x00, 0x05, 0x00, 0x00, 0x00, 0xf4, 0x01, 0x00, 0x00, 0x05, 0x00, 0x04, 0x00, 0x04, 0x00, 0x00, // ................
	0x00, 0x6d, 0x61, 0x69, 0x6e, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x06, 0x00, 0x48, 0x00, 0x00, // .main........H..
	0x00, 0x55, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x42, 0x6c, 0x6f, 0x63, 0x6b, 0x00, 0x00, 0x00, // .UniformBlock...
	0x00, 0x06, 0x00, 0x06, 0x00, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x75, 0x5f, 0x70, // .....H.......u_p
	0x61, 0x72, 0x61, 0x6d, 0x73, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x03, 0x00, 0x4a, 0x00, 0x00, // arams........J..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x04, 0x00, 0x79, 0x00, 0x00, 0x00, 0x76, 0x5f, 0x76, // .........y...v_v
	0x69, 0x65, 0x77, 0x00, 0x00, 0x05, 0x00, 0x04, 0x00, 0x7c, 0x00, 0x00, 0x00, 0x76, 0x5f, 0x77, // iew......|...v_w
	0x6f, 0x72, 0x6c, 0x64, 0x00, 0x05, 0x00, 0x06, 0x00, 0x87, 0x00, 0x00, 0x00, 0x62, 0x67, 0x66, // orld.........bgf
	0x78, 0x5f, 0x46, 0x72, 0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x30, 0x00, 0x00, 0x47, 0x00, 0x04, // x_FragData0..G..
	0x00, 0x47, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x48, 0x00, 0x05, // .G...........H..
	0x00, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x23, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // .H.......#......
	0x00, 0x47, 0x00, 0x03, 0x00, 0x48, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x47, 0x00, 0x04, // .G...H.......G..
	0x00, 0x4a, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x47, 0x00, 0x04, // .J...".......G..
	0x00, 0x4a, 0x00, 0x00, 0x00, 0x21, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x47, 0x00, 0x04, // .J...!...0...G..
	0x00, 0x79, 0x00, 0x00, 0x00, 0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x47, 0x00, 0x04, // .y...........G..
	0x00, 0x7c, 0x00, 0x00, 0x00, 0x1e, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x47, 0x00, 0x04, // .|...........G..
	0x00, 0x87, 0x00, 0x00, 0x00, 0x1e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x13, 0x00, 0x02, // ................
	0x00, 0x02, 0x00, 0x00, 0x00, 0x21, 0x00, 0x03, 0x00, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, // .....!..........
	0x00, 0x16, 0x00, 0x03, 0x00, 0x06, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x17, 0x00, 0x04, // ......... ......
	0x00, 0x07, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x17, 0x00, 0x04, // ................
	0x00, 0x14, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x15, 0x00, 0x04, // ................
	0x00, 0x45, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, // .E... .......+..
	0x00, 0x45, 0x00, 0x00, 0x00, 0x46, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x1c, 0x00, 0x04, // .E...F..........
	0x00, 0x47, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x46, 0x00, 0x00, 0x00, 0x1e, 0x00, 0x03, // .G.......F......
	0x00, 0x48, 0x00, 0x00, 0x00, 0x47, 0x00, 0x00, 0x00, 0x20, 0x00, 0x04, 0x00, 0x49, 0x00, 0x00, // .H...G... ...I..
	0x00, 0x02, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0x3b, 0x00, 0x04, 0x00, 0x49, 0x00, 0x00, // .....H...;...I..
	0x00, 0x4a, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x15, 0x00, 0x04, 0x00, 0x4b, 0x00, 0x00, // .J...........K..
	0x00, 0x20, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, 0x00, 0x4b, 0x00, 0x00, // . .......+...K..
	0x00, 0x4c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x04, 0x00, 0x4d, 0x00, 0x00, // .L....... ...M..
	0x00, 0x02, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, 0x00, 0x4b, 0x00, 0x00, // .........+...K..
	0x00, 0x53, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, 0x00, 0x4b, 0x00, 0x00, // .S.......+...K..
	0x00, 0x54, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, 0x00, 0x06, 0x00, 0x00, // .T.......+......
	0x00, 0x56, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3f, 0x2b, 0x00, 0x04, 0x00, 0x4b, 0x00, 0x00, // .V......?+...K..
	0x00, 0x64, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x2b, 0x00, 0x04, 0x00, 0x45, 0x00, 0x00, // .d.......+...E..
	0x00, 0x6f, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x20, 0x00, 0x04, 0x00, 0x70, 0x00, 0x00, // .o....... ...p..
	0x00, 0x02, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x20, 0x00, 0x04, 0x00, 0x78, 0x00, 0x00, // ......... ...x..
	0x00, 0x01, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x3b, 0x00, 0x04, 0x00, 0x78, 0x00, 0x00, // .........;...x..
	0x00, 0x79, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x3b, 0x00, 0x04, 0x00, 0x78, 0x00, 0x00, // .y.......;...x..
	0x00, 0x7c, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x20, 0x00, 0x04, 0x00, 0x86, 0x00, 0x00, // .|....... ......
	0x00, 0x03, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x3b, 0x00, 0x04, 0x00, 0x86, 0x00, 0x00, // .........;......
	0x00, 0x87, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x36, 0x00, 0x05, 0x00, 0x02, 0x00, 0x00, // .........6......
	0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xf8, 0x00, 0x02, // ................
	0x00, 0x05, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x04, 0x00, 0x07, 0x00, 0x00, 0x00, 0x7d, 0x00, 0x00, // .....=.......}..
	0x00, 0x7c, 0x00, 0x00, 0x00, 0xcf, 0x00, 0x04, 0x00, 0x07, 0x00, 0x00, 0x00, 0xa8, 0x00, 0x00, // .|..............
	0x00, 0x7d, 0x00, 0x00, 0x00, 0x7f, 0x00, 0x04, 0x00, 0x07, 0x00, 0x00, 0x00, 0xaa, 0x00, 0x00, // .}..............
	0x00, 0x7d, 0x00, 0x00, 0x00, 0xd0, 0x00, 0x04, 0x00, 0x07, 0x00, 0x00, 0x00, 0xab, 0x00, 0x00, // .}..............
	0x00, 0xaa, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x07, 0x00, 0x07, 0x00, 0x00, 0x00, 0xac, 0x00, 0x00, // ................
	0x00, 0x01, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0xa8, 0x00, 0x00, 0x00, 0xab, 0x00, 0x00, // .....D..........
	0x00, 0x0c, 0x00, 0x06, 0x00, 0x07, 0x00, 0x00, 0x00, 0xad, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, // ................
	0x00, 0x45, 0x00, 0x00, 0x00, 0xac, 0x00, 0x00, 0x00, 0x41, 0x00, 0x06, 0x00, 0x4d, 0x00, 0x00, // .E.......A...M..
	0x00, 0xb2, 0x00, 0x00, 0x00, 0x4a, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, // .....J...L...L..
	0x00, 0x3d, 0x00, 0x04, 0x00, 0x14, 0x00, 0x00, 0x00, 0xb3, 0x00, 0x00, 0x00, 0xb2, 0x00, 0x00, // .=..............
	0x00, 0x4f, 0x00, 0x08, 0x00, 0x07, 0x00, 0x00, 0x00, 0xb4, 0x00, 0x00, 0x00, 0xb3, 0x00, 0x00, // .O..............
	0x00, 0xb3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, // ................
	0x00, 0x94, 0x00, 0x05, 0x00, 0x06, 0x00, 0x00, 0x00, 0xb5, 0x00, 0x00, 0x00, 0xad, 0x00, 0x00, // ................
	0x00, 0xb4, 0x00, 0x00, 0x00, 0x85, 0x00, 0x05, 0x00, 0x06, 0x00, 0x00, 0x00, 0xb7, 0x00, 0x00, // ................
	0x00, 0xb5, 0x00, 0x00, 0x00, 0x56, 0x00, 0x00, 0x00, 0x81, 0x00, 0x05, 0x00, 0x06, 0x00, 0x00, // .....V..........
	0x00, 0xb8, 0x00, 0x00, 0x00, 0xb7, 0x00, 0x00, 0x00, 0x56, 0x00, 0x00, 0x00, 0x50, 0x00, 0x06, // .........V...P..
	0x00, 0x07, 0x00, 0x00, 0x00, 0xb9, 0x00, 0x00, 0x00, 0xb8, 0x00, 0x00, 0x00, 0xb8, 0x00, 0x00, // ................
	0x00, 0xb8, 0x00, 0x00, 0x00, 0x41, 0x00, 0x06, 0x00, 0x4d, 0x00, 0x00, 0x00, 0xba, 0x00, 0x00, // .....A...M......
	0x00, 0x4a, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, 0x00, 0x53, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x04, // .J...L...S...=..
	0x00, 0x14, 0x00, 0x00, 0x00, 0xbb, 0x00, 0x00, 0x00, 0xba, 0x00, 0x00, 0x00, 0x4f, 0x00, 0x08, // .............O..
	0x00, 0x07, 0x00, 0x00, 0x00, 0xbc, 0x00, 0x00, 0x00, 0xbb, 0x00, 0x00, 0x00, 0xbb, 0x00, 0x00, // ................
	0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x41, 0x00, 0x06, // .............A..
	0x00, 0x4d, 0x00, 0x00, 0x00, 0xbd, 0x00, 0x00, 0x00, 0x4a, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, // .M.......J...L..
	0x00, 0x54, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x04, 0x00, 0x14, 0x00, 0x00, 0x00, 0xbe, 0x00, 0x00, // .T...=..........
	0x00, 0xbd, 0x00, 0x00, 0x00, 0x4f, 0x00, 0x08, 0x00, 0x07, 0x00, 0x00, 0x00, 0xbf, 0x00, 0x00, // .....O..........
	0x00, 0xbe, 0x00, 0x00, 0x00, 0xbe, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, // ................
	0x00, 0x02, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x08, 0x00, 0x07, 0x00, 0x00, 0x00, 0xd9, 0x00, 0x00, // ................
	0x00, 0x01, 0x00, 0x00, 0x00, 0x2e, 0x00, 0x00, 0x00, 0xbc, 0x00, 0x00, 0x00, 0xbf, 0x00, 0x00, // ................
	0x00, 0xb9, 0x00, 0x00, 0x00, 0x41, 0x00, 0x06, 0x00, 0x4d, 0x00, 0x00, 0x00, 0xc1, 0x00, 0x00, // .....A...M......
	0x00, 0x4a, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x04, // .J...L...d...=..
	0x00, 0x14, 0x00, 0x00, 0x00, 0xc2, 0x00, 0x00, 0x00, 0xc1, 0x00, 0x00, 0x00, 0x4f, 0x00, 0x08, // .............O..
	0x00, 0x07, 0x00, 0x00, 0x00, 0xc3, 0x00, 0x00, 0x00, 0xc2, 0x00, 0x00, 0x00, 0xc2, 0x00, 0x00, // ................
	0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x85, 0x00, 0x05, // ................
	0x00, 0x07, 0x00, 0x00, 0x00, 0xc4, 0x00, 0x00, 0x00, 0xd9, 0x00, 0x00, 0x00, 0xc3, 0x00, 0x00, // ................
	0x00, 0x41, 0x00, 0x07, 0x00, 0x70, 0x00, 0x00, 0x00, 0xc9, 0x00, 0x00, 0x00, 0x4a, 0x00, 0x00, // .A...p.......J..
	0x00, 0x4c, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00, 0x6f, 0x00, 0x00, 0x00, 0x3d, 0x00, 0x04, // .L...d...o...=..
	0x00, 0x06, 0x00, 0x00, 0x00, 0xca, 0x00, 0x00, 0x00, 0xc9, 0x00, 0x00, 0x00, 0x51, 0x00, 0x05, // .............Q..
	0x00, 0x06, 0x00, 0x00, 0x00, 0xcb, 0x00, 0x00, 0x00, 0xc4, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // ................
	0x00, 0x51, 0x00, 0x05, 0x00, 0x06, 0x00, 0x00, 0x00, 0xcc, 0x00, 0x00, 0x00, 0xc4, 0x00, 0x00, // .Q..............
	0x00, 0x01, 0x00, 0x00, 0x00, 0x51, 0x00, 0x05, 0x00, 0x06, 0x00, 0x00, 0x00, 0xcd, 0x00, 0x00, // .....Q..........
	0x00, 0xc4, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x50, 0x00, 0x07, 0x00, 0x14, 0x00, 0x00, // .........P......
	0x00, 0xce, 0x00, 0x00, 0x00, 0xcb, 0x00, 0x00, 0x00, 0xcc, 0x00, 0x00, 0x00, 0xcd, 0x00, 0x00, // ................
	0x00, 0xca, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x03, 0x00, 0x87, 0x00, 0x00, 0x00, 0xce, 0x00, 0x00, // .....>..........
	0x00, 0xfd, 0x00, 0x01, 0x00, 0x38, 0x00, 0x01, 0x00, 0x00, 0x00, 0x40, 0x00,                   // .....8.....@.
};
static const uint8_t fs_debugdraw_fill_lit_dx9[406] =
{
	0x46, 0x53, 0x48, 0x06, 0x0f, 0xc8, 0x56, 0x5f, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x75, // FSH...V_.......u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x12, 0x04, 0x00, 0x00, 0x04, 0x00, 0x74, 0x01, 0x00, // _params......t..
	0x00, 0x00, 0x03, 0xff, 0xff, 0xfe, 0xff, 0x20, 0x00, 0x43, 0x54, 0x41, 0x42, 0x1c, 0x00, 0x00, // ....... .CTAB...
	0x00, 0x53, 0x00, 0x00, 0x00, 0x00, 0x03, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00, 0x1c, 0x00, 0x00, // .S..............
	0x00, 0x00, 0x91, 0x00, 0x00, 0x4c, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, // .....L...0......
	0x00, 0x04, 0x00, 0x00, 0x00, 0x3c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x75, 0x5f, 0x70, // .....<.......u_p
	0x61, 0x72, 0x61, 0x6d, 0x73, 0x00, 0xab, 0xab, 0xab, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x04, // arams...........
	0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x73, 0x5f, 0x33, 0x5f, 0x30, 0x00, // .........ps_3_0.
	0x4d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x20, 0x28, 0x52, 0x29, 0x20, 0x48, 0x4c, // Microsoft (R) HL
	0x53, 0x4c, 0x20, 0x53, 0x68, 0x61, 0x64, 0x65, 0x72, 0x20, 0x43, 0x6f, 0x6d, 0x70, 0x69, 0x6c, // SL Shader Compil
	0x65, 0x72, 0x20, 0x31, 0x30, 0x2e, 0x31, 0x00, 0xab, 0x51, 0x00, 0x00, 0x05, 0x04, 0x00, 0x0f, // er 10.1..Q......
	0xa0, 0x00, 0x00, 0x00, 0x3f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // ....?...........
	0x00, 0x1f, 0x00, 0x00, 0x02, 0x05, 0x00, 0x01, 0x80, 0x00, 0x00, 0x07, 0x90, 0x01, 0x00, 0x00, // ................
	0x02, 0x00, 0x00, 0x07, 0x80, 0x00, 0x00, 0xc9, 0x91, 0x5c, 0x00, 0x00, 0x02, 0x00, 0x00, 0x07, // ................
	0x80, 0x00, 0x00, 0xe4, 0x80, 0x5b, 0x00, 0x00, 0x02, 0x01, 0x00, 0x07, 0x80, 0x00, 0x00, 0xd2, // .....[..........
	0x90, 0x05, 0x00, 0x00, 0x03, 0x02, 0x00, 0x07, 0x80, 0x00, 0x00, 0xe4, 0x80, 0x01, 0x00, 0xe4, // ................
	0x80, 0x04, 0x00, 0x00, 0x04, 0x00, 0x00, 0x07, 0x80, 0x01, 0x00, 0xd2, 0x80, 0x00, 0x00, 0xc9, // ................
	0x80, 0x02, 0x00, 0xe4, 0x81, 0x24, 0x00, 0x00, 0x02, 0x01, 0x00, 0x07, 0x80, 0x00, 0x00, 0xe4, // .....$..........
	0x80, 0x08, 0x00, 0x00, 0x03, 0x00, 0x00, 0x01, 0x80, 0x01, 0x00, 0xe4, 0x80, 0x00, 0x00, 0xe4, // ................
	0xa0, 0x04, 0x00, 0x00, 0x04, 0x00, 0x00, 0x01, 0x80, 0x00, 0x00, 0x00, 0x80, 0x04, 0x00, 0x00, // ................
	0xa0, 0x04, 0x00, 0x00, 0xa0, 0x01, 0x00, 0x00, 0x02, 0x01, 0x00, 0x07, 0x80, 0x02, 0x00, 0xe4, // ................
	0xa0, 0x02, 0x00, 0x00, 0x03, 0x00, 0x00, 0x0e, 0x80, 0x01, 0x00, 0x90, 0x81, 0x01, 0x00, 0x90, // ................
	0xa0, 0x04, 0x00, 0x00, 0x04, 0x00, 0x00, 0x07, 0x80, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0xf9, // ................
	0x80, 0x02, 0x00, 0xe4, 0xa0, 0x05, 0x00, 0x00, 0x03, 0x00, 0x08, 0x07, 0x80, 0x00, 0x00, 0xe4, // ................
	0x80, 0x03, 0x00, 0xe4, 0xa0, 0x01, 0x00, 0x00, 0x02, 0x00, 0x08, 0x08, 0x80, 0x03, 0x00, 0xff, // ................
	0xa0, 0xff, 0xff, 0x00, 0x00, 0x00,                                                             // ......
};
static const uint8_t fs_debugdraw_fill_lit_dx11[725] =
{
	0x46, 0x53, 0x48, 0x06, 0x0f, 0xc8, 0x56, 0x5f, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x75, // FSH...V_.......u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x12, 0x04, 0x00, 0x00, 0x04, 0x00, 0xb0, 0x02, 0x00, // _params.........
	0x00, 0x44, 0x58, 0x42, 0x43, 0x59, 0x1c, 0xf9, 0xc6, 0x41, 0xb7, 0xae, 0xfd, 0xa5, 0xa5, 0x0c, // .DXBCY...A......
	0x28, 0x25, 0x0d, 0x24, 0x29, 0x01, 0x00, 0x00, 0x00, 0xb0, 0x02, 0x00, 0x00, 0x03, 0x00, 0x00, // (%.$)...........
	0x00, 0x2c, 0x00, 0x00, 0x00, 0x9c, 0x00, 0x00, 0x00, 0xd0, 0x00, 0x00, 0x00, 0x49, 0x53, 0x47, // .,...........ISG
	0x4e, 0x68, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x50, 0x00, 0x00, // Nh...........P..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // ................
	0x00, 0x0f, 0x00, 0x00, 0x00, 0x5c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // ................
	0x00, 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x5c, 0x00, 0x00, // ................
	0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, // ................
	0x00, 0x07, 0x07, 0x00, 0x00, 0x53, 0x56, 0x5f, 0x50, 0x4f, 0x53, 0x49, 0x54, 0x49, 0x4f, 0x4e, // .....SV_POSITION
	0x00, 0x54, 0x45, 0x58, 0x43, 0x4f, 0x4f, 0x52, 0x44, 0x00, 0xab, 0xab, 0xab, 0x4f, 0x53, 0x47, // .TEXCOORD....OSG
	0x4e, 0x2c, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, // N,........... ..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // ................
	0x00, 0x0f, 0x00, 0x00, 0x00, 0x53, 0x56, 0x5f, 0x54, 0x41, 0x52, 0x47, 0x45, 0x54, 0x00, 0xab, // .....SV_TARGET..
	0xab, 0x53, 0x48, 0x44, 0x52, 0xd8, 0x01, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x76, 0x00, 0x00, // .SHDR....@...v..
	0x00, 0x59, 0x00, 0x00, 0x04, 0x46, 0x8e, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, // .Y...F. ........
	0x00, 0x62, 0x10, 0x00, 0x03, 0x72, 0x10, 0x10, 0x00, 0x02, 0x00, 0x00, 0x00, 0x65, 0x00, 0x00, // .b...r.......e..
	0x03, 0xf2, 0x20, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x68, 0x00, 0x00, 0x02, 0x03, 0x00, 0x00, // .. ......h......
	0x00, 0x36, 0x00, 0x00, 0x06, 0x72, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x96, 0x14, 0x10, // .6...r..........
	0x80, 0x41, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x00, 0x05, 0x72, 0x00, 0x10, // .A...........r..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x00, // .....F..........
	0x05, 0x72, 0x00, 0x10, 0x00, 0x01, 0x00, 0x00, 0x00, 0x26, 0x19, 0x10, 0x00, 0x02, 0x00, 0x00, // .r.......&......
	0x00, 0x38, 0x00, 0x00, 0x07, 0x72, 0x00, 0x10, 0x00, 0x02, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, // .8...r.......F..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, 0x00, 0x01, 0x00, 0x00, 0x00, 0x32, 0x00, 0x00, // .....F.......2..
	0x0a, 0x72, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x26, 0x09, 0x10, 0x00, 0x01, 0x00, 0x00, // .r.......&......
	0x00, 0x96, 0x04, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, 0x80, 0x41, 0x00, 0x00, // .........F...A..
	0x00, 0x02, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x07, 0x82, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, // ................
	0x00, 0x46, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, // .F.......F......
	0x00, 0x44, 0x00, 0x00, 0x05, 0x82, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3a, 0x00, 0x10, // .D...........:..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x07, 0x72, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, // .....8...r......
	0x00, 0xf6, 0x0f, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, // .........F......
	0x00, 0x10, 0x00, 0x00, 0x08, 0x12, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x02, 0x10, // .............F..
	0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x82, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // .....F. ........
	0x00, 0x32, 0x00, 0x00, 0x09, 0x12, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x10, // .2..............
	0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3f, 0x01, 0x40, 0x00, // ......@.....?.@.
	0x00, 0x00, 0x00, 0x00, 0x3f, 0x00, 0x00, 0x00, 0x0a, 0xe2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, // ....?...........
	0x00, 0x06, 0x89, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x89, 0x20, // ... ........... 
	0x80, 0x41, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x32, 0x00, 0x00, // .A...........2..
	0x0a, 0x72, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, // .r..............
	0x00, 0x96, 0x07, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x82, 0x20, 0x00, 0x00, 0x00, 0x00, // .........F. ....
	0x00, 0x02, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x08, 0x72, 0x20, 0x10, 0x00, 0x00, 0x00, 0x00, // .....8...r .....
	0x00, 0x46, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46, 0x82, 0x20, 0x00, 0x00, 0x00, 0x00, // .F.......F. ....
	0x00, 0x03, 0x00, 0x00, 0x00, 0x36, 0x00, 0x00, 0x06, 0x82, 0x20, 0x10, 0x00, 0x00, 0x00, 0x00, // .....6.... .....
	0x00, 0x3a, 0x80, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, // .:. .........>..
	0x01, 0x00, 0x00, 0x40, 0x00,                                                                   // ...@.
};
static const uint8_t fs_debugdraw_fill_lit_mtl[686] =
{
	0x46, 0x53, 0x48, 0x06, 0x0f, 0xc8, 0x56, 0x5f, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x08, 0x75, // FSH...V_.......u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x12, 0x04, 0x00, 0x00, 0x04, 0x00, 0x89, 0x02, 0x00, // _params.........
	0x00, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, 0x65, 0x20, 0x3c, 0x6d, 0x65, 0x74, 0x61, 0x6c, // .#include <metal
	0x5f, 0x73, 0x74, 0x64, 0x6c, 0x69, 0x62, 0x3e, 0x0a, 0x23, 0x69, 0x6e, 0x63, 0x6c, 0x75, 0x64, // _stdlib>.#includ
	0x65, 0x20, 0x3c, 0x73, 0x69, 0x6d, 0x64, 0x2f, 0x73, 0x69, 0x6d, 0x64, 0x2e, 0x68, 0x3e, 0x0a, // e <simd/simd.h>.
	0x0a, 0x75, 0x73, 0x69, 0x6e, 0x67, 0x20, 0x6e, 0x61, 0x6d, 0x65, 0x73, 0x70, 0x61, 0x63, 0x65, // .using namespace
	0x20, 0x6d, 0x65, 0x74, 0x61, 0x6c, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, //  metal;..struct 
	0x5f, 0x47, 0x6c, 0x6f, 0x62, 0x61, 0x6c, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, // _Global.{.    fl
	0x6f, 0x61, 0x74, 0x34, 0x20, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x34, 0x5d, // oat4 u_params[4]
	0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, 0x74, 0x20, 0x78, 0x6c, 0x61, // ;.};..struct xla
	0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x6f, 0x75, 0x74, 0x0a, 0x7b, 0x0a, 0x20, // tMtlMain_out.{. 
	0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x20, 0x62, 0x67, 0x66, 0x78, 0x5f, 0x46, //    float4 bgfx_F
	0x72, 0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x30, 0x20, 0x5b, 0x5b, 0x63, 0x6f, 0x6c, 0x6f, 0x72, // ragData0 [[color
	0x28, 0x30, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x73, 0x74, 0x72, 0x75, 0x63, // (0)]];.};..struc
	0x74, 0x20, 0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x69, 0x6e, // t xlatMtlMain_in
	0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x33, 0x20, 0x76, 0x5f, // .{.    float3 v_
	0x77, 0x6f, 0x72, 0x6c, 0x64, 0x20, 0x5b, 0x5b, 0x75, 0x73, 0x65, 0x72, 0x28, 0x6c, 0x6f, 0x63, // world [[user(loc
	0x6e, 0x31, 0x29, 0x5d, 0x5d, 0x3b, 0x0a, 0x7d, 0x3b, 0x0a, 0x0a, 0x66, 0x72, 0x61, 0x67, 0x6d, // n1)]];.};..fragm
	0x65, 0x6e, 0x74, 0x20, 0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, // ent xlatMtlMain_
	0x6f, 0x75, 0x74, 0x20, 0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x28, // out xlatMtlMain(
	0x78, 0x6c, 0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x69, 0x6e, 0x20, 0x69, // xlatMtlMain_in i
	0x6e, 0x20, 0x5b, 0x5b, 0x73, 0x74, 0x61, 0x67, 0x65, 0x5f, 0x69, 0x6e, 0x5d, 0x5d, 0x2c, 0x20, // n [[stage_in]], 
	0x63, 0x6f, 0x6e, 0x73, 0x74, 0x61, 0x6e, 0x74, 0x20, 0x5f, 0x47, 0x6c, 0x6f, 0x62, 0x61, 0x6c, // constant _Global
	0x26, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x20, 0x5b, 0x5b, 0x62, 0x75, 0x66, 0x66, 0x65, // & _mtl_u [[buffe
	0x72, 0x28, 0x30, 0x29, 0x5d, 0x5d, 0x29, 0x0a, 0x7b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x78, 0x6c, // r(0)]]).{.    xl
	0x61, 0x74, 0x4d, 0x74, 0x6c, 0x4d, 0x61, 0x69, 0x6e, 0x5f, 0x6f, 0x75, 0x74, 0x20, 0x6f, 0x75, // atMtlMain_out ou
	0x74, 0x20, 0x3d, 0x20, 0x7b, 0x7d, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x6f, 0x75, 0x74, 0x2e, // t = {};.    out.
	0x62, 0x67, 0x66, 0x78, 0x5f, 0x46, 0x72, 0x61, 0x67, 0x44, 0x61, 0x74, 0x61, 0x30, 0x20, 0x3d, // bgfx_FragData0 =
	0x20, 0x66, 0x6c, 0x6f, 0x61, 0x74, 0x34, 0x28, 0x6d, 0x69, 0x78, 0x28, 0x5f, 0x6d, 0x74, 0x6c, //  float4(mix(_mtl
	0x5f, 0x75, 0x2e, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x32, 0x5d, 0x2e, 0x78, // _u.u_params[2].x
	0x79, 0x7a, 0x2c, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x75, 0x5f, 0x70, 0x61, 0x72, // yz, _mtl_u.u_par
	0x61, 0x6d, 0x73, 0x5b, 0x31, 0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x2c, 0x20, 0x66, 0x6c, 0x6f, 0x61, // ams[1].xyz, floa
	0x74, 0x33, 0x28, 0x28, 0x64, 0x6f, 0x74, 0x28, 0x6e, 0x6f, 0x72, 0x6d, 0x61, 0x6c, 0x69, 0x7a, // t3((dot(normaliz
	0x65, 0x28, 0x63, 0x72, 0x6f, 0x73, 0x73, 0x28, 0x64, 0x66, 0x64, 0x78, 0x28, 0x69, 0x6e, 0x2e, // e(cross(dfdx(in.
	0x76, 0x5f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x29, 0x2c, 0x20, 0x64, 0x66, 0x64, 0x79, 0x28, 0x2d, // v_world), dfdy(-
	0x69, 0x6e, 0x2e, 0x76, 0x5f, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x29, 0x29, 0x29, 0x2c, 0x20, 0x5f, // in.v_world))), _
	0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x30, // mtl_u.u_params[0
	0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x29, 0x20, 0x2a, 0x20, 0x30, 0x2e, 0x35, 0x29, 0x20, 0x2b, 0x20, // ].xyz) * 0.5) + 
	0x30, 0x2e, 0x35, 0x29, 0x29, 0x20, 0x2a, 0x20, 0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x75, // 0.5)) * _mtl_u.u
	0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, 0x33, 0x5d, 0x2e, 0x78, 0x79, 0x7a, 0x2c, 0x20, // _params[3].xyz, 
	0x5f, 0x6d, 0x74, 0x6c, 0x5f, 0x75, 0x2e, 0x75, 0x5f, 0x70, 0x61, 0x72, 0x61, 0x6d, 0x73, 0x5b, // _mtl_u.u_params[
	0x33, 0x5d, 0x2e, 0x77, 0x29, 0x3b, 0x0a, 0x20, 0x20, 0x20, 0x20, 0x72, 0x65, 0x74, 0x75, 0x72, // 3].w);.    retur
	0x6e, 0x20, 0x6f, 0x75, 0x74, 0x3b, 0x0a, 0x7d, 0x0a, 0x0a, 0x00, 0x00, 0x40, 0x00,             // n out;.}....@.
};
extern const uint8_t* fs_debugdraw_fill_lit_pssl;
extern const uint32_t fs_debugdraw_fill_lit_pssl_size;

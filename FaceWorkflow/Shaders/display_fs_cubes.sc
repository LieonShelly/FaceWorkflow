
$input v_texcoord0

/*
 * Copyright 2011-2018 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include "common/common.sh"

SAMPLER2D(display_texColor, 0);

void main()
{
        gl_FragColor = vec4(texture2D(display_texColor, v_texcoord0).rgb, 1.0);
}

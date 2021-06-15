$input v_texcoord0

/*
 * Copyright 2011-2018 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include "common/common.sh"

SAMPLER2D(s_texColor, 0);

void main()
{
    if (v_texcoord0.x > 0.5)
    {
        vec4 color = vec4(texture2D(s_texColor, v_texcoord0).rgb, 1.0);
        float gray = color.r*0.299 + color.g*0.587 + color.b*0.114;
        gl_FragColor = vec4(gray, gray, gray, color.a);
    }
    else
    {
        gl_FragColor = vec4(texture2D(s_texColor, v_texcoord0).rgb, 1.0);
    }
}

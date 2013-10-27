//
//  Shader.fsh
//  Ludo
//
//  Created by Sid on 26/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

varying lowp vec4 v_Color;

void main()
{
    gl_FragColor = v_Color;
}

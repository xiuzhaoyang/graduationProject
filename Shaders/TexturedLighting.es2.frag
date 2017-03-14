static const char* SimpleFragmentShader = STRINGIFY(
                                                    
varying lowp vec4 DestinationColor;
varying highp vec2 TextureCoordOut;

uniform sampler2D Sampler;
uniform int isOn;

void main(void)
{
//    gl_FragColor = texture2D(Sampler, TextureCoordOut) * DestinationColor;
//    vec2 test = fwidth(TextureCoordOut);
    highp float sawtooth = fract(TextureCoordOut.y / 4.0);
    highp float triangle = abs(2.0 * sawtooth - 1.0);
    if(isOn > 0)
    {
        
        highp float square = smoothstep(0.47,0.53,triangle);
        
        gl_FragColor = vec4(square, square, square, 1.0);
    }
    else
    {
        lowp float color = 1.0;

        if(triangle < 0.5)
        {
           color=0.0;
        }

        gl_FragColor = vec4(color, color, color, 1.0);
    }
}
);

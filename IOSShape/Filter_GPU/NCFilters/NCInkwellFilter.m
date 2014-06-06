

#import "NCInkwellFilter.h"

NSString *const kNCInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
);

@implementation NCInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kNCInkWellShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end

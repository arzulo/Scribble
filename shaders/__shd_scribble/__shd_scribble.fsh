//   @jujuadams   v8.0.0   2020-03-16
precision highp float;

#define USE_ALPHA_FOR_DISTANCE true

varying vec2  v_vPosition;
varying vec2  v_vTexcoord;
varying vec4  v_vColour;
varying float v_fPremultiplyAlpha;

uniform float u_fSDF;
uniform vec4  u_vFlash;
uniform vec4  u_vClip;

//SDF-only
uniform vec2  u_vTexel;
uniform float u_fSDFRange;
uniform float u_fSDFThicknessOffset;
uniform vec4  u_vShadowColour;
uniform vec3  u_vShadowOffsetAndSoftness;
uniform vec3  u_vBorderColour;
uniform float u_fBorderThickness;
uniform float u_fSecondDraw;

float SDFValue(vec2 texcoord)
{
    vec4 sample = texture2D(gm_BaseTexture, texcoord);
    return (USE_ALPHA_FOR_DISTANCE? sample.a : max(sample.r, max(sample.g, sample.b))) + u_fSDFThicknessOffset;
}

void main()
{
    if ((length(u_vClip) > 0.0) && ((v_vPosition.x < u_vClip.x) || (v_vPosition.y < u_vClip.y) || (v_vPosition.x > u_vClip.z) || (v_vPosition.y > u_vClip.w)))
    {
        gl_FragColor = vec4(0.0);
    }
    else
    {
        if (u_fSDF < 0.5)
        {
            //Standard rendering (standard fonts, spritefonts, sprites, surfaces)
            gl_FragColor = v_vColour*texture2D(gm_BaseTexture, v_vTexcoord);
            gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFlash.rgb, u_vFlash.a);
        }
        else
        {
            //SDF rendering
            float smoothness = 1.0;
            
            float baseDist = SDFValue(v_vTexcoord);
            float spread = max(fwidth(baseDist), 0.001);    
            
            float alpha = smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist);   
            gl_FragColor = vec4(v_vColour.rgb, alpha*v_vColour.a);
            
            if (u_fSecondDraw < 0.5)
            {
                float borderOffset = u_fBorderThickness*length(fwidth(v_vTexcoord)/u_vTexel)/(sqrt(2.0)*u_fSDFRange);
                
                if (u_fBorderThickness > 0.0)
                {
                    gl_FragColor.rgb = mix(u_vBorderColour, gl_FragColor.rgb, gl_FragColor.a);
                    gl_FragColor.a = max(gl_FragColor.a, smoothstep(0.5 - smoothness*spread, 0.5 + smoothness*spread, baseDist + borderOffset));
                }
                
                if (u_vShadowColour.a > 0.0)
                {
                    float alphaShadow = u_vShadowColour.a*smoothstep(0.5 - spread*u_vShadowOffsetAndSoftness.z, 0.5 + spread*u_vShadowOffsetAndSoftness.z, SDFValue(v_vTexcoord - u_vShadowOffsetAndSoftness.xy*fwidth(v_vTexcoord)) + borderOffset);
                    
                    float outAlpha = gl_FragColor.a + alphaShadow*(1.0 - gl_FragColor.a);
                    gl_FragColor.rgb = (gl_FragColor.rgb*gl_FragColor.a + u_vShadowColour.rgb*alphaShadow*(1.0 - gl_FragColor.a)) / outAlpha;
                    gl_FragColor.a = outAlpha;
                }
            }
            
            gl_FragColor.rgb = mix(gl_FragColor.rgb, u_vFlash.rgb, u_vFlash.a);
            gl_FragColor.a *= v_vColour.a;
        }
        
        //Apply premultiply alpha if necessary
        gl_FragColor.rgb *= 1.0 - v_fPremultiplyAlpha*(1.0 + gl_FragColor.a);
    }
}
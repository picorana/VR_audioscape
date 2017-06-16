#define PROCESSING_TEXTURE_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
    vec3 fogColor = vec3(0.0,0.0,0.0);
    gl_FragColor = texture2D(texture, vertTexCoord.st) * vertColor;
    float depth = gl_FragCoord.z / gl_FragCoord.w;
    float fogFactor = smoothstep(400.0, 600.0, depth);
    gl_FragColor = mix(gl_FragColor, vec4(fogColor, gl_FragColor.w), fogFactor);
}


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
uniform sampler2D texture;
uniform vec2 pixelSize;
uniform vec2 pixelOffset;
 
varying vec4 vertColor;
varying vec4 vertTexCoord;
 
void main() {
    int si = int(vertTexCoord.s * pixelSize.s);
    int sj = int(vertTexCoord.t * pixelSize.t);  
    gl_FragColor = texture2D(texture, vec2(float(si) / pixelSize.s, float(sj) / pixelSize.t) + pixelOffset) * vertColor;
}

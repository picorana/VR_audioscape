#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
/*
varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying float distToCamera;

void main() {
  //vec3 direction = normalize(lightDir);
  //vec3 normal = normalize(ecNormal);
  //float intensity = max(0.0, dot(direction, normal));
  //gl_FragColor = vec4(intensity, intensity, intensity, 1) * vertColor;
    vec4 cs_position = glModelViewMatrix * gl_Vertex;
    distToCamera = -cs_position.z;
    gl_Position = gl_ProjectionMatrix * cs_position;  
    gl_FragColor = vec4(distToCamera, distToCamera, distToCamera, 1) * vertColor;  
}*/

uniform mat4 orthographicMatrix;
varying vec3 position;

void main(void) {
        vec4 clipSpace = orthographicMatrix * vec4(position, 1.0);
        gl_FragColor = vec4(clipSpace.zzz, 1.0);
}

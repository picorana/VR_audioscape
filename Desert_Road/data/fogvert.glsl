#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec4 vertex;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vPosition;
varying vec4 eye;

void main() {
  gl_Position = transform * vertex;
  vPosition = vec3(gl_Position.x, gl_Position.y, gl_Position.z);
  vertColor = color;
  vertNormal = normalize(normalMatrix * normal);
  eye = -(modelViewMatrix * position);
}

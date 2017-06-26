#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform mat4 transform;

attribute vec4 position;
attribute vec4 color;

varying vec4 vertColor;
varying vec3 vPosition;

void main() {
  gl_Position = transform * position;
  vPosition = vec3(gl_Position.x, gl_Position.y, gl_Position.z);
  vertColor = color;
}

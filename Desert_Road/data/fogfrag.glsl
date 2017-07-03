#define PROCESSING_COLOR_SHADER

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vPosition;
varying vec4 eye;

uniform vec3 fogColor;
uniform float fogMinDistance;
uniform float fogMaxDistance;

uniform bool lightingEnabled;

void main() {

    vec4 ambient = vec4(0.1, 0.1, 0.1, 0.1);

    vec3 vertLightDir = vec3(0, -0.5, 1);

    gl_FragColor = vertColor;
    
    float depth = gl_FragCoord.z / gl_FragCoord.w;

    float fogFactor = smoothstep(fogMinDistance, fogMaxDistance, depth);

    if (lightingEnabled){

        vec4 diffuse = vertColor;

        vec4 spec = vec4(0.0);
        vec4 specular = vec4(1);
         
        // normalize both input vectors
        vec3 n = vertNormal;
        vec3 e = normalize(vec3(eye));
     
        float intensity = max(dot(n,vertLightDir), 0.0);
        float shininess = 0.1;
     
        // if the vertex is lit compute the specular color
        if (intensity > 0.0) {
            vec3 h = normalize(vertLightDir + e);  
            float intSpec = max(dot(h,n), 0.0);
            spec = specular * pow(intSpec,shininess);
        }

        gl_FragColor = max(intensity*diffuse + spec, ambient);

    }
    
    if (depth<2400) gl_FragColor = mix(gl_FragColor, vec4(fogColor, gl_FragColor.w), fogFactor);

} 

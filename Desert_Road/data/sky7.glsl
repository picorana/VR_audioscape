

uniform float iGlobalTime;
uniform sampler2D iChannel0;
uniform vec2 iResolution;
uniform vec2 iMouse;

#define RGB vec3

const RGB _HorizonColor = RGB(0.80147, 0.80147, 0.80147) ;

// cloud layer thickness, upscale for softer clouds
#define CLOUD_SPREAD 0.001
// increase as thickness increases to avoid visible stepping
#define CLOUD_STEPS 10.0
// noise tiling scale, decrease for larger cloud areas
#define CLOUD_STRETCH 0.0045
// add value to make scene overall scene more hazy / cloudy
#define CLOUD_BIAS -0.1
// additional fuzz
#define PERLIN 0.05
    

float hash( float n ) { return fract(sin(n)*43758.5453123); }
float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
	
    float n = p.x + p.y*157.0;
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                   mix( hash(n+157.0), hash(n+158.0),f.x),f.y);
}
const mat2 brownian_transform = mat2(0.8, 0.6, -0.6, 0.8);
float brownian(in vec2 x)
{
    float o = noise(x);
    x *= 2.0;
    x *= brownian_transform;
    o += noise(x) * 0.5;
    x *= 2.0;
    x *= brownian_transform;
    o += noise(x) * 0.25;
    x *= 2.0;
    x *= brownian_transform;
    o += noise(x) * 0.125;
    return o / 1.875;
}

float Perlin(vec2 p)
{
    float perlin = noise(p) * 0.5;
    perlin += noise(p * 2.0) * 0.25;
    perlin += noise(p * 4.0) * 0.125;
    perlin += noise(p * 8.0) * 0.0625;
    return perlin;
}

void Rotate(inout vec2 p, float a)
{
    float sa = sin(a);
    float ca = cos(a);
    p *= mat2(ca, -sa, sa, ca);
}


float Clouds(vec3 dir, out float dist)
{
    const float sky_height = 200.0;
    dist = -sky_height / dir.y;
    vec3 clouds_intersection = dir * dist;
    
    float tw = 0.0;
    float clouds = 0.0;
    const float s = 1.0 / CLOUD_STEPS;
    for(float i = 0.0 ; i < 1.0 ; i += s)
    {
    	clouds += brownian(iGlobalTime/10.0 + clouds_intersection.xz * (CLOUD_STRETCH + CLOUD_SPREAD * i)) * (1.0 - i);
        tw += 1.0 - i;
    }
    clouds /= tw;
    
    #ifdef PERLIN
    float perlin = Perlin(clouds_intersection.xz * 0.1 + iGlobalTime/10.0);
    clouds = clouds - perlin * PERLIN;
    #endif
    
    clouds = max(0.0, pow(clouds - 0.2, 2.0) * 6.0 + CLOUD_BIAS);
    return clouds;
}


vec3 Ray(vec2 uv) {
    vec3 dir = normalize(vec3(uv, 2.5));
    Rotate(dir.yz, iMouse.y * -0.004);
    Rotate(dir.xz, iMouse.x * -0.008);
    return dir;
}


vec3 Sky(vec3 dir) {
    
    vec3 sun_direction = normalize(vec3(-1.0, -0.4, -1.0));
    
    
    vec3 cl = vec3(0.67128, 0.94118, 0.69204);
    // add gradient to atmosphere
    cl = mix(vec3(0.67128, 0.94118, 0.69204), cl, pow(dir.y, 0.45));
    // add sun to atmosphere
    float sun = pow(max(0.0, dot(dir, -sun_direction)), 600.0);
    cl = mix(cl, vec3(2.5, 1.8, 0.6), sun);
    
    
    // compute cloud layers
    float p;
    float clouds = Clouds(dir, p);
    
    #ifdef APPROXIMATE_NORMAL
    
    float dt = 0.025;
    
    vec3 right = cross(vec3(0.0, 1.0, 0.0), dir);
    vec3 up = cross(right, dir);
    
    float clouds_right = Clouds(normalize(dir + right * dt), p);
    float clouds_above = Clouds(normalize(dir - up * dt), p);
    
    vec2 n = vec2(clouds_right - clouds, clouds - clouds_above) * 2.0;
    vec3 normal = normalize(n.x * right + n.y * up + dir);
    
    // lighting
    float o = dot(normal, sun_direction) * 0.6 + 0.3;
    #else
    float o = dot(dir, sun_direction) * 0.6 + 0.3;
    #endif
    o = mix(1.0, o, clamp(clouds * 0.01, 0.0, 1.0));
    
    // add clouds to atmosphere
    cl = mix(cl, vec3(o, o, o), clamp(clouds, 0.0, 1.0));
    
    return cl;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	vec2 uv = fragCoord.xy / iResolution.xy * 2.0 - 1.0;
    uv.x *= (iResolution.x) / iResolution.y;
    
    
    vec3 dir = Ray(uv);
    float d = 2.0 / dir.y;
     
    
    vec3 sun_direction = normalize(vec3(-1.0, -0.4, -1.0));
    
    vec3 cl = Sky(dir);
    
    // render floor, fog
    if(dir.y < 0.0) { cl = vec3(1, 0.96957, 0.88235); }
    float p;
    Clouds(dir, p);
    d = -min(d, p);
    cl = mix(cl, vec3(0.67128, 0.94118, 0.69204), pow(1.0 - abs(dir.y), 30.0));
	fragColor = vec4(cl, 1.0);
}

void main() {
    mainImage(gl_FragColor,gl_FragCoord.xy);
}

shader_type spatial;

const float PI = 3.14159265358979323846;

uniform sampler2D noise;
uniform float scale;
uniform float roughness = 0.8;
uniform float metalness = 0.0;
uniform float h_min = 0.3;
uniform float h_max = 0.4;
uniform float s_min = 0.62;
uniform float s_max = 0.9;
uniform float v_min = 0.23;
uniform float v_max = 0.5;
uniform float ramp_start = 0.0;
uniform float ramp_end = 1.0;
uniform float ramp_pow = 1.0;
uniform vec4 ramp_color : hint_color;

varying vec3 wpos;
varying vec3 vpos;
float remap(float value, float from1, float to1, float from2, float to2) {
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
}

vec4 hsv_to_rgb(float h, float s, float v, float a){
    //based on 
    //https://stackoverflow.com/questions/51203917/math-behind-hsv-to-rgb-conversion-of-colors
    // So it needs values from 0 to 1
    float r;
    float g;
    float b;

    float i = floor(h*6.0);
    float f = h*6.0 -i;
    float p = v*(1.0-s);
    float q = v*(1.0-f*s);
    float t = v* (1.0-(1.0-f)*s);

    int cond = int(i)%6;

    if (cond == 0){
        r = v; g = t; b = p;
    }
    else if (cond == 1){
        r = q; g = v; b = p;
    }
    else if (cond == 2){
        r = p; g = v; b = t;
    }
    else if (cond == 3){
        r = p; g = q; b = v;
    }
    else if (cond == 4){
        r = t; g = p; b = v;
    }
    else if (cond == 5){
        r = v; g = p; b = q;
    }
    else {
        // THIS SHOULD NEVER HAPPEN
        r = 0.0; g = 0.0; b = 0.0;
    }
    return vec4(r,g,b,a);



    return vec4(0.5,1.0,0.0,1.0);
}

float atan2(float x, float y){
    if (x > 0.0){
        return atan(y/x);
    }
    else if (x < 0.0){
        if (y >= 0.0){
            return atan(y/x) + PI;
        }
        else {
            return atan(y/x) - PI;
        }
    }
    else { // This is x=0
        if(y > 0.0){
            return PI/2.0;
        }
        else {
            // This includes the actually undefined x=y=0 case
            return -PI/2.0;
        }
    }
}

vec2 cartesian_to_polar(vec2 XY){
    float r = length(XY);
    float phi = (atan2(XY[0],XY[1]) + PI)/(2.0*PI);
    return vec2(r,phi);
}

void vertex() {
	wpos = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vpos = VERTEX;
}

void fragment() {
	float h = texture(noise, wpos.xz * scale).r;
	float s = texture(noise, wpos.xz * scale + vec2(10.5)).r;
	float v = texture(noise, wpos.xz * scale + vec2(20.5)).r;
	h = remap(h, 0.3, 0.6, h_min, h_max);
	s = remap(s, 0.3, 0.6, s_min, s_max);
	v = remap(v, 0.3, 0.6, v_min, v_max);
	float grad = clamp(pow(remap(vpos.y, ramp_end, ramp_start, 0.0, 1.0), ramp_pow), 0.0, 1.0);
	ALBEDO = mix(hsv_to_rgb(h, s, v, 1.0).rgb, ramp_color.rgb, grad);
	ROUGHNESS = roughness;
	METALLIC = metalness;
}
shader_type spatial;
render_mode blend_add;

uniform sampler2D noise;
uniform sampler2D gradient;
uniform float fade = 3.0;
uniform float speed = 1.0;
uniform float emission = 0.5;
uniform sampler2D height_gradient;

vec2 transformCoords(in vec2 st, float x, float y) {
    return vec2(st.x + x, st.y + y);
}

vec2 distortCoords(in vec2 st, in float strength, in float map) {
    map -= 0.5;
    vec2 ou = st + map*strength;
    return ou;
}

float fire(vec2 st) {
    //move up coords
    vec2 cTransp = transformCoords(st, 0, -TIME * speed);
    
    //distort coords
    float distNoise = texture(noise, st).r;
    cTransp = distortCoords(cTransp, .1, distNoise);

    //generate noise
    float firenoise = texture(noise, cTransp).r;
    firenoise = 1.3*pow(firenoise, st.y * 6.0); //maybe UV
    return firenoise;
}


vec3 cartoonFire(vec2 st) {
    float exponent = fade;
    float firenoise = pow(fire(st), exponent);
    vec3 c;
	
	c = texture(gradient, vec2(firenoise + texture(height_gradient, st).r - 1.0, 0.0)).rgb;
    
    return c;
}

void fragment() {
	EMISSION = cartoonFire(UV) * emission;
	ALBEDO = cartoonFire(UV);
	SPECULAR = 0.0;
}
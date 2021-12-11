shader_type spatial;

uniform vec4 color : hint_color;
uniform sampler2D noise;
uniform float scale = 1.0;
uniform float normal_strength = 0.2;
uniform float roughness = 0.2;
uniform float specular = 0.2;

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	NORMALMAP = texture(noise, UV).xyz * vec3(2.0,2.0,1.0) - vec3(1.0,1.0,0.0);
	NORMALMAP_DEPTH = normal_strength;
}
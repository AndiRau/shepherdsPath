shader_type spatial;

uniform vec2 player_position = vec2(0.2, 0.5);

uniform sampler2D maptexture : hint_albedo;

uniform vec2 pointsize = vec2(0.02, 0.016);

void fragment() {
	float c = 0.0;
	bool inX = player_position.x + pointsize.x > UV.x && player_position.x - pointsize.x < UV.x;
	bool inY = player_position.y + pointsize.y > UV.y && player_position.y - pointsize.y < UV.y;
	
	if (inX && inY) {
		c = 1.0;
	}
	
	ALBEDO = texture(maptexture, UV).rgb + vec3(c);
}


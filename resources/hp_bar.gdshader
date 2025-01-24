shader_type canvas_item;

uniform float hp = 10;
uniform float max_hp = 10;

void fragment() {
	COLOR = vec4(vec3(1.0) * step(UV.x, hp / max_hp), 1.0);
}

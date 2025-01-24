shader_type canvas_item;

uniform float current_time = 5;
uniform float wait_time = 5;

void fragment() {
	vec2 uv = UV*2.0 - 1.0;
	float r = length(uv);
	float theta = (atan(uv.y, uv.x) + PI) / TAU;
	
	COLOR.rgb = vec3(1.0);
	COLOR.a = step(current_time / wait_time, 1.0 - theta);
	COLOR.a *= step(r, 1.0);
}
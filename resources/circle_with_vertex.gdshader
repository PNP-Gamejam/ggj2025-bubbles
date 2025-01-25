shader_type canvas_item;

uniform vec4 color: source_color = vec4(.0,.0,.0,1.0);
varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	float rad = length(UV * 2.0 - 1.0);
	COLOR = color * step(rad, 1.0);
	COLOR = COLOR * vertex_color;
}

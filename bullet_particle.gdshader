shader_type canvas_item;

varying vec4 color_vertex;

void vertex() {
	color_vertex = COLOR;
}

void fragment() {
	float r = length(UV * 2.0 - 1.0);
	COLOR.a = step(r, .6);
	COLOR = color_vertex * COLOR;
}


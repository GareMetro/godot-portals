shader_type spatial;
render_mode unshaded;

uniform sampler2D portal_tex : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = SCREEN_UV;
	vec4 albedo = texture(portal_tex, base_uv);
	ALBEDO = albedo.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

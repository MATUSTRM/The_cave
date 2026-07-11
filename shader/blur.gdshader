shader_type canvas_item;
// MOSTLY MAD PRODUCTION TUTORIAL SHADER
uniform sampler2D screentexture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0,5.0) = 1.5;
void fragment() {
	vec3 result = textureLod(screentexture,SCREEN_UV, blur_amount).rgb;
	COLOR.rgb = result;
	// Called for every pixel the material is visible on.
}

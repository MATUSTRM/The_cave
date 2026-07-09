shader_type canvas_item;

uniform vec4 base_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
	
}

void fragment() {
	vec3 fog_color1 = texture(TEXTURE, vec2(UV.x / 2.0 + TIME/100.0 , UV.y / 4.0 - TIME /100.0)).rgb;
	vec3 fog_color2 = texture(TEXTURE, vec2(UV.x / 2.0 + 0.5 + TIME/50.0, UV.y / 4.0 + 0.5 - TIME /160.0)).rgb;
	vec3 fog_color3 = texture(TEXTURE, vec2(UV.x / 2.0 + 0.25 + TIME/25.0, UV.y / 4.0 - 0.25 + TIME /160.0)).rgb;
	
	vec3 fog_color = mix(fog_color3, mix(fog_color1, fog_color2,0.5),0.7);
	
	COLOR.a *= base_color.a * fog_color.r * 1.5;
	COLOR.rgb = fog_color * base_color.rgb;
	
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

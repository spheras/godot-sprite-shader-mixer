//GREYSCALE
uniform bool  GREYSCALE_active  = true;
uniform vec3  GREYSCALE_TintColor : source_color = vec3(1.0);
uniform float GREYSCALE_Luminosity : hint_range(-1.0, 1.0) = 0.0;
uniform float GREYSCALE_Blend : hint_range(0.0, 1.0) = 1.0;
void greyscale(in vec2 uv, in sampler2D tex, vec2 size, vec2 pixelSize, inout vec4 color) {
	    // Calcula la luminosidad en blanco y negro
	    float luminance = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
	    // Aplica el ajuste de luminosidad
	    luminance = clamp(luminance + GREYSCALE_Luminosity, 0.0, 1.0);
	    // Interpola entre el color original y el color en escala de grises
	    color.rgb = mix(color.rgb, vec3(luminance), GREYSCALE_Blend) * GREYSCALE_TintColor;
}

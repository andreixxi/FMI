// shader de fragment / fragment shader

#version 400

in vec4 ex_Color;
uniform int codCol;
out vec4 out_Color;

void main(void)
{
	float red = 0.2;
	vec4 shadow = vec4(clamp(red, 0., 1.), 0., 0., 0.); //clamp Returns min (max (x, minVal), maxVal).

	if (codCol == 0)
		//out_Color = ex_Color;
		// mix  returns the linear blend of x and y, i.e x(1-a) + ya 
		// fma Computes and returns a*b + c.
		out_Color = mix(ex_Color, shadow, fma(0.5, 2, 0.3)); 
	if (codCol == 1) // rosu inchis pt umbra
	{
		out_Color = shadow;
	}
}
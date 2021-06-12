// Shader-ul de fragment / Fragment shader  
 #version 400

in vec4 ex_Color;
uniform int codCol;
 
out vec4 out_Color;

void main(void)
  {
	if (codCol == 0) //nu schimb culoarea
		out_Color = ex_Color;
	if (codCol == 1)
		out_Color = vec4(1.0, 0.0, 0.0, 0.0); //red
	if (codCol == 2)
		out_Color = vec4(0.0, 1.0, 0.0, 0.0); //green
	if (codCol == 3)
		out_Color = vec4(0.0, 1.0, 1.0, 0.0); // g + b cyan
	if (codCol == 4)
		out_Color = vec4(1.0, 1.0, 0.0, 0.0); // r + g yellow
	if (codCol == 5)
		out_Color = vec4(1.0, 0.0, 1.0, 0.0); // r+b
	if (codCol == 6)
		out_Color = vec4(0.0, 0.0, 0.0, 0.0); //black
	if (codCol == 7)
		out_Color = vec4(0.0, 0.0, 1.0, 0.0); //blue
	if (codCol == 8)
		out_Color = vec4(1.0, 0.5, 0.0, 0.0); //orange
	if (codCol == 9)
		out_Color = vec4(0.9, 0.9, 0.9, 0.0); //grey
  }
 // shader varfuri
 #version 400

in vec4 in_Position;
in vec4 in_Color;

uniform mat4 myMatrix;
uniform mat4 matrTransl1;
uniform mat4 matrTransl2;
uniform mat4 matrScale;

out vec4 gl_Position; 
out vec4 ex_Color;


void main(void)
{
    //gl_Position = (myMatrix * matrTransl2 * matrScale * matrTransl1) * in_Position; // scalare cu centrul C(din main)
    gl_Position = (myMatrix * matrScale) * in_Position; //scalare cu pct fix originea
    ex_Color = in_Color;
} 
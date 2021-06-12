#include <windows.h>  // biblioteci care urmeaza sa fie incluse
#include <stdlib.h> // necesare pentru citirea shader-elor
#include <stdio.h>
#include <math.h>
#include <iostream>
#include <GL/glew.h> // glew apare inainte de freeglut
#include <GL/freeglut.h> // nu trebuie uitat freeglut.h

#include "loadShaders.h"

#include "glm/glm/glm.hpp"  
#include "glm/glm/gtc/matrix_transform.hpp"
#include "glm/glm/gtx/transform.hpp"
#include "glm/glm/gtc/type_ptr.hpp"

using namespace std;

GLuint
	VaoId,
	VboId,
	ColorBufferId,
	ProgramId,
	myMatrixLocation,
	matrScaleLocation,
	matrTransl1Location,
	matrTransl2Location,
	matrRotlLocation;

glm::mat4 myMatrix, matrTransl1, matrTransl2, matrScale, matrRot;

float PI = 3.141592;

void CreateVBO(void)
{
	GLfloat Vertices[] = {
		//dreptunghi D 
		-0.75f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		0.0f, -0.75f, 0.0f, 1.0f,
		-0.75f,  -0.75f, 0.0f, 1.0f,
		//dreptunghi D in [0,800] * [0,1000]
		/*
		0.25f, 0.25f, 0.0f, 1.0f,
		0.25f, 0.85f, 0.0f, 1.0f,
		0.65f, 0.85f, 0.0f, 1.0f,
		0.65f, 0.25f, 0.0f, 1.0f,
		*/
		//poligon convex
		0.1f, 0.5f, 0.0f, 1.0f,
		0.35f, 0.3f, 0.0f, 1.0f,
		0.35f, 0.9f, 0.0f, 1.0f,
		0.1f, 0.7f, 0.0f, 1.0f,
		//poligon concav
		0.45f, 0.1f, 0.0f, 1.0f,
		0.7f, 0.1f, 0.0f, 1.0f,
		0.7f, 0.8f, 0.0f, 1.0f,
		0.45f, 0.8f, 0.0f, 1.0f,
		0.6f, 0.6f, 0.0f, 1.0f,
		//coordonate patrat mare pt fundal
		-1.0f, -1.0f, 0.0f, 1.0f,
		1.0f, -1.0f, 0.0f, 1.0f,
		1.0f, 1.0f, 0.0f, 1.0f,
		-1.0f, 1.0f, 0.0f, 1.0f,
	};

	GLfloat Colors[] = {
		//culori dreptunghi D
		1.0f, 0.0f, 0.0f, 1.0f,
		0.0f, 1.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 1.0f, 1.0f,
		1.0f, 0.0f, 0.0f, 1.0f,
		//culori poligon convex 
		1.0f, 1.0f, 0.0f, 1.0f,
		0.0f, 1.0f, 1.0f, 1.0f,
		1.0f, 0.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 0.0f, 1.0f,
		//culori poligon concav
		0.0f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		//culori patrat fundal
		0.0f, 0.0f, 1.0f, 1.0f,
		0.0f, 1.0f, 0.0f, 1.0f,
		1.0f, 0.0f, 0.0f, 1.0f,
		1.0f, 0.0f, 1.0f, 1.0f,
	};

	// se creeaza un buffer nou
	glGenBuffers(1, &VboId);
	// este setat ca buffer curent
	glBindBuffer(GL_ARRAY_BUFFER, VboId);
	// punctele sunt "copiate" in bufferul curent
	glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);

	// se creeaza / se leaga un VAO (Vertex Array Object) - util cand se utilizeaza mai multe VBO
	glGenVertexArrays(1, &VaoId);

	glBindVertexArray(VaoId);
	// se activeaza lucrul cu atribute; atributul 0 = pozitie
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);

	// un nou buffer, pentru culoare
	glGenBuffers(1, &ColorBufferId);
	glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
	// atributul 1 =  culoare
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);

}

void DestroyVBO(void)
{
	glDisableVertexAttribArray(1);
	glDisableVertexAttribArray(0);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glDeleteBuffers(1, &ColorBufferId);
	glDeleteBuffers(1, &VboId);

	glBindVertexArray(0);
	glDeleteVertexArrays(1, &VaoId);
}

void CreateShaders(void)
{
	ProgramId = LoadShaders("tema_2_Lungu_Andrei_4.vert", "tema_2_Lungu_Andrei_2.frag");
	glUseProgram(ProgramId);
}

void CreateShaders2(void)
{
	ProgramId = LoadShaders("tema_2_Lungu_Andrei_3.vert", "tema_2_Lungu_Andrei_2.frag");
	glUseProgram(ProgramId);
}

void DestroyShaders(void)
{
	glDeleteProgram(ProgramId);
}

void Initialize(void)
{
	//todo 
	matrRot = glm::rotate(glm::mat4(1.0f), 
						PI / 2,					// rotatia cu pi / 2
						glm::vec3(0.0, 0.0, 1.0)); 

	glm::vec3 C = glm::vec3(0.5f, 0.6f, 0.f);// aleg punctul C (0.5; 0.6) (C este situate "intre" cele 2 poligoane
	matrTransl1 = glm::translate(glm::mat4(1.0f), -C); // translatie cu vectorul -C
	/*matrTransl2 = glm::translate(glm::mat4(1.0f), glm::vec3(0.5f, 0.6f, 0.f));*/
	matrTransl2 = glm::translate(glm::mat4(1.0f), C); // translatie cu vectorul C

	matrScale = glm::scale(glm::mat4(1.0f),
						   glm::vec3(0.4, 0.5, 1.0));//scalare, 0.4 * ox, 0.5 * oy

	glClearColor(1.0f, 1.0f, 1.0f, 1.0f); // culoarea de fond a ecranului 
}

void RenderFunction(void)
{
	glClear(GL_COLOR_BUFFER_BIT);
	CreateVBO();
	CreateShaders();

	myMatrix = glm::mat4(1.f); // matricea identitate 4x4
	myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
	glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
	// desenare primitive
	// deseneaza fundal si dreptunghi
	glDrawArrays(GL_QUADS, 13, 4); //fundalul(patrat mare) gradient; incepe cu punctul 13 si deseneaza 4 puncte
	glLineWidth(5.0);
	glDrawArrays(GL_LINE_LOOP, 0, 4); //dreptunghiul D; incepe cu punctul 0 si deseneaza 4 puncte
	// deseneaza poligoanele initiale
	glDrawArrays(GL_LINE_LOOP, 4, 4); //poligonul convex; incepe cu punctul 4 si deseneaza 4 puncte
	glDrawArrays(GL_LINE_LOOP, 8, 5); //poligonul concav; incepe cu punctul 8 si deseneaza 5 puncte

	// poligoanele transformate
	myMatrix = glm::mat4(1.f) * matrTransl2 * matrRot * matrTransl1;// inmultire in programul principal
	myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
	glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
	// desenare primitive
	glDrawArrays(GL_LINE_LOOP, 4, 4); //poligonul convex; 
	glDrawArrays(GL_LINE_LOOP, 8, 5); //poligonul concav; 

	//scalarea in main, functioneaza 
	/*myMatrix = glm::mat4(1.f) * matrTransl2 * matrScale * matrTransl1;// inmultire in programul principal
	myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
	glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
	glDrawArrays(GL_LINE_LOOP, 0, 4); //dreptunghiul D; incepe cu punctul 0 si deseneaza 4 puncte*/

	// folosesc alt shader de varf unde fac si inmultirea matricelor
	CreateShaders2();
	myMatrix = glm::mat4(1.f);
	myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
	glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
	matrScaleLocation = glGetUniformLocation(ProgramId, "matrScale");
	glUniformMatrix4fv(matrScaleLocation, 1, GL_FALSE, &matrScale[0][0]);
	matrTransl1Location = glGetUniformLocation(ProgramId, "matrTransl1");
	glUniformMatrix4fv(matrTransl1Location, 1, GL_FALSE, &matrTransl1[0][0]);
	matrTransl2Location = glGetUniformLocation(ProgramId, "matrTransl2");
	glUniformMatrix4fv(matrTransl2Location, 1, GL_FALSE, &matrTransl2[0][0]);
	
	glDrawArrays(GL_LINE_LOOP, 0, 4); // desenare dreptunghi D scalat

	glutPostRedisplay();
	glFlush();
}

void Cleanup(void)
{
	DestroyShaders();
	DestroyVBO();
}

int main(int argc, char* argv[])
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowPosition(100, 100);
	glutInitWindowSize(800, 600);
	glutCreateWindow("Tema 2 Lungu Andrei");
	glewInit();
	Initialize();
	glutDisplayFunc(RenderFunction);
	glutCloseFunc(Cleanup);
	glutMainLoop();
}
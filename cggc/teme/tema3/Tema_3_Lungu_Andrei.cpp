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

GLuint VaoId, VboId, ColorBufferId, ProgramId, myMatrixLocation, matrScaleLocation, matrTransl1Location, matrTransl2Location, matrRotlLocation, codColLocation;

glm::mat4 myMatrix, matrTransl1, matrTransl2, matrScale, matrRot;

float PI = 3.141592;

int codCol;

void CreateVBO(void) {
	GLfloat Vertices[] = {
		// dreptunghiul 1
		-0.75f, -0.25f, 0.0f, 1.0f,
		-0.35f, -0.25f, 0.0f, 1.0f,
		-0.35f, -0.5f, 0.0f, 1.0f,
		-0.75f, -0.5f, 0.0f, 1.0f,
		//puncte axa OX
		-1.f, 0.0f, 0.0f, 1.0f,
		-0.75f, 0.0f, 0.0f, 1.0f,
		-0.5f, 0.0f, 0.0f, 1.0f,
		-0.25f, 0.0f, 0.0f, 1.0f,
		0.0f, 0.0f, 0.0f, 1.0f,
		0.25f, 0.0f, 0.0f, 1.0f,
		0.5f, 0.0f, 0.0f, 1.0f,
		0.75f, 0.0f, 0.0f, 1.0f,
		1.f, 0.0f, 0.0f, 1.0f,
		//dreptunghiul 2 
		0.75f, 0.25f, 0.0f, 1.0f,
		0.35f, 0.25f, 0.0f, 1.0f,
		0.35f, 0.5f, 0.0f, 1.0f,
		0.75f, 0.5f, 0.0f, 1.0f,
		//banda
		-1.0f, 0.04f, 0.0f, 1.0f,
		1.0f, 0.04f, 0.0f, 1.0f,
		1.0f, 0.02f, 0.0f, 1.0f,
		-1.0f, 0.02f, 0.0f, 1.0f,
	};
	GLfloat Colors[] = {
		0.0f, 0.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 1.0f, 1.0f,
		0.0f, 0.0f, 1.0f, 1.0f,
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
	ProgramId = LoadShaders("tema_3_Shader.vert", "tema_3_Shader.frag");
	glUseProgram(ProgramId);
}
void DestroyShaders(void)
{
	glDeleteProgram(ProgramId);
}
void Initialize(void)
{
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f); // culoarea de fond a ecranului, gri
	CreateVBO();
	CreateShaders();
}

float x1 = -1., yy1 = -0.35, x2 = -2., yy2;
float x3 = 1., yy3 = 0.35, x4 = 2., yy4;
float angle3, angle4;
//float height = 0.25, width = 0.5, eps = 0.05; // dimensiuni dreptunghi
float height = 0.375, width = 0.62, eps = 0.05;; //dimensiuni "masini"
void idle()
{
	//deplasare stanga --> dreapta
	//dreptunghiul care merge lent
	float aa = x2 - width, bb = x2 + width;
	float cc = bb - 2 * (bb - aa) / 3, dd = bb - (bb - aa) / 3;
	if (x1 <= 2) //inca este in cadru, il deplasez la dreapta ft usor
	{
		yy2 = yy1; // dreptunghiul rapid pe aceeasi banda cu cel lent
		angle3 = 0.;
		if (x1 > aa && x1 < bb)//intra in depasire
		{
			yy2 = yy2 + height + eps;//trece pe alta banda
			if (x1 > dd && x1 < bb)
				//angle3 = -50.;
				angle3 += 0.25;
			else if (x1 > cc && x1 < dd)
				angle3 = 0.;
			else if (x1 > aa && x1 < cc)
				//angle3 = 50.;
				angle3 -= 0.25;
		}
		x1 += 0.0001;
	}
	else //il readuc in cadru
		x1 = -1.5;

	if (x2 <= 2) //dreptunghiul rapid este in cadru
		x2 += 0.0004;
	else
		x2 = -1.5;

	//deplasare dreapta --> stanga
	float a = x4 - width, b = x4 + width;
	float c = b - 2*(b-a)/3, d = b - (b-a)/3; // impart intervalul [a,b] in 4 : [a, c, d, b]
	if (x3 >= -2) //inca este in cadru, il deplasez la stg ft usor
	{
		yy4 = yy3;
		angle4 = 0.;
		if (x3 > a && x3 < b)//intra in depasire
		{
			yy4 = yy3 - height - eps;//trece pe alta banda
			if (x3 > d && x3 < b) //x3 in [d,b]
				angle4 = 50.;
			else if (x3 > c && x3 < d) // x3 in [c, d]
				angle4 = 0.;
			else if (x3 > a && x3 < c) // x3 in [a, c]
				angle4 = -50;
		}
		x3 -= 0.0001;
	}
	else //il readuc in cadru
		x3 = 1.5;

	if (x4 >= -2)
		x4 -= 0.0004;
	else
		x4 = 1.5;

	glutPostRedisplay();
}
void RenderFunction(void)
{
	glClear(GL_COLOR_BUFFER_BIT);

	// dreptunghiul care merge lent spre dreapta
	//marfa 1
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.375, yy1 - 0.1, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 2;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//marfa 2
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.675, yy1 - 0.1, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		float angle = 45.0;
		matrRot = glm::rotate(glm::mat4(1.0f), angle, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrTransl1 * matrRot * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 1;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//marfa 3
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.69, yy1 - 0.23, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		float angle = 65.0;
		matrRot = glm::rotate(glm::mat4(1.0f), angle, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrTransl1 * matrRot * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 3;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//corpul mare
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1, yy1, 0.0f));
		myMatrix = matrTransl1 * glm::mat4(1.f);
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 0;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//corpul mic
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.125, yy1 - 0.1, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.3, 0.8, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 5;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din fata
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.275, yy1 - 0.4, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din spate
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.575, yy1 - 0.4, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//far
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x1 - 0.195, yy1 - 0.32, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.09, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 8;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	
	// pentru dreptunghiul care depaseste
	//corpul mare
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x2, yy2, 0.0f));
		matrRot = glm::rotate(glm::mat4(1.0f), angle3, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 1;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//corpul mic
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x2 - 0.125, yy2 - 0.1, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.3, 0.8, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle3, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 2;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din fata
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x2 - 0.275, yy2 - 0.4, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle3, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din spate
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x2 - 0.575, yy2 - 0.4, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle3, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//far
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x2 - 0.195, yy2 - 0.32, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.09, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle3, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 8;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}

	//puncte ajutatoare - de sus
	{
		myMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, 0.5f, 0.0f));
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 2;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glPointSize(7.);
		glDrawArrays(GL_POINTS, 4, 9);
	}
	//puncte ajutatoare - de jos
	{
		myMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, -0.5f, 0.0f));
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 2;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glPointSize(7.);
		glDrawArrays(GL_POINTS, 4, 9);
	}

	// dreptunghiul care merge lent spre stanga
	//marfa 1
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.575, yy3 + 0.65, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 1;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//marfa 2
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.6, yy3 + 0.65, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		float angle = 45.0;
		matrRot = glm::rotate(glm::mat4(1.0f), angle, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrTransl1 * matrRot * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 4;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//marfa 3
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.42, yy3 + 0.52, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		float angle = 65.0;
		matrRot = glm::rotate(glm::mat4(1.0f), angle, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrTransl1 * matrRot * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 5;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//corpul mare
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3, yy3, 0.0f));
		myMatrix =  matrTransl1 * glm::mat4(1.f);
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 3;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 13, 4);
	}
	//corpul mic
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.455, yy3 + 0.65, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.3, 0.8, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 5;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din fata
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.435, yy3 + 0.35, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din spate
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.735, yy3 + 0.35, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//far
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x3 + 0.297, yy3 + 0.425, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.09, 0.3, 0.0));
		myMatrix = matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 8;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}

	// drept care depaseste spre stanga
	//corpul mare
	{
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x4, yy4, 0.0f));
		matrRot = glm::rotate(glm::mat4(1.0f), angle4, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 4;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 13, 4);
	}
	//corpul mic
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x4 + 0.455, yy4 + 0.65, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.3, 0.8, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle4, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 7;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din fata
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x4 + 0.435, yy4 + 0.35, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle4, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//roata  din spate
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x4 + 0.735, yy4 + 0.35, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.15, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle4, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 6;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//far
	{
		myMatrix = glm::mat4(1.f); // matricea identitate 4x4
		matrTransl1 = glm::translate(glm::mat4(1.0f), glm::vec3(x4 + 0.297, yy4 + 0.425, 0.0f));
		matrScale = glm::scale(glm::mat4(1.0f), glm::vec3(0.09, 0.3, 0.0));
		matrRot = glm::rotate(glm::mat4(1.0f), angle4, glm::vec3(0.0, 0.0, 1.0));
		myMatrix = matrRot * matrTransl1 * matrScale;
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 8;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 0, 4);
	}
	//banda 1
	{
		myMatrix = glm::mat4(1.f);
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 9;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 17, 4);
	}
	//banda 2
	{
		myMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, -0.04, 0.0f));
		myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
		glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
		codCol = 9;
		codColLocation = glGetUniformLocation(ProgramId, "codCol");
		glUniform1i(codColLocation, codCol);
		glDrawArrays(GL_QUADS, 17, 4);
	}
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
	glutCreateWindow("Tema 3 Lungu Andrei");
	glewInit();
	Initialize();
	glutDisplayFunc(RenderFunction);
	glutIdleFunc(idle); // pt deplasarea drept
	glutCloseFunc(Cleanup);
	glutMainLoop();
}
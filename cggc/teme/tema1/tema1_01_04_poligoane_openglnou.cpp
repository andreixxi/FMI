//lungu andrei
//nu am scris si a 2a functie de desenat
#include <windows.h>
#include <stdlib.h> //citire shadere
#include <stdio.h> 
#include <GL/glew.h> //glew inainte de freeglut
#include <GL/freeglut.h>
#include "loadShaders.h"

GLuint
VaoId,
VboId,
ColorBufferId,
VertexShaderId,
FragmentShaderId,
ProgramId;

void CreateVBO(void) {
    //varfurile in [-1, 1]
    GLfloat Vertices[] = {
        0.02f, 0.13f, 0.0f, 1.0f, //varfuri dreptunghi
        0.14f, 0.13f, 0.0f, 1.0f,
        0.14f, 0.31f, 0.0f, 1.0f,
        0.02f, 0.31f, 0.0f, 1.0f,
        0.0f, 0.0f, 0.0f, 1.0f, //poligon convex
        0.1f, 0.01f, 0.0f, 1.0f,
        0.2f, 0.12f, 0.0f, 1.0f,
        0.155f, 0.29f, 0.0f, 1.0f,
        0.25f, 0.3f, 0.0f, 1.0f, //evantai de triunghiuri
        0.05f, 0.3f, 0.0f, 1.0f,
        0.2f, 0.35f, 0.0f, 1.0f,
        0.25f, 0.5f, 0.0f, 1.0f,
        0.35f, 0.2f, 0.0f, 1.0f,
        0.65f, 0.3f, 0.0f, 1.0f, //reuniune de triunghiuri
        0.45f, 0.3f, 0.0f, 1.0f,
        0.6f, 0.35f, 0.0f, 1.0f,
        0.65f, 0.5f, 0.0f, 1.0f,
        0.75f, 0.2f, 0.0f, 1.0f,
    };

    //culorile, atribute ale vf
    GLfloat Colors[] = {
        0.0f, 0.0f, 1.0f, 1.0f, //culoare dreptunghi
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f, //culoare poligon convex
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.25f, 1.0f, //culoare evantai
        1.0f, 0.0f, 0.25f, 1.0f,
        1.0f, 0.0f, 0.25f, 1.0f,
        1.0f, 0.0f, 0.25f, 1.0f,
        1.0f, 0.0f, 0.25f, 1.0f,
        1.0f, 0.75f, 0.25f, 1.0f, //culoare reuniune
        1.0f, 0.75f, 0.25f, 1.0f,
        1.0f, 0.75f, 0.25f, 1.0f,
        1.0f, 0.75f, 0.25f, 1.0f,
        1.0f, 0.75f, 0.25f, 1.0f,
    };

    //creez buffer nou
    glGenBuffers(1, &VboId);

    //setat ca buffer curent
    glBindBuffer(GL_ARRAY_BUFFER, VboId);

    //punctele sunt copiate in bufferul curent
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);

    //se creeaza un VAO (vertex array object), folosit pt mai multe VBO
    glGenVertexArrays(1, &VaoId);
    glBindBuffer(GL_ARRAY_BUFFER, VaoId);

    //se activeaza lucrul cu atribute, 0 = pozitie
    glEnableVertexAttribArray(0);

    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);

    //buffer nou, pt culoare
    glGenBuffers(1, &ColorBufferId);
    glBindBuffer(GL_ARRAY_BUFFER, ColorBufferId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Colors), Colors, GL_STATIC_DRAW);
    glEnableVertexAttribArray(1); //atributul 1 = culoare
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
}

void DestroyVBO(void) {
    glDisableVertexAttribArray(1);
    glDisableVertexAttribArray(0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glDeleteBuffers(1, &ColorBufferId);
    glDeleteBuffers(1, &VboId);

    glBindVertexArray(0);
    glDeleteVertexArrays(1, &VaoId);
}

void CreateShaders(void) {
    ProgramId = LoadShaders("02_01_Shader.vert", "02_01_Shader.frag");
    glUseProgram(ProgramId);
}

void DestroyShaders(void) {
    glDeleteProgram(ProgramId);
}

void Initialize(void) {
    glClearColor(1.f, 1.f, 1.f, 1.f); //culoare fundal ecran
    CreateVBO();
    CreateShaders();

    glMatrixMode(GL_PROJECTION);// se precizeaza este vorba de o reprezentare 2D, realizata prin proiectie ortogonala
    gluOrtho2D(0., 800., 0.0, 700.); // sunt indicate coordonatele extreme ale ferestrei de vizualizare
}

void RenderFunction(void) {
    glClear(GL_COLOR_BUFFER_BIT);

    glPointSize(5.);
    glDrawArrays(GL_POLYGON, 0, 4); //pt dreptunghi /*https://docs.microsoft.com/en-us/windows/win32/opengl/glrecti*/
    glDrawArrays(GL_POLYGON, 4, 4); //poligon convex
    glDrawArrays(GL_TRIANGLE_FAN, 8, 5); //evantai de triunghiuri
    glDrawArrays(GL_TRIANGLE_STRIP, 13, 5); //reuniune de triunghiuri
    glFlush();
}

void Cleanup(void) {
    DestroyShaders();
    DestroyVBO();
}

int main(int argc, char* argv[]) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowPosition(100, 100); //pozitia initiala a ferestrei
    glutInitWindowSize(600, 600);
    glutCreateWindow("01_04_poligoane_newOpenGL"); //titlu
    glewInit(); //apelat inainte de initializare
    Initialize();
    glutDisplayFunc(RenderFunction);
    glutCloseFunc(Cleanup);
    glutMainLoop();
}
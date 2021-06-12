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
        -0.6f, 0.4f, 0.0f, 1.0f, //primul dreptunghi
        0.8f, 0.4f, 0.0f, 1.0f, 
        0.8f, 0.2f, 0.0f, 1.0f,
        -0.6f, 0.2f, 0.0f, 1.0f,
    };

    //culorile, atribute ale vf
    GLfloat Colors[] = {
        1.0f, 0.0f, 0.0f, 1.0f, //culoare dreptunghi
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
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
    glDrawArrays(GL_POLYGON, 0, 4); //dreptunghiul rosu
    //////////////
    glMatrixMode(GL_MODELVIEW);//The modelview matrix defines how your objects are transformed (meaning translation,rotation and scaling) in your world coordinate frame
    glPushMatrix();
    glTranslatef(-0.3, -0.4, 0.0); //coordonatele vectorului de translatie
    glScalef(0.125, 0.5, 0.0); //factorii de scalare pe fiecare axa
    glDrawArrays(GL_POLYGON, 0, 4);
    glPopMatrix();

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
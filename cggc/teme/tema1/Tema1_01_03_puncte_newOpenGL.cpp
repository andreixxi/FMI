//lungu andrei
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
        //primele 7 puncte
        0.02f, 0.02f, 0.0f, 1.0f, //punctul 0
        0.021f, 0.021f, 0.0f, 1.0f,
        0.022f, 0.022f, 0.0f, 1.0f,
        0.023f, 0.023f, 0.0f, 1.0f,
        0.024f, 0.024f, 0.0f, 1.0f,
        0.027f, 0.027f, 0.0f, 1.0f,
        0.1f, 0.1f, 0.0f, 1.0f, //punctul 6

        //inca 2 puncte
        0.1f, 0.4f, 0.0f, 1.0f,
        0.3f, 0.5f, 0.0f, 1.0f,

        //puncte pt segment (rosu)
        0.0f, 0.1f, 0.0f, 1.0f,
        0.4f, 0.5f, 0.0f, 1.0f,

        //puncte pt reuniunea de segmente
        0.4f, 0.4f, 0.0f, 1.0f,
        0.6f, 0.5f, 0.0f, 1.0f,
        0.7f, 0.52f, 0.0f, 1.0f,
        0.655f, 0.69f, 0.0f, 1.0f,
    };

    //culorile, atribute ale vf
    GLfloat Colors[] = {
        //culoarea primelor 7 puncte este albastra 
        0.0f, 0.0f, 1.0f, 1.0f, //culoarea 0
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f, //culoarea 6

        0.0f, 0.0f, 0.0f, 1.0f, //culoarea 7
        1.0f, 0.0f, 0.5f, 1.0f,

        1.0f, 0.0f, 0.0f, 1.0f, //culoare segment rosu
        1.0f, 0.0f, 0.0f, 1.0f,

        0.5f, 0.0f, 1.0f, 1.0f, //culoare pt reuniune segmente
        0.5f, 0.0f, 1.0f, 1.0f,
        0.5f, 0.0f, 1.0f, 1.0f,
        0.5f, 0.0f, 1.0f, 1.0f,
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
}

void RenderFunction(void) {
    glClear(GL_COLOR_BUFFER_BIT);

    glPointSize(5.);
    /*glDrawArrays(tip, first, n); incepe cu first si deseneaza n puncte*/
    glDrawArrays(GL_POINTS, 0, 7); //  7 puncte albastre
    glDrawArrays(GL_POINTS, 7, 2); // punctul negru si violet (7 si 8)

    //glPointSize(1.); //nu pot redimensiona urm puncte asa
    glDrawArrays(GL_LINE_STRIP, 9, 2); //segmentul rosu format din punctele 9 si 10
   
    glDrawArrays(GL_LINES, 11, 4); //reuniune de segmente
    
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
    glutCreateWindow("01_03_puncte_newOpenGL"); //titlu
    glewInit(); //apelat inainte de initializare
    Initialize();
    glutDisplayFunc(RenderFunction);
    glutCloseFunc(Cleanup);
    glutMainLoop();
}
/*Cerinta: Desenati obiecte 3D folosind metodele descrise la curs (fundamente geometrice, functionalitati ale OpenGL 4, import de modele). Utilizati iluminarea si tehnicile de amestecare. Sarcini punctuale:

v(i) Creati un obiect 3D (tetraedru/piramida/con, un alt poliedru), indicand explicit varfurile. 
v(ii) Utilizati randarea instantiata / alte functii de desenare pentru obiectul nou creat. 
v(iii) Utilizati functiile de iluminare in scena creata. Manevrati atat valorile parametrilor, cat si formula din modelul de iluminare. 
v(iv) Explorati utilizarea a trei functii nediscutate pana acum ale GLSL folosind documentatia de baza. 
        - inversesqrt in shader.vert linia 37 (1/sqrt)
        - clamp in shader.frag linia 12 (Returns min (max (x, minVal), maxVal) -- valoarea din mijloc, minv < maxv!!)
        - fma in shader.frag linia 18 (// fma Computes and returns a*b + c.)
(v) Manevrati codul sursa pentru incarcarea unui model predefinit (fisier de tip obj).*/
#define _CRT_SECURE_NO_DEPRECATE

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
#include <vector>

using namespace std;

GLuint
    VaoId,
    VboId,
    EboId,
    ColorBufferId,
    ProgramId,
    myMatrixLocation,
    matrUmbraLocation,
    viewLocation,
    projLocation,
    matrRotlLocation,
    codColLocation,
    depthLocation;

GLuint texture;

int codCol;
float PI = 3.141592;

// matrice utilizate
glm::mat4 myMatrix, matrRot;

// elemente pentru matricea de vizualizare
float Obsx = 0.0, Obsy = -600.0, Obsz = 250.f;
float Refx = 0.0f, Refy = 600.0f, Refz = 0.0f;
float Vx = 0.0, Vy = 0.0, Vz = 1.0;
glm::mat4 view;

// elemente pentru matricea de proiectie
float width = 800, height = 600, xwmin = -800.f, xwmax = 800, ywmin = -600, ywmax = 600, znear = 0.1, zfar = 1, fov = 45;
glm::mat4 projection;

// sursa de lumina
float xL = 0.f, yL = 0.f, zL = 400.f;

// matricea umbrei
float matrUmbra[4][4];

void processNormalKeys(unsigned char key, int x, int y)
{

    switch (key) {
    case 'l':
        Vx -= 0.1;
        break;
    case 'r':
        Vx += 0.1;
        break;
    case '+':
        Obsy += 10;
        break;
    case '-':
        Obsy -= 10;
        break;

    }
    if (key == 27)
        exit(0);
}
void processSpecialKeys(int key, int xx, int yy) {

    switch (key) {
    case GLUT_KEY_LEFT:
        Obsx -= 10;
        break;
    case GLUT_KEY_RIGHT:
        Obsx += 10;
        break;
    case GLUT_KEY_UP:
        Obsz += 10;
        break;
    case GLUT_KEY_DOWN:
        Obsz -= 10;
        break;
    }
}
bool loadOBJ(const char* path,
    std::vector < glm::vec3 >& out_vertices,
    std::vector < glm::vec2 >& out_uvs,
    std::vector < glm::vec3 >& out_normals)
{
    //temporary variables in which we will store the contents of the .obj :
    std::vector< unsigned int > vertexIndices, uvIndices, normalIndices;
    std::vector< glm::vec3 > temp_vertices;
    std::vector< glm::vec2 > temp_uvs;
    std::vector< glm::vec3 > temp_normals;
    // open a file 
    FILE* file = fopen(path, "r");
    if (file == NULL) {
        printf("Impossible to open the file !\n");
        return false;
    }
    // read the file
    while (1) {

        char lineHeader[500];
        // read the first word of the line
        int res = fscanf(file, "%s", lineHeader);
        if (res == EOF)
            break; // EOF = End Of File. Quit the loop.

        // else : parse lineHeader
        if (strcmp(lineHeader, "v") == 0) { //vertices
            glm::vec3 vertex;
            fscanf(file, "%f %f %f\n", &vertex.x, &vertex.y, &vertex.z);
            temp_vertices.push_back(vertex);
        }
        else if (strcmp(lineHeader, "vt") == 0) {
            glm::vec2 uv;
            fscanf(file, "%f %f\n", &uv.x, &uv.y);
            temp_uvs.push_back(uv);
        }
        else if (strcmp(lineHeader, "vn") == 0) { //normals
            glm::vec3 normal;
            fscanf(file, "%f %f %f\n", &normal.x, &normal.y, &normal.z);
            temp_normals.push_back(normal);
        }
        else if (strcmp(lineHeader, "f") == 0) {
            std::string vertex1, vertex2, vertex3;
            unsigned int vertexIndex[3], uvIndex[3], normalIndex[3];
            int matches = fscanf(file, "%d/%d/%d %d/%d/%d %d/%d/%d\n", &vertexIndex[0], &uvIndex[0], &normalIndex[0], &vertexIndex[1], &uvIndex[1], &normalIndex[1], &vertexIndex[2], &uvIndex[2], &normalIndex[2]);
            if (matches != 9) {
                printf("File can't be read by our simple parser : ( Try exporting with other options\n");
                return false;
            }
            vertexIndices.push_back(vertexIndex[0]);
            vertexIndices.push_back(vertexIndex[1]);
            vertexIndices.push_back(vertexIndex[2]);
            uvIndices.push_back(uvIndex[0]);
            uvIndices.push_back(uvIndex[1]);
            uvIndices.push_back(uvIndex[2]);
            normalIndices.push_back(normalIndex[0]);
            normalIndices.push_back(normalIndex[1]);
            normalIndices.push_back(normalIndex[2]);
        }
    }
        //Processing the data
        // For each vertex of each triangle
        for (unsigned int i = 0; i < vertexIndices.size(); i++) {
            unsigned int vertexIndex = vertexIndices[i];
            glm::vec3 vertex = temp_vertices[vertexIndex - 1];
            out_vertices.push_back(vertex);
        }
        /*for (unsigned int i = 0; i < uvIndices.size(); i++) {
            unsigned int vertexIndex = uvIndices[i];
            glm::vec3 vertex = temp_vertices[vertexIndex - 1];
            out_vertices.push_back(vertex);
        }*/
        for (unsigned int i = 0; i < normalIndices.size(); i++) {
            unsigned int vertexIndex = normalIndices[i];
            glm::vec3 vertex = temp_vertices[vertexIndex - 1];
            out_vertices.push_back(vertex);
        }

    }
std::vector< glm::vec3 > vertices;
std::vector< glm::vec2 > uvs;
std::vector< glm::vec3 > normals; // Won't be used at the moment.
bool res;
void CreateVBO(void)
{
    // varfurile 
    GLfloat Vertices[] = {

        // coordonate                   // culori			// normale
        0.0f, 0.0f, 150.0f, 1.0f,        1.0f, 0.5f, 0.4f,  -1.0f, -1.0f, -1.0f, //varf
        -50.0f,  -50.0f, 50.0f, 1.0f, 	 1.0f, 0.5f, 0.4f,  -1.0f, -1.0f, 1.0f, // baza
        50.0f,  -50.0f,  50.0f, 1.0f,    1.0f, 0.5f, 0.4f,  1.0f, -1.0f, 1.0f,
        50.0f,  50.0f,  50.0f, 1.0f,     1.0f, 0.5f, 0.4f,  1.0f, 1.0f, 1.0f,
        -50.0f,  50.0f, 50.0f, 1.0f,     1.0f, 0.5f, 0.4f,  -1.0f, 1.0f, 1.0f,
        // planul mare
       -1000.0f,  -1000.0f, 0.0f, 1.0f,  1.0f, 1.0f, 0.5f,  0.0f, 0.0f, 1.0f,
        1000.0f,  -1000.0f, 0.0f, 1.0f,  1.0f, 1.0f, 0.5f,  0.0f, 0.0f, 1.0f,
        1000.0f,  1000.0f,  0.0f, 1.0f,  1.0f, 1.0f, 0.5f,  0.0f, 0.0f, 1.0f,
       -1000.0f,  1000.0f,  0.0f, 1.0f,  1.0f, 1.0f, 0.5f,  0.0f, 0.0f, 1.0f,

    };

    // indicii pentru varfuri
    GLubyte Indices[] = {

      2, 3, 1, 3, 1, 4, // fata de sus - baza piramidei
      1, 2, 0, // fete laterale (triunghiuri)
      2, 3, 0,
      3, 4, 0,
      4, 1, 0,
      6, 7, 5, 7, 5, 8

    };

    // se creeaza un VAO (Vertex Array Object) - util cand se utilizeaza mai multe VBO
    glGenVertexArrays(1, &VaoId);
    // se creeaza un buffer nou (atribute)
    glGenBuffers(1, &VboId);
    // se creeaza un buffer nou (indici)
    glGenBuffers(1, &EboId);

    // legarea VAO 
    glBindVertexArray(VaoId);

    // legarea buffer-ului "Array"
    glBindBuffer(GL_ARRAY_BUFFER, VboId);
    // punctele sunt "copiate" in bufferul curent
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);

    // legarea buffer-ului "Element" (indicii)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EboId);
    // indicii sunt "copiati" in bufferul curent
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);

    // se activeaza lucrul cu atribute; atributul 0 = pozitie
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 10 * sizeof(GLfloat), (GLvoid*)0);

    // se activeaza lucrul cu atribute; atributul 1 = culoare
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 10 * sizeof(GLfloat), (GLvoid*)(4 * sizeof(GLfloat)));

    // se activeaza lucrul cu atribute; atributul 2 = normale
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 10 * sizeof(GLfloat), (GLvoid*)(7 * sizeof(GLfloat)));

    // Read our .obj file
   // res = loadOBJ("suzanne.obj", vertices, uvs, normals);//declarate global
   // glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);

}
void DestroyVBO(void)
{
    glDisableVertexAttribArray(2);
    glDisableVertexAttribArray(1);
    glDisableVertexAttribArray(0);

    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glDeleteBuffers(1, &VboId);
    glDeleteBuffers(1, &EboId);

    glBindVertexArray(0);
    glDeleteVertexArrays(1, &VaoId);
}

void CreateShaders(void)
{
	ProgramId = LoadShaders("Tema_4_Lungu_Andrei_Shader.vert", "Tema_4_Lungu_Andrei_Shader.frag");
	glUseProgram(ProgramId);
}

void DestroyShaders(void)
{
	glDeleteProgram(ProgramId);
}
void Initialize(void)
{

    myMatrix = glm::mat4(1.0f);
    matrRot = glm::rotate(glm::mat4(1.0f), PI / 8, glm::vec3(0.0, 0.0, 1.0));
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // culoarea de fond a ecranului
    CreateShaders();

}
void RenderFunction(void)
{

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    // reperul de vizualizare
    glm::vec3 Obs = glm::vec3(Obsx, Obsy, Obsz);   // se schimba pozitia observatorului	
    glm::vec3 PctRef = glm::vec3(Refx, Refy, Refz); // pozitia punctului de referinta
    glm::vec3 Vert = glm::vec3(Vx, Vy, Vz); // verticala din planul de vizualizare 
    view = glm::lookAt(Obs, PctRef, Vert);

    projection = glm::infinitePerspective(fov, GLfloat(width) / GLfloat(height), znear);
    myMatrix = glm::mat4(1.0f);
    // matricea pentru umbra
    float D = -5.f;
    matrUmbra[0][0] = zL + D; matrUmbra[0][1] = 0; matrUmbra[0][2] = 0; matrUmbra[0][3] = 0;
    matrUmbra[1][0] = 0; matrUmbra[1][1] = zL + D; matrUmbra[1][2] = 0; matrUmbra[1][3] = 0;
    matrUmbra[2][0] = -xL; matrUmbra[2][1] = -yL; matrUmbra[2][2] = D; matrUmbra[2][3] = -1;
    matrUmbra[3][0] = -D * xL; matrUmbra[3][1] = -D * yL; matrUmbra[3][2] = -D * zL; matrUmbra[3][3] = zL;


    CreateVBO();

    // variabile uniforme pentru shaderul de varfuri
    myMatrixLocation = glGetUniformLocation(ProgramId, "myMatrix");
    glUniformMatrix4fv(myMatrixLocation, 1, GL_FALSE, &myMatrix[0][0]);
    matrUmbraLocation = glGetUniformLocation(ProgramId, "matrUmbra");
    glUniformMatrix4fv(matrUmbraLocation, 1, GL_FALSE, &matrUmbra[0][0]);
    viewLocation = glGetUniformLocation(ProgramId, "view");
    glUniformMatrix4fv(viewLocation, 1, GL_FALSE, &view[0][0]);
    projLocation = glGetUniformLocation(ProgramId, "projection");
    glUniformMatrix4fv(projLocation, 1, GL_FALSE, &projection[0][0]);

    // Variabile uniforme pentru iluminare
    GLint objectColorLoc = glGetUniformLocation(ProgramId, "objectColor");
    GLint lightColorLoc = glGetUniformLocation(ProgramId, "lightColor");
    GLint lightPosLoc = glGetUniformLocation(ProgramId, "lightPos");
    GLint viewPosLoc = glGetUniformLocation(ProgramId, "viewPos");
    GLint codColLocation = glGetUniformLocation(ProgramId, "codCol");
    glUniform3f(objectColorLoc, 1.0f, 0.5f, 0.4f);
    glUniform3f(lightColorLoc, 1.0f, 1.0f, 1.0f);
    glUniform3f(lightPosLoc, xL, yL, zL);
    glUniform3f(viewPosLoc, Obsx, Obsy, Obsz);

    // desenare
    codCol = 0;
    glUniform1i(codColLocation, codCol);
    glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_BYTE, 0);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_BYTE, (void*)(18));

    codCol = 1;
    glUniform1i(codColLocation, codCol);
    glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_BYTE, 0);

/*   //pt suzanne 
    glDrawElements(
        GL_TRIANGLES,      // mode
        vertices.size(),    // count
        GL_UNSIGNED_INT,   // type
        (void*)24           // element array buffer offset
    );
   */

    // Eliberare memorie si realocare resurse
    DestroyVBO();
    DestroyShaders();

    glutSwapBuffers();
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
    glutInitDisplayMode(GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(1200, 900);
    glutCreateWindow("Tema 4 Lungu Andrei");
    glewInit();
    Initialize();
    glutIdleFunc(RenderFunction);
    glutDisplayFunc(RenderFunction);
    glutKeyboardFunc(processNormalKeys);
    glutSpecialFunc(processSpecialKeys);

    glutCloseFunc(Cleanup);
    glutMainLoop();

}
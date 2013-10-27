//
//  Ludo.c
//  Ludo
//
//  Created by Sid on 26/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#include "Ludo.h"

#include "he/he_Constants.h"
#include "he/he_Utilities.h"
#include "he/he_Shader.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
//enum
//{
// UNIFORM_MODELVIEWPROJECTION_MATRIX,
// UNIFORM_NORMAL_MATRIX,
// UNIFORM_DIFFUSE_COLOR,
// NUM_UNIFORMS
//};
//GLint uniforms[NUM_UNIFORMS];
//
//// Attribute index.
//enum
//{
// ATTRIB_VERTEX = 0,
// ATTRIB_NORMAL,
// NUM_ATTRIBUTES
//};
//GLuint _program;
Shader shader;

GLfloat gCubeVertexData[216] =
{
 // Data layout for each line below is:
 // positionX, positionY, positionZ,     normalX, normalY, normalZ,
 0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
 0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
 
 0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
 0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
 0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
 
 -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
 -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
 
 -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
 0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
 
 0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
 -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
 
 0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
 -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
 0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
 0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
 -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
 -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};


float _rotation;

GLuint _vertexArray;
GLuint _vertexBuffer;

float _aspect;

//static void loadShaders();
//static bool compileShader(GLuint *shader, GLenum type, const char *file);
//static bool linkProgram(GLuint prog);
//static bool validateProgram(GLuint prog);

void Load() {
 
 // loadShaders();
 CompileShader(&shader, "Shader.vsh", "Shader.fsh");
 
 glEnable(GL_DEPTH_TEST);
 
 glGenVertexArraysOES(1, &_vertexArray);
 glBindVertexArrayOES(_vertexArray);
 
 glGenBuffers(1, &_vertexBuffer);
 glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
 glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
 
 glEnableVertexAttribArray(kAttribPosition);
 glVertexAttribPointer(kAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
 glEnableVertexAttribArray(kAttribNormal);
 glVertexAttribPointer(kAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
 
 glBindVertexArrayOES(0);
}

void Unload() {
 glDeleteBuffers(1, &_vertexBuffer);
 glDeleteVertexArraysOES(1, &_vertexArray);

 ReleaseShader(&shader);
// if (_program) {
//  glDeleteProgram(_program);
//  _program = 0;
// }
 
}

void Reshape(GLsizei width, GLsizei GLKight) {
 _aspect = fabsf((float)width / (float)GLKight);
}

void Update(int dt) {
 _rotation += dt * 0.0005;
 
}

void Render() {
 glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//#if defined(DEBUG)
// if (!validateProgram(_program)) {
//  assert(0);
// }
//#endif
 glBindVertexArrayOES(_vertexArray);
 
 // Render tGLK object again with ES2
 glUseProgram(shader.program);
 GLuint mvp_loc = glGetUniformLocation(shader.program, "u_Mvp");
 GLuint n_loc = glGetUniformLocation(shader.program, "u_N");
 GLuint clr_loc = glGetUniformLocation(shader.program, "u_Color");

 Mat4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), _aspect, 0.1f, 100.0f);
 
 Mat4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
 baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
 
 // Compute tGLK model view matrix for tGLK object rendered with GLKit
 Mat4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.5f);
 modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
 modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
 Mat4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);;
 Mat3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
 glUniformMatrix4fv(mvp_loc, 1, 0, modelViewProjectionMatrix.m);
 glUniformMatrix3fv(n_loc, 1, 0, normalMatrix.m);
 glUniform4f(clr_loc, 0.8f, 0.4f, 0.4f, 1.0f);
 glDrawArrays(GL_TRIANGLES, 0, 36);
 
 // Compute tGLK model view matrix for tGLK object rendered with ES2
 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
 modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
 modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);;
 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
 glUniformMatrix4fv(mvp_loc, 1, 0, modelViewProjectionMatrix.m);
 glUniformMatrix3fv(n_loc, 1, 0, normalMatrix.m);
 glUniform4f(clr_loc, 0.4f, 0.4f, 0.8f, 1.0f);
 glDrawArrays(GL_TRIANGLES, 0, 36);
}

//static void loadShaders() {
// GLuint vertShader, fragShader;
// char vertShaderPathname[kBuffer1K];
// char fragShaderPathname[kBuffer1K];
// 
// // Create shader program.
// _program = glCreateProgram();
// 
// // Create and compile vertex shader.
// BundlePath(vertShaderPathname, "Shader.vsh");
// if (!compileShader(&vertShader, GL_VERTEX_SHADER, vertShaderPathname)) {
//  /* Failed to compile vertex shader */
//  assert(0);
// }
// 
// // Create and compile fragment shader.
// BundlePath(fragShaderPathname, "Shader.fsh");
// if (!compileShader(&fragShader, GL_FRAGMENT_SHADER, fragShaderPathname)) {
//  /* Failed to compile fragment shader */
//  assert(0);
// }
// 
// // Attach vertex shader to program.
// glAttachShader(_program, vertShader);
// 
// // Attach fragment shader to program.
// glAttachShader(_program, fragShader);
// 
// // Bind attribute locations.
// // This needs to be done prior to linking.
// glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
// glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
// 
// // Link program.
// if (!linkProgram(_program)) {
//  
//  if (vertShader) {
//   glDeleteShader(vertShader);
//   vertShader = 0;
//  }
//  if (fragShader) {
//   glDeleteShader(fragShader);
//   fragShader = 0;
//  }
//  if (_program) {
//   glDeleteProgram(_program);
//   _program = 0;
//  }
//  
//  /* Failed to link program */
//  assert(0);
// }
// 
// // Get uniform locations.
// uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
// uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
// uniforms[UNIFORM_DIFFUSE_COLOR] = glGetUniformLocation(_program, "diffuseColor");
// 
// // Release vertex and fragment shaders.
// if (vertShader) {
//  glDetachShader(_program, vertShader);
//  glDeleteShader(vertShader);
// }
// if (fragShader) {
//  glDetachShader(_program, fragShader);
//  glDeleteShader(fragShader);
// }
//}
//
//bool compileShader(GLuint *shader, GLenum type, const char *file)  {
// GLint status;
// char source[kBuffer8K];
// ReadFile(source, file);
// if (!source) {
//  /* Failed to load vertex shader */
//  return false;
// }
// const GLchar *sp = source;
// *shader = glCreateShader(type);
// glShaderSource(*shader, 1, (const char**)&sp, NULL);
// glCompileShader(*shader);
// 
//#if defined(DEBUG)
// GLint logLength;
// glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
// if (logLength > 0) {
//  GLchar *log = (GLchar *)malloc(logLength);
//  glGetShaderInfoLog(*shader, logLength, &logLength, log);
//  printf("Shader compile log:\n%s", log);
//  free(log);
// }
//#endif
// 
// glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
// if (status == 0) {
//  glDeleteShader(*shader);
//  return false;
// }
// 
// return true;
//}
//
//bool linkProgram(GLuint prog) {
// GLint status;
// glLinkProgram(prog);
// 
//#if defined(DEBUG)
// GLint logLength;
// glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
// if (logLength > 0) {
//  GLchar *log = (GLchar *)malloc(logLength);
//  glGetProgramInfoLog(prog, logLength, &logLength, log);
//  printf("Program link log:\n%s", log);
//  free(log);
// }
//#endif
// 
// glGetProgramiv(prog, GL_LINK_STATUS, &status);
// if (status == 0) {
//  return false;
// }
// 
// return true;
//}
//
//bool validateProgram(GLuint prog) {
// GLint logLength, status;
// 
// glValidateProgram(prog);
// glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
// if (logLength > 0) {
//  GLchar *log = (GLchar *)malloc(logLength);
//  glGetProgramInfoLog(prog, logLength, &logLength, log);
//  printf("Program validate log:\n%s", log);
//  free(log);
// }
// 
// glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
// if (status == 0) {
//  return false;
// }
// 
// return true;
//}

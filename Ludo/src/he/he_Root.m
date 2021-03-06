//
//  Ludo.c
//  Ludo
//
//  Created by Sid on 26/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#include "he_Root.h"

#include "he_Constants.h"
#include "he_Utilities.h"
#include "he_Shader.h"
#include "he_Mesh.h"
#include "he_Transform.h"
#include "he_Types.h"

Shader color_sh;//mesh_sh;
World world;
//Mesh cube_mesh;
//Cube redcube, bluecube;
//Board board;
Transform board_trans[4];
Mesh board_mesh;

void Load() {
 
 // CompileShader(&mesh_sh, "mesh.vsh", "mesh.fsh");
 color_sh.attrib_flag = kShaderAttribMask(kAttribPosition);
 CompileShader(&color_sh, "color.vsh", "color.fsh");
 
 glEnable(GL_DEPTH_TEST);
 
 
 DefaultTransform(&world.t);
 world.t.position.z = -10.0f;
 world.t.axis = GLKVector3Make(1.0f, 0.0f, 0.0f);
 world.t.angle = 0.0f;
 
 // CreateMesh(&cube_mesh, kCommonMesh_Cube);
 //
 // redcube.m = &cube_mesh;
 // DefaultTransform(&redcube.t);
 // redcube.t.parent = &world.t;
 // redcube.t.position.z = 5.0f;
 // redcube.color = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
 //
 // bluecube.m = &cube_mesh;
 // DefaultTransform(&bluecube.t);
 // bluecube.t.parent = &world.t;
 // bluecube.t.position.z = 8.0f;
 // bluecube.color = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
 

 for (int i = 0; i < 4; ++i) {
  DefaultTransform(&board_trans[i]);
  board_trans[i].parent = &world.t;
  board_trans[i].axis = GLKVector3Make(0.0f, 0.0f, 1.0f);
  board_trans[i].angle = 90*i;
 }
 

 board_trans[0].position = GLKVector3Make(4.5f, 0.0f, -10.0f);
 board_trans[1].position = GLKVector3Make(0.0f, 4.5f, -10.0f);
 board_trans[2].position = GLKVector3Make(-4.5f, 0.0f, -10.0f);
 board_trans[3].position = GLKVector3Make(0.0f, -4.5f, -10.0f);
 
 
 GLfloat vertex_data[] = {
  //  0.0,  0.8,
  //  -0.8, -0.8,
  //  0.8, -0.8
  
  -3.0f, -1.5f,  3.0f, -1.5f,
  -3.0f, -0.5f,  3.0f, -0.5f,
  -3.0f, 0.5f,  3.0f, 0.5f,
  -3.0f, 1.5f,  3.0f, 1.5f,
  
  -3.0f, -1.5f,  -3.0f, 1.5f,
  -2.0f, -1.5f,  -2.0f, 1.5f,
  -1.0f, -1.5f,  -1.0f, 1.5f,
  0.0f, -1.5f,  0.0f, 1.5f,
  1.0f, -1.5f,  1.0f, 1.5f,
  2.0f, -1.5f,  2.0f, 1.5f,
  3.0f, -1.5f,  3.0f, 1.5f,
 };
 glGenVertexArraysOES(1, &board_mesh.vao);
 glBindVertexArrayOES(board_mesh.vao);
 assert(board_mesh.vao);
 
 /* Generate + bind tGLK VBO */
 glGenBuffers(1, &board_mesh.vbo);
 glBindBuffer(GL_ARRAY_BUFFER, board_mesh.vbo);
 assert(board_mesh.vbo);
 
 /* Set tGLK buffer's data */
 glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_data), vertex_data, GL_STATIC_DRAW);
 
 /* Sets tGLK vertex data to enabled attribute indices */
 // GLsizei stride = sizeof(Vertex);
 // Offset position_offset;
 
 // position_offset.size = 0;
 glVertexAttribPointer(kAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
 
 /* Unbind tGLK VAO */
 glBindVertexArrayOES(0);
 
 
 // CreateMesh(&board.m, kCommonMesh_Square);
 // DefaultTransform(&board.t);
 // board.t.parent = &world.t;
 // board.t.scale = GLKVector3Make(2.0f, 1.0f, 1.0f);
 // board.color = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
}

void Unload() {
 // ReleaseMesh(&cube_mesh);
 // ReleaseMesh(&board.m);
 // ReleaseShader(&mesh_sh);
 ReleaseShader(&color_sh);
}

void Reshape(GLsizei width, GLsizei height) {
 DefaultPerspective(&world.f);
 if (width > height) {
  world.f.dimension.x = 1.0f;
  world.f.dimension.y = fabsf((float)height / (float)width);
 } else {
  world.f.dimension.x = fabsf((float)width / (float)height);
  world.f.dimension.y = 1.0f;
 }
}

void Update(int dt) {
}

void Render() {
 glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 
 Mat4 mvMat, pMat,mvpMat;
 Vec4f board_color[4] = {
  0.0, 0.0f, 1.0f, 1.0f, // blue
  1.0, 0.0f, 0.0f, 1.0f, // red
  0.0, 1.0f, 0.0f, 1.0f, //green
  1.0, 1.0f, 0.0f, 1.0f, // yellow
 };
 
 int mvp_loc = glGetUniformLocation(color_sh.program, "u_Mvp");
 int color_loc = glGetUniformLocation(color_sh.program, "u_Color");
 glBindVertexArrayOES(board_mesh.vao);
 glEnableVertexAttribArray(kAttribPosition);
 
 for (int i = 0; i < 4; ++i) {
  mvpMat = GLKMatrix4Multiply(*PerspectiveMatrix(&pMat, &world.f), *ModelViewMatrix(&mvMat, &board_trans[i]));
  glUniformMatrix4fv(mvp_loc, 1, GL_FALSE, mvpMat.m);
  glUniform4fv(color_loc, 1, &board_color[i].v[0]);
  glDrawArrays(GL_LINES, 0, 22);
 }
 
 glDisableVertexAttribArray(kAttribPosition);
 glBindVertexArrayOES(0);
}

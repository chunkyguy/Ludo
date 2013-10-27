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
#include "he/he_Mesh.h"
#include "he/he_Transform.h"

Shader shader;
Mesh cube_mesh;
typedef struct {
 Mesh *m;
 Transform t;
 Vec4f color;
} Cube;
Cube redcube;
Cube bluecube;
typedef struct {
 Frustum f;
 Transform t;
} World;
World world;

void Load() {
 
 // loadShaders();
 CompileShader(&shader, "Shader.vsh", "Shader.fsh");
 
 glEnable(GL_DEPTH_TEST);

 CreateMesh(&cube_mesh, kCommonMesh_Cube);

 DefaultTransform(&world.t);
 world.t.position.z = -10.0f;
 world.t.axis = GLKVector3Make(0.0f, 1.0f, 0.0f);
 
 redcube.m = &cube_mesh;
 DefaultTransform(&redcube.t);
 redcube.t.parent = &world.t;
 redcube.t.position.z = 1.5f;
 redcube.color = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
 
 bluecube.m = &cube_mesh;
 DefaultTransform(&bluecube.t);
 bluecube.t.parent = &world.t;
 bluecube.t.position.z = -1.5f;
 bluecube.color = GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
}

void Unload() {
 ReleaseMesh(&cube_mesh);
 ReleaseShader(&shader);
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
 world.t.angle += dt * 0.05f;
}

void Render() {
 glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
#if defined(DEBUG)
 if (!ValidateShader(&shader)) {
  assert(0);
 }
#endif
 
 // Render tGLK object again with ES2
 glUseProgram(shader.program);

 RenderMesh(redcube.m, &redcube.t, &shader, &world.f, &redcube.color);
 RenderMesh(bluecube.m, &bluecube.t, &shader, &world.f, &bluecube.color);
 
}

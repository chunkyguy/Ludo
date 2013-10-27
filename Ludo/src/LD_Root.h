//
//  Ludo.h
//  Ludo
//
//  Created by Sid on 26/10/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#ifndef Ludo_Ludo_h
#define Ludo_Ludo_h
#include "LD_std_incl.h"

/**
 	Load shaders, globals, buffer objects, textures, default GL state, etc.
 */
void Load();

/**
  Unload everything loaded in Load
 */
void Unload();

/**
 Reset the viewport, update the projection transform
 */
void Reshape(GLsizei width, GLsizei height);

/** 
 Update the objects.
 @param dt Time in milliseconds.
 */
void Update(int dt);

/**
 Render the view.
 */
void Render();

#endif

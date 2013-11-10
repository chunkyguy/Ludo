//
//  Utilities.h
//  OGL_Basic
//
//  Created by Sid on 22/08/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef OGL_Basic_Utilities_h
#define OGL_Basic_Utilities_h

/**
 *	Get absolute Bundle path. Optionally provide a filename.
 *
 *	@param	filename	 The filename (In)
 *	@param	buffer	The absolute path (Out)
 *  @return the buffer
 */
char *BundlePath(char *buffer, const char *filename);

/** Get absolute path of the file inside directory
 The filename is optional.
 Returns the pointer to buffer (for chaining)
 */
char *DocumentPath(char *buffer, const char *filename);

/**
 *	Read a file into buffer
 *
 *	@param	path	 The absolute path of the file. (In)
 *	@param	buffer The buffer (Out)
 * @return The buffer.
 */
char *ReadFile(char *buffer, const char *path);

/** Write the buffer to file at path
  Returns true if operation is successful.
 */
bool WriteFile(const char *path, const char *buffer, size_t size);
#endif

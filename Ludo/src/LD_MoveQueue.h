//
//  LD_MoveQueue.h
//  Ludo
//
//  Created by Sid on 07/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//
#ifndef LD_MoveQueue_H
#define LD_MoveQueue_H

#include "LD_Game.h"
#include "LD_Context.h"

/** Move Queue
 Stores all the moves pending.
 And notify the active listener for any new push, which is the Game player is playing.
 */

/** Init the queue with the storage for all the moves it can hold
 Something like Move moves_buffer[256] should be enough I guess 
 Note, this method won't allocate any memory.
 */
//void BindMoveQueueBuffer(Move *buffer, size_t buffer_sz);

/** The current move queue is unbinded.
  No memory release happens, as not sure how the memeory is allocated.
  Right now I'm not even sure why would you need this.
  This is only useful if you wish to manage more than one memory pools.
  Save one pool to file and bind another.
 */
//void UnbindMoveQueueBuffer();

/** store the move in buffer, might be coming from some other game.
 Return false, in case of exception, like memory overflow (no vacant slot)
 */
//bool StoreAndForwardMove(Move *move);


/** Get all stored moves for a given gameid and a given playerID
  Returns number of saved moves, the buffer should have sufficient space.
 Moves could be more than one, for example, the user is playing the game after a 
 long time.
 Typically, the buffer should not expect more than 3 moves, as this is a 4 player game.
 Don't forget to call DeleteMove after done with the move.
 */
//int StoredMoves(Move *buffer, ID gameID, ID playerID);

/** Delete the move from queue */
//void DeleteMove(ID moveID);

#endif

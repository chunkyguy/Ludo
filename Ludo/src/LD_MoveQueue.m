//
//  LD_MoveQueue.m
//  Ludo
//
//  Created by Sid on 07/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#import "LD_MoveQueue.h"
#include "LD_GamesManager.h"

static unsigned int max_slots;
static Move *buffer_head;

void BindMoveQueueBuffer(Move *buffer, size_t buffer_sz) {
 max_slots = buffer_sz/sizeof(Move);
 buffer_head = buffer;
 bzero(buffer_head, buffer_sz);
}

void UnbindMoveQueueBuffer() {
 max_slots = 0;
 buffer_head = NULL;
}

bool ForwardOrStore(Game *game, Move *move) {
/* Check if the active listener wants this move */
 GameContext *context = CurrentContext();
 if (context && context->game.ID == game->ID) {
  StepGame(game, move);
  return true;
 }
 
 /* else find and store an empty slots */
 Move zmv;
 bzero(&zmv, sizeof(zmv));
 for (int slot = 0; slot < max_slots; ++slot) {
  if (memcmp(buffer_head+slot, &zmv, sizeof(zmv)) == 0) {
   memcpy(buffer_head+slot, move, sizeof(zmv));
   return true;
  }
 }
 return false;
}

int StoredMoves(Move *buffer, gameID gID) {
 int count = 0;
 for (int slot = 0; slot < max_slots; ++slot) {
  if (buffer_head[slot].gID == gID) {
   memcpy(buffer+count, buffer_head+slot, sizeof(Move));
   bzero(buffer_head+slot, sizeof(Move));
   count++;
  }
 }
 return count;
}



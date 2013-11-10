//
//  LD_MoveQueue.m
//  Ludo
//
//  Created by Sid on 07/11/13.
//  Copyright (c) 2013 whackylabs. All rights reserved.
//

#include "LD_MoveQueue.h"

//static unsigned int max_slots;
//static Move *buffer_head;
//
//void BindMoveQueueBuffer(Move *buffer, size_t buffer_sz) {
// max_slots = buffer_sz/sizeof(Move);
// buffer_head = buffer;
// bzero(buffer_head, buffer_sz);
//}
//
//void UnbindMoveQueueBuffer() {
// max_slots = 0;
// buffer_head = NULL;
//}
//
//bool StoreAndForwardMove(Move *move) {
// bool saved = false;
// 
// /* find and store an empty slots */
// Move zmv;
// bzero(&zmv, sizeof(zmv));
// for (int slot = 0; !saved && slot < max_slots; ++slot) {
//  if (memcmp(buffer_head+slot, &zmv, sizeof(zmv)) == 0) {
//   memcpy(buffer_head+slot, move, sizeof(zmv));
//   saved = true;
//  }
// }
//
// /* Check if the active listener wants this move */
// Context *context = CurrentContext();
// if (context && context->game.gameID == move->gameID) {
//  StepGame(&context->game, move);
// }
//
// return saved;
//}
//
//int StoredMoves(Move *buffer, ID gameID, ID playerID) {
// int count = 0;
// for (int slot = 0; slot < max_slots; ++slot) {
//  if (buffer_head[slot].gameID == gameID && buffer[slot].recvID == playerID) {
//   memcpy(buffer+count, buffer_head+slot, sizeof(Move));
//   count++;
//  }
// }
// return count;
//}
//
//void DeleteMove(ID moveID) {
// for (int slot = 0; slot < max_slots; ++slot) {
//  if (buffer_head[slot].moveID == moveID) {
//   bzero(buffer_head+slot, sizeof(Move));
//  }
// }
//}
//

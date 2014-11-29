#ifndef _OP_H
#define _OP_H

// operational state
enum { ST_RUN, ST_ADJ_HOUR, ST_ADJ_MIN, ST_ADJ_SEC, ST_ADJ_BRIGHT };

void op_init( void );
void op_task( void );
void op_proc( uns8 key );

#endif // _OP_H
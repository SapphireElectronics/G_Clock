#ifndef _OP_H
#define _OP_H

// operational state
enum { 	ST_RUN, ST_ADJ_HOUR, ST_ADJ_MIN, ST_ADJ_SEC,
		ST_BRIGHT, ST_DELAY, ST_CLOCK, ST_END };

void op_init( void );
void op_task( void );
void op_proc( uns8 key );
void op_show_param( uns8 data );
void op_adj_param( uns8 data, uns8 key );
uns8 daw( uns8 data );

#endif // _OP_H
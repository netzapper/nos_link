:__init	
	set I, SP
	sub I, 256

	jsr main
:__halt
	set pc, __halt

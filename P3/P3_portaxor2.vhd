--  
-- banc de proves de xor2 estructural

ENTITY bdp_xor IS
END bdp_xor;

ARCHITECTURE test OF bdp_xor IS
	COMPONENT xor2
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

SIGNAL ent1, ent0, sort_xor2: BIT;	

FOR DUT1: porta_xor2 USE ENTITY Work.xor2(estructural);

BEGIN
DUT: porta_xor2 PORT MAP (ent1, ent0, sort_xor2);

PROCESS (ent1, ent0)
BEGIN
	
	ent1 <= NOT ent1 AFTER 50 ns;
	ent0 <= NOT ent0 AFTER 100 ns;

END PROCESS;
END test;


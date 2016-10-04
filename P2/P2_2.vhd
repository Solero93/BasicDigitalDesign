--  
-- xor2

-- entidad xor2

ENTITY xor2 IS
	PORT(a,b : IN BIT; z : OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
BEGIN
z <= a XOR b;
END logica;

ARCHITECTURE logica_retard OF xor2 IS
BEGIN
z <= a XOR b AFTER 2 ns;
END logica_retard;


-- banc de proves de xor2

ENTITY bdp_funcio IS
END bdp_funcio;

ARCHITECTURE vectors OF bdp_funcio IS
	COMPONENT porta_xor2
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

SIGNAL ent1, ent2, sort_xor2_logica, sort_xor2_logica_retard : BIT;

FOR DUT: porta_xor2 USE ENTITY Work.xor2(logica);
FOR DUT2: porta_xor2 USE ENTITY Work.xor2(logica_retard);

BEGIN
DUT: porta_xor2 PORT MAP (ent1,ent2,sort_xor2_logica);
DUT2: porta_xor2 PORT MAP (ent1,ent2,sort_xor2_logica_retard);

PROCESS
BEGIN

	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;

	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;
	
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;

	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;

	ent2 <= '0';
	ent1 <= '0';

END PROCESS;
END vectors;

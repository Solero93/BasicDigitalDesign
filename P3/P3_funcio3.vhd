--  
-- funció3

-- d) s'han comprovat les diferencies i es justifiquen amb el fet de que el retard amb el temps s'acumula i fa que hi hagi aquesta diferéncia amb l'apartat c)
-- e) s'han comprovat les diferéncies i s'intueix que la diferéncia és perqué al haver-hi menys temps de canvi de senyal, tems que s'apropa més al retard, aquesta s'autocorregeix i fa que la senyal d'e sigui semblant a la de c).

ENTITY funcio_3 IS
	PORT(a, b, c, d: IN BIT; z: OUT BIT);
END funcio_3;

ARCHITECTURE logica OF funcio_3 IS
	z <= (((NOT a) AND b AND (NOT c)) OR (b AND (NOT d)) OR (a AND c AND d) OR (a AND (NOT d))) XOR (a OR (NOT d));
END logica;

ARCHITECTURE estructural OF funcio_3 IS
	COMPONENT porta_inversora IS
		PORT(a, b: IN BIT; z: OUT BIT);
        	END COMPONENT;
        	
	COMPONENT porta_and3 IS
		PORT(a, b, c: IN BIT; z: OUT BIT);
        	END COMPONENT;
	
	COMPONENT porta_or4 IS
		PORT (a, b, c, d: IN BIT; z: OUT BIT);
	END COMPONENT;
	
        	SIGNAL not_a, not_b, not_c, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, z: BIT;
        	FOR DUT1: porta_inversora USE ENTITY WORK.inversor(logicaretard);
        	FOR DUT2: porta_inversora USE ENTITY WORK.inversor(logicaretard);
        	FOR DUT3: porta_inversora USE ENTITY WORK.inversor(logicaretard);
        	FOR DUT4: porta_inversora USE ENTITY WORK.inversor(logicaretard);

        	FOR DUT5: porta_and3 USE ENTITY WORK.and3(logicaretard);
        	FOR DUT6: porta_and3 USE ENTITY WORK.and3(logicaretard);
        	FOR DUT7: porta_and3 USE ENTITY WORK.and3(logicaretard);
        	FOR DUT8: porta_and3 USE ENTITY WORK.and3(logicaretard);

        	FOR DUT9: porta_or4 USE ENTITY WORK.or4(logicaretard);
        	FOR DUT10: porta_or4 USE ENTITY WORK.or4(logicaretard);

	FOR DUT11: porta_xor2 USE ENTITY WORK.xor2(logicaretard);

BEGIN
        	DUT1: porta_inversora PORT MAP(a, not_a);
        	DUT2: porta_inversora PORT MAP(b, not_b);
        	DUT3: porta_inversora PORT MAP(c, not_c);
        	DUT4: porta_inversora PORT MAP(d, not_d);
        	
	DUT5: porta_and3 PORT MAP(not_a, b, not_c, tmp1); 
	-- tmp1 = not_a * b * not_c
        	DUT6: porta_and3 PORT MAP(b, not_d, 1, tmp2); 
	-- tmp2 = b * not_d
        	DUT7: porta_and3 PORT MAP(a, c, d, tmp3); 
	-- tmp3 = a * c * d
        	DUT8: porta_and3 PORT MAP(a, not_d, 1, tmp4); 
	-- tmp4 = a * not_d
        	DUT9: porta_or4 PORT MAP(tmp1, tmp2, tmp3, tmp4, tmp5); 
	-- tmp5 = tmp1 + tmp2 + tmp3 + tmp4
        	DUT10: porta_or4 PORT MAP(a, not_d, 0, 0, tmp6);
	-- tmp6 = a + not_d
	DUT11: porta_xor2 PORT MAP(tmp5, tmp6, z);
	-- z és la funció donada;
END estructural;

ENTITY banc_de_proves IS
END banc_de_proves;

ARCHITECTURE test OF banc_de_proves IS
	COMPONENT funcio3
		PORT (a, b, c, d: IN BIT; z: OUT BIT);
	END COMPONENT;

SIGNAL ent3, ent2, ent1, ent0, sor_logica, sor_estructural: BIT;

FOR DUT1: porta_funcio3_est USE ENTITY Work.funcio3(estructural);
FOR DUT2: porta_funcio3_log USE ENTITY Work.funcio3(logica);

BEGIN
DUT: porta_funcio3_est PORT MAP (ent3, ent2, ent1, ent0, sor_estructural);
DUT2: porta_funcio3_log PORT MAP (ent3, ent2, ent1, ent0, sor_logica);

PROCESS (ent3, ent2, ent1, ent0);
BEGIN

	ent3 <= NOT ent3 AFTER 5 ns;
	ent2 <= NOT ent2 AFTER 10 ns;
	ent1 <= NOT ent1 AFTER 20 ns;
	ent0 <= NOT ent0 AFTER 40 ns;

END PROCESS;
END test;
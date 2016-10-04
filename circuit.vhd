--  
-- entidad de pizarra

ENTITY circuit IS
	PORT(a3, a2, a1, a0 : IN BIT; f2, f1, f0 : OUT BIT);
END circuit;

ARCHITECTURE estructural OF circuit IS
	COMPONENT porta_inv IS
		PORT(a: IN BIT; z: OUT BIT);
        	END COMPONENT;
        	
	COMPONENT porta_and2 IS
		PORT(a, b: IN BIT; z: OUT BIT);
        	END COMPONENT;
	
	COMPONENT porta_or2 IS
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_xor2 IS
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL not_a1, not_a0, and_0, not_and_0, xor_0, or_1, and_1, xor_2: BIT;
	--f0
	FOR DUT1: porta_inv USE ENTITY Work.inversor(logica);
	FOR DUT2: porta_inv USE ENTITY Work.inversor(logica);
	FOR DUT3: porta_and2 USE ENTITY Work.and2(logica);
	FOR DUT4: porta_inv USE ENTITY Work.inversor(logica);
	FOR DUT5: porta_xor2 USE ENTITY Work.xor2(logica);
	FOR DUT6: porta_or2 USE ENTITY Work.or2(logica);

	--f1
	FOR DUT7: porta_or2 USE ENTITY Work.or2(logica);
	FOR DUT8: porta_and2 USE ENTITY Work.and2(logica);
	FOR DUT9: porta_xor2 USE ENTITY Work.xor2(logica);
	
	--f2
	FOR DUT10: porta_xor2 USE ENTITY Work.xor2(logica);
	FOR DUT11: porta_and2 USE ENTITY Work.and2(logica);

BEGIN
	--f0
	DUT1: porta_inv PORT MAP (a1, not_a1);
	DUT2: porta_inv PORT MAP (a0, not_a0);
	DUT3: porta_and2 PORT MAP (not_a1, a0, and_0);
	DUT4: porta_inv PORT MAP (and_0, not_and_0);
	DUT5: porta_xor2 PORT MAP (a1, a2, xor_0);
	DUT6: porta_or2 PORT MAP (not_and_0, xor_0, f0);

	--f1
	DUT7: porta_or2 PORT MAP (not_a0, a2, or_1);
	DUT8: porta_and2 PORT MAP (not_a0, a1, and_1);
	DUT9: porta_xor2 PORT MAP (or_1, and_1, f1);

	--f2
	DUT10: porta_xor2 PORT MAP(not_a0, a3, xor_2);
	DUT11: porta_and2 PORT MAP(a2, xor_2, f2);
		
END estructural;

-- banc de proves de circuit

ENTITY bdp_funcio2 IS
END bdp_funcio2;

ARCHITECTURE vectors2 OF bdp_funcio2 IS
	COMPONENT circuit_pizarra
		PORT (a3, a2, a1, a0: IN BIT; f2, f1, f0: OUT BIT);
	END COMPONENT;

SIGNAL ent1, ent2, ent3, ent4, sort_f0, sort_f1, sort_f2: BIT;

FOR DUT: circuit_pizarra USE ENTITY Work.circuit(estructural);

BEGIN
DUT: circuit_pizarra PORT MAP (ent4, ent3, ent2, ent1, sort_f0, sort_f1, sort_f2);

PROCESS (ent4,ent3,ent2,ent1)
BEGIN

	ent4 <= NOT ent4 AFTER 50 ns;
	ent3 <= NOT ent3 AFTER 100 ns;
	ent2 <= NOT ent2 AFTER 200 ns;
	ent1 <= NOT ent1 AFTER 400 ns;

END PROCESS;
END vectors2;
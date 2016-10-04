-- Christian José Soler
-- entidad de pizarra

ENTITY circuit IS
	PORT(a0, a1, a2, a3 : IN BIT; f1, f2, f3 : OUT BIT);
END circuit;

ARCHITECTURE logica OF circuit IS
BEGIN
f1 <= ((a1 AND a0) OR (a1 XOR a2));
f2 <= ((a2 OR a0) XOR (a1 AND a0));
f3 <= ((a3 XOR a0) AND a2);
END logica;


-- banc de proves de circuit

ENTITY bdp_funcio2 IS
END bdp_funcio2;

ARCHITECTURE vectors2 OF bdp_funcio2 IS
	COMPONENT circuit_pizarra
		PORT (a0, a1, a2, a3: IN BIT; f1, f2, f3: OUT BIT);
	END COMPONENT;

SIGNAL ent1, ent2, ent3, ent4, sort_f1, sort_f2, sort_f3: BIT;

FOR DUT: circuit_pizarra USE ENTITY Work.circuit_pizarra(logica);

BEGIN
DUT: circuit_pizarra PORT MAP (ent1,ent2,ent3,ent4,sort_f1, sort_f2, sort_f3);

PROCESS
BEGIN
--
	ent4 <= '0';
	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '0';
	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;
--
	ent4 <= '1';
	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;
END PROCESS;
END vectors2;
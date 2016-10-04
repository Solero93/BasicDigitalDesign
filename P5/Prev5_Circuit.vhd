-- D Latch y prioridad en Preset
ENTITY D_Latch_PreSet IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END D_Latch_PreSet;

ARCHITECTURE ifthen OF D_Latch_PreSet IS
SIGNAL qint: BIT;
BEGIN
PROCESS (D,Clk,Pre,Clr)
BEGIN
IF Pre='0' THEN qint<='1' AFTER 2ns;
		ELSE
		IF Clr='0' THEN qint<='0' AFTER 2ns;
			ELSE
			IF Clk = '1' THEN
				ELSE qint<='0' AFTER 6ns;
			END IF;
		END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

-- JK FF con flanco de subida y prioridad en Preset
ENTITY JK_FF_Subida_PreSet IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END JK_FF_Subida_PreSet;

ARCHITECTURE ifthen OF JK_FF_Subida_PreSet IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Pre='0' THEN qint<='1' AFTER 2ns;
ELSE
IF Clr='0' THEN qint<='0' AFTER 2ns;
ELSE
		IF Clk'EVENT AND Clk='1' THEN
			IF J='0' AND K='0' THEN qint<=qint AFTER 6ns;
			ELSIF J='0' AND K='1' THEN qint<='0' AFTER 6ns;
			ELSIF J='1' AND K='0' THEN qint<='1' AFTER 6ns;
			ELSIF J='1' AND K='1' THEN qint<= NOT qint AFTER 6ns;
			END IF;

		END IF;
	END IF;
END IF;

END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

-- Banco de Pruebas de ambos
ENTITY banco_pruebas IS
END banco_pruebas;

ARCHITECTURE test OF banco_pruebas IS
	COMPONENT mi_D_Latch_PreSet IS
	PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_JK_FF_Subida_PreSet IS
	PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	SIGNAL ent1,ent2,clock,preset,clear,Dsort_Q,Dsort_noQ,JKsort_Q,JKsort_noQ: BIT;
	FOR DUT1: mi_D_Latch_PreSet USE ENTITY WORK.D_Latch_PreSet(ifthen);
	FOR DUT2: mi_JK_FF_Subida_PreSet USE ENTITY WORK.JK_FF_Subida_PreSet(ifthen);

BEGIN
DUT1: mi_D_Latch_PreSet PORT MAP (ent1,clock,preset,clear,Dsort_Q,Dsort_noQ);
DUT2: mi_JK_FF_Subida_PreSet PORT MAP (ent1,ent2,clock,preset,clear,JKsort_Q,JKsort_noQ);
ent1 <= NOT ent1 AFTER 800 ns;
ent2 <= NOT ent2 AFTER 400 ns;
clock <= NOT clock AFTER 500 ns;
preset <= '0', '1' AFTER 600 ns;
clear <= '1','0' AFTER 200ns, '1' AFTER 400 ns;
END test;

-- Entidad que representa el circuito que nos pedian y su logica estructural
ENTITY circuit_biestable IS
	PORT(x,Clk,Prt,Clr: IN BIT; z: OUT BIT);
END circuit_biestable;

ARCHITECTURE estructural OF circuit_biestable IS
	COMPONENT jk IS
		PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT d IS
		PORT(D,Clk,Pre,Clr: IN BIT; Q, NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT nor2 IS
		PORT(a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and2 IS
		PORT(a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL q1, nq1, and1, nor1, nq2: BIT;

	FOR DUT1: d USE ENTITY Work.D_Latch_PreSet(logica);
	FOR DUT2: and2 USE ENTITY Work.and2(logica);
	FOR DUT3: nor2 USE ENTITY Work.nor2(logica);
	FOR DUT4: jk USE ENTITY Work.JK_FF_Subida_PreSet(logica);
	
	BEGIN	

	DUT1: d PORT MAP(x,Clk,Prt,Clr,q1,nq1);
	DUT2: and2 PORT MAP(nq1,x,and1);
	DUT3: nor2 PORT MAP(q1,Clk,nor1);
	DUT4: jk PORT MAP(and1,nor1,Clk,Prt,Clr,z,nq2);
END estructural;

-- El banco de pruebas de la entidad
ENTITY test_bench IS
END test_bench;

ARCHITECTURE test of test_bench IS
	COMPONENT circuit_biestable IS
		PORT(x,Clk,Prt,Clr: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL ent, ck, Preset, Clear, sort: BIT;
	FOR DUT1: circuit_biestable USE ENTITY WORK.circuit_biestable(estructural);


	BEGIN
	DUT1 : circuit_biestable PORT MAP(ent,ck,Preset,Clear,sort);

	Preset<='1';
	Clear<='1';
	ent <= NOT ent AFTER 400 ns;
	ck <= NOT ck AFTER 500 ns;
END test;
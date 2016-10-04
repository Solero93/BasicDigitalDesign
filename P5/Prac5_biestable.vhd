-- T FF con flanco de bajada y solo preset
ENTITY T_Bajada_PreSet IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END T_Bajada_PreSet;

ARCHITECTURE ifthen OF T_Bajada_PreSet IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Pre,Clr)
BEGIN
IF Pre='0' THEN qint<='1' AFTER 3ns;
	ELSE
	IF Clr='0' THEN qint <= '0' AFTER 3 ns;
	ELSE
		IF Clk'EVENT AND Clk='0' THEN
			IF T='0' THEN qint<=qint AFTER 3ns;
			ELSE qint<=NOT qint AFTER 3ns;
			END IF;
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
IF Pre='0' THEN qint<='1' AFTER 3ns;
ELSE
IF Clr='0' THEN qint<='0' AFTER 3ns;
ELSE
		IF Clk'EVENT AND Clk='1' THEN
			IF J='0' AND K='0' THEN qint<=qint AFTER 3ns;
			ELSIF J='0' AND K='1' THEN qint<='0' AFTER 3ns;
			ELSIF J='1' AND K='0' THEN qint<='1' AFTER 3ns;
			ELSIF J='1' AND K='1' THEN qint<= NOT qint AFTER 3ns;
			END IF;

		END IF;
	END IF;
END IF;

END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

--SUMADOR MODIFICAT D'UN BIT
--Aquesta és la entitat del sumador modificat d'un bit que volem implementar
ENTITY sumador_modificat_1bit IS
PORT (a,b,cin: IN BIT; suma_smod_1bit,cout_smod_1bit,aib_smod_1bit,aob_smod_1bit: OUT BIT);
END sumador_modificat_1bit;

-- Aquesta és la definició del sumador modificat de forma estructural
ARCHITECTURE estructural OF sumador_modificat_1bit IS

COMPONENT portaand2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portaxor2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT ;

--Ens calen 6 DUTs.
FOR DUT1: portaxor2 USE ENTITY WORK.xor2(estructural);
FOR DUT2: portaxor2 USE ENTITY WORK.xor2(estructural);
FOR DUT3: portaand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT4: portaor2 USE ENTITY WORK.or2(logicaretard);
FOR DUT5: portaand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT6: portaor2 USE ENTITY WORK.or2(logicaretard);

-- Calen 4 senyals interns
SIGNAL sort_xor,sort_or,sort_and1,sort_and2: BIT;
-- Un cop introduïts tots els blocs i senyals, passem a realitzar les connexions
-- i, d'aquesta forma,
-- fer la definició de la funció lògica en funció de les variables a, b i cin.

BEGIN

	DUT1: portaxor2 PORT MAP (a,b,sort_xor);
	DUT2: portaxor2 PORT MAP(sort_xor,cin,suma_smod_1bit);
	DUT3: portaand2 PORT MAP (a,b,sort_and1);
	DUT4: portaor2 PORT MAP(a,b,sort_or);
	DUT5: portaand2 PORT MAP (sort_or,cin,sort_and2);
	DUT6: portaor2 PORT MAP (sort_and1,sort_and2,cout_smod_1bit);

-- ara introduïm quins senyals interns s’utilitzen, també, com externs
aib_smod_1bit <= sort_and1;
aob_smod_1bit <= sort_or;

END estructural;

-- Implementamos el circuito que nos pide la practica 5:
ENTITY circuit_prac5 IS
	PORT(x,y,Clk: IN BIT; z: OUT BIT);
END circuit_prac5;

ARCHITECTURE estructural OF circuit_prac5 IS
	COMPONENT FF_T_baixada IS
		PORT (T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;
	
	COMPONENT FF_JK_pujada IS
		PORT (J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT sumador_1bit_modificat IS
		PORT (a,b,cin: IN BIT; suma_smod_1bit,cout_smod_1bit,aib_smod_1bit,aob_smod_1bit: OUT BIT);
	END COMPONENT;

	-- DUTS
	FOR DUT1: FF_T_baixada USE ENTITY Work.T_Bajada_PreSet(ifthen);
	FOR DUT2: sumador_1bit_modificat USE ENTITY Work.sumador_modificat_1bit(estructural);
	FOR DUT3: FF_JK_pujada USE ENTITY Work.JK_FF_Subida_PreSet(ifthen);

	SIGNAL ent, pre1, ck, s, cout, clear,preset, q1: BIT;
BEGIN
	clear<='1';
	preset<='1';
	DUT1: FF_T_baixada PORT MAP(ent,ck,pre1,clear,q1);
	DUT2: sumador_1bit_modificat PORT MAP(ck,ck,q1,s,cout);
	DUT3: FF_JK_pujada PORT MAP(s,cout,ck,preset,clear,z);

END estructural;


ENTITY testbench IS
	END testbench;

ARCHITECTURE test OF testbench IS
	SIGNAL x,y,ck: BIT;

	COMPONENT circuit_prac5 IS
		PORT (x,y,ck: IN BIT; z: OUT BIT);
	END COMPONENT;

	FOR DUT: circuit_prac5 USE ENTITY Work.circuit_prac5(estructural);

	BEGIN
		DUT: circuit_prac5 PORT MAP(x,y,ck,z);
	PROCESS(x,y,ck)
	BEGIN
		ck <= NOT ck AFTER 200 ns;
		x <= '1'


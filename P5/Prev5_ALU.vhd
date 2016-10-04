ENTITY entradesAlu IS
PORT( senyal: IN BIT_VECTOR (2 DOWNTO 0);  a,b: IN BIT_VECTOR(7 DOWNTO 0); ain, bin: OUT BIT_VECTOR (7 DOWNTO 0); cin: OUT BIT);
END entradesAlu;
ARCHITECTURE ifthen OF entradesAlu IS
BEGIN
PROCESS (senyal, a, b)
BEGIN
	IF senyal="000" THEN ain<=a; bin<=b; cin<='0';
	ELSIF senyal="001" THEN ain<=a; bin<=not b; cin<='1';
	ELSIF senyal="010" THEN ain<=a; bin<="11111111"; cin<='0';
	ELSIF senyal="011" THEN ain<=a; bin<="00000000"; cin<='1';
	ELSIF senyal="100" THEN ain<="00000000"; bin<=not b; cin<='1';
	ELSIF senyal="101" THEN ain<=a; bin<= b; cin<='0';
	ELSIF senyal="110" THEN ain<=a; bin<= b; cin<='0';
	ELSIF senyal="111" THEN ain<=a; bin<= "11111111"; cin<='0';
	END IF;
END PROCESS;
END ifthen;



ENTITY sortidaAlu IS
PORT( senyal: IN BIT_VECTOR (2 DOWNTO 0);  suma, ors, ands: IN BIT_VECTOR(7 DOWNTO 0); z: OUT BIT_VECTOR (7 DOWNTO 0));
END sortidaAlu;
ARCHITECTURE ifthen OF sortidaAlu IS
BEGIN
PROCESS (senyal, suma, ors, ands)
BEGIN
	IF senyal(2)='0' THEN z<=suma;
	ElSIF senyal="100" THEN z<=suma;
	ELSIF senyal="101" THEN z<=ors;
	ELSE z<=ands;
	END IF;
END PROCESS;
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
FOR DUT1: portaxor2 USE ENTITY WORK.xor2(logica);
FOR DUT2: portaxor2 USE ENTITY WORK.xor2(logica);
FOR DUT3: portaand2 USE ENTITY WORK.and2(logica);
FOR DUT4: portaor2 USE ENTITY WORK.or2(logica);
FOR DUT5: portaand2 USE ENTITY WORK.and2(logica);
FOR DUT6: portaor2 USE ENTITY WORK.or2(logica);

-- Calen 4 senyals interns
SIGNAL sort_xor,sort_or,sort_and1,sort_and2: BIT;

-- Un cop introduïts tots els blocs i senyals, passem a realitzar les connexions
-- i, d'aquesta forma,
-- fer la definició de la funció lògica en funció de les variables a, b i cin.

BEGIN

	DUT1: portaxor2 PORT MAP (a,b,sort_xor);
	DUT2: portaxor2 PORT MAP( sort_xor,cin,suma_smod_1bit);
	DUT3: portaand2 PORT MAP (a,b,sort_and1);
	DUT4: portaor2 PORT MAP( a,b,sort_or);
	DUT5: portaand2 PORT MAP (sort_or,cin,sort_and2);
	DUT6: portaor2 PORT MAP (sort_and1,sort_and2,cout_smod_1bit);

-- ara introduïm quins senyals interns s’utilitzen, també, com externs
aib_smod_1bit <= sort_and1;
aob_smod_1bit <= sort_or;

END estructural;


ENTITY sumador_modificat_8bits IS
PORT (a,b: IN BIT_VECTOR(7 DOWNTO 0);cin: IN BIT; suma_smod_8bits: OUT BIT_VECTOR(7 DOWNTO 0);cout: OUT BIT;aib_smod_8bits,aob_smod_8bits: OUT BIT_VECTOR (7 DOWNTO 0));
END sumador_modificat_8bits;

-- Aquesta és la definició del sumador modificat de forma estructural
ARCHITECTURE estructural OF sumador_modificat_8bits IS

COMPONENT mi_sumador_modificat_1bit IS
PORT (a,b,cin: IN BIT; suma_smod_1bit,cout_smod_1bit,aib_smod_1bit,aob_smod_1bit: OUT BIT);
END COMPONENT;

--Ens calen 8 DUTs.
FOR DUT1: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT2: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT3: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT4: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT5: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT6: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT7: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);
FOR DUT8: mi_sumador_modificat_1bit USE ENTITY WORK.sumador_modificat_1bit(estructural);

-- Calen 8 senyals interns
SIGNAL cout_int: BIT_VECTOR (7 DOWNTO 0);

-- Un cop introduïts tots els blocs i senyals, passem a realitzar les connexions i, d'aquesta forma,
-- fer la definició de la funció lògica en funció de les variables a, b i cin.
BEGIN
	DUT1: mi_sumador_modificat_1bit PORT MAP (a(0),b(0),cin,suma_smod_8bits(0),cout_int(0),aib_smod_8bits(0),aob_smod_8bits(0));
	DUT2: mi_sumador_modificat_1bit PORT MAP (a(1),b(1),cout_int(0),suma_smod_8bits(1),cout_int(1),aib_smod_8bits(1),aob_smod_8bits(1));
	DUT3: mi_sumador_modificat_1bit PORT MAP (a(2),b(2),cout_int(1),suma_smod_8bits(2),cout_int(2),aib_smod_8bits(2),aob_smod_8bits(2));
	DUT4: mi_sumador_modificat_1bit PORT MAP (a(3),b(3),cout_int(2),suma_smod_8bits(3),cout_int(3),aib_smod_8bits(3),aob_smod_8bits(3));
	DUT5: mi_sumador_modificat_1bit PORT MAP (a(4),b(4),cout_int(3),suma_smod_8bits(4),cout_int(4),aib_smod_8bits(4),aob_smod_8bits(4));
	DUT6: mi_sumador_modificat_1bit PORT MAP (a(5),b(5),cout_int(4),suma_smod_8bits(5),cout_int(5),aib_smod_8bits(5),aob_smod_8bits(5));
	DUT7: mi_sumador_modificat_1bit PORT MAP (a(6),b(6),cout_int(5),suma_smod_8bits(6),cout_int(6),aib_smod_8bits(6),aob_smod_8bits(6));
	DUT8: mi_sumador_modificat_1bit PORT MAP (a(7),b(7),cout_int(6),suma_smod_8bits(7),cout_int(7),aib_smod_8bits(7),aob_smod_8bits(7));

-- ara introduïm que el carry de sortida és un dels senyals interns:
cout<= cout_int(7);
END estructural;

ENTITY D_Latch_PreClr IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END D_Latch_PreClr;

ARCHITECTURE ifthen OF D_Latch_PreClr IS
SIGNAL qint: BIT;
BEGIN
PROCESS (D,Clk,Pre,Clr)
BEGIN
IF Pre='0' THEN qint<='1' AFTER 2ns;
                ELSE
                IF Clr='0' THEN qint<='0' AFTER 2ns;
                        ELSE
                        IF Clk = '1' THEN
                                IF D='1' THEN qint<='1' AFTER 6ns;
                                ELSE qint<='0' AFTER 6ns;
				END IF;
                        END IF;
                END IF;
        END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;





ENTITY Alu8 IS
PORT (senyals: IN BIT_VECTOR (2 DOWNTO 0); a,b: IN BIT_VECTOR(7 DOWNTO 0);clk, Pre, Clr: IN BIT; z: OUT BIT_VECTOR (7 DOWNTO 0));
END Alu8;

ARCHITECTURE estructural OF Alu8 IS

COMPONENT entradesAlu IS
PORT ( senyal: IN BIT_VECTOR (2 DOWNTO 0);  a,b: IN BIT_VECTOR(7 DOWNTO 0); ain, bin: OUT BIT_VECTOR (7 DOWNTO 0); cin: OUT BIT);
END COMPONENT;

COMPONENT sortidaAlu IS
PORT( senyal: IN BIT_VECTOR (2 DOWNTO 0);  suma, ors, ands: IN BIT_VECTOR(7 DOWNTO 0); z: OUT BIT_VECTOR (7 DOWNTO 0));
END COMPONENT;

COMPONENT sumadorMod IS
PORT(a,b: IN BIT_VECTOR(7 DOWNTO 0);cin: IN BIT; suma_smod_8bits: OUT BIT_VECTOR(7 DOWNTO 0);cout: OUT BIT;aib_smod_8bits,aob_smod_8bits: OUT BIT_VECTOR (7 DOWNTO 0));
END COMPONENT;

COMPONENT LatchD IS
PORT(d, clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;


SIGNAL ain, bin, suma, ands, ors, d, NO_Q: BIT_VECTOR (7 DOWNTO 0);
SIGNAL cin, cout: BIT; 
FOR DUT1: entradesAlu USE ENTITY WORK.entradesAlu(ifthen);
FOR DUT2: sumadorMod USE ENTITY WORK. sumador_modificat_8bits(estructural);
FOR DUT3: sortidaAlu USE ENTITY WORK.sortidaAlu(ifthen);
FOR DUT4: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT5: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT6: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT7: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT8: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT9: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT10: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);
FOR DUT11: LatchD USE ENTITY WORK.D_Latch_PreClr(ifthen);



BEGIN

DUT1: entradesAlu PORT MAP(senyals, a, b, ain, bin, cin);
DUT2: sumadorMod PORT MAP(ain, bin, cin, suma, cout, ands, ors);
DUT3: sortidaAlu PORT MAP(senyals, suma, ors, ands, d);
DUT4: LatchD PORT MAP(d(0), clk, Pre, Clr, z(0), NO_Q(0));
DUT5: LatchD PORT MAP(d(1), clk, Pre, Clr, z(1), NO_Q(1));
DUT6: LatchD PORT MAP(d(2), clk, Pre, Clr, z(2), NO_Q(2));
DUT7: LatchD PORT MAP(d(3), clk, Pre, Clr, z(3), NO_Q(3));
DUT8: LatchD PORT MAP(d(4), clk, Pre, Clr, z(4), NO_Q(4));
DUT9: LatchD PORT MAP(d(5), clk, Pre, Clr, z(5), NO_Q(5));
DUT10: LatchD PORT MAP(d(6), clk, Pre, Clr, z(6), NO_Q(6));
DUT11: LatchD PORT MAP(d(7), clk, Pre, Clr, z(7), NO_Q(7));


END estructural;


--Banc de proves

ENTITY bdp_Alu8 IS
END bdp_Alu8;
ARCHITECTURE test OF bdp_Alu8 IS
SIGNAL paraula_a, paraula_b, z: BIT_VECTOR(7 DOWNTO 0);
SIGNAL senyal:BIT_VECTOR(2 DOWNTO 0);
SIGNAL clk, Pre, Clr: BIT;

COMPONENT comp_Alu8 IS
PORT (senyals: IN BIT_VECTOR (2 DOWNTO 0); a,b: IN BIT_VECTOR(7 DOWNTO 0); clk, Pre, Clr: IN BIT; z: OUT BIT_VECTOR (7 DOWNTO 0));
END COMPONENT;

FOR DUT: comp_Alu8  USE ENTITY WORK.Alu8(estructural);

BEGIN
DUT: comp_Alu8 PORT MAP(senyal, paraula_a, paraula_b,clk, Pre, Clr, z);

PROCESS(senyal, paraula_a, paraula_b,clk, Pre, Clr)

                BEGIN	
			Pre<='1';
			Clr<='1';
			clk<= NOT clk AFTER 25ns;
                        paraula_a(0)<= NOT paraula_a(0) AFTER 50ns;
                        paraula_a(1)<= NOT paraula_a(1) AFTER 100ns;
                        paraula_a(2)<= NOT paraula_a(2) AFTER 150ns;
                        paraula_a(3)<= NOT paraula_a(3) AFTER 200ns;
                        paraula_b(0)<= NOT paraula_b(0) AFTER 250ns;
                        paraula_b(1)<= NOT paraula_b(1) AFTER 300ns;
                        paraula_b(2)<= NOT paraula_b(2) AFTER 350ns;
                        paraula_b(3)<= NOT paraula_b(3) AFTER 400ns;
                        paraula_a(4)<= NOT paraula_a(4) AFTER 450ns;
                        paraula_a(5)<= NOT paraula_a(5) AFTER 500ns;
			paraula_a(6)<= NOT paraula_a(6) AFTER 550ns;
                        paraula_a(7)<= NOT paraula_a(7) AFTER 600ns;
                        paraula_b(4)<= NOT paraula_b(4) AFTER 650ns;
                        paraula_b(5)<= NOT paraula_b(5) AFTER 700ns;
                        paraula_b(6)<= NOT paraula_b(6) AFTER 750ns;
                        paraula_b(7)<= NOT paraula_b(7) AFTER 800ns;

                        senyal(0)<= NOT senyal(0) AFTER 850ns;
			senyal(1)<= NOT senyal(1) AFTER 900ns;
			senyal(2)<= NOT senyal(2) AFTER 950ns;
                END PROCESS;
        END test;


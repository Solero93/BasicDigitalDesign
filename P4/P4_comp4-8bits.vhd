-- Christian Jose Soler - Comparador de 4 y 8 bits

ENTITY ajunta IS
PORT(enable: IN BIT; resu1, resu2: IN BIT_VECTOR (2 DOWNTO 0);z: OUT BIT_VECTOR (2 DOWNTO 0));
END ajunta;
ARCHITECTURE ifthen OF ajunta IS
BEGIN
PROCESS (enable,resu1,resu2)
BEGIN
	IF enable='1' THEN z<="000";
	ELSE
		IF resu1(0)='1' THEN z<="001";
		ELSIF resu1(2)='1' THEN z<="100";
		ELSIF resu1(1)='1' THEN
			IF resu2(0)='1' THEN z<="001";
			ELSIF resu2(2)='1' THEN z<="100";
			ELSIF resu2(1)='1' THEN z<="010";
			END IF;
		END IF;
	END IF;
END PROCESS;
END ifthen;




ENTITY comparador_4bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(3 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END comparador_4bits;
ARCHITECTURE estructural OF comparador_4bits IS
COMPONENT comp2bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(1 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

COMPONENT ajunta IS
PORT(enable: IN BIT;resu1, resu2: IN BIT_VECTOR (2 DOWNTO 0);z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

SIGNAL alfa1,alfa2,beta1,beta2: BIT_VECTOR (1 DOWNTO 0);
SIGNAL sort1, sort2, sortida: BIT_VECTOR (2 DOWNTO 0); 
FOR DUT1: comp2bits USE ENTITY WORK.comparador_2bits(ifthen);
FOR DUT2: comp2bits USE ENTITY WORK.comparador_2bits(ifthen);
FOR DUT3: ajunta USE ENTITY WORK.ajunta(ifthen);


-- Els dispositius que necessitem ...

BEGIN
alfa1(1)<=a(3);
alfa1(0)<=a(2);
-- Aquesta és la forma d’assignar els dos bits de més pes del vector a
-- als dos bits del vector alfa1.
alfa2(1)<=a(1);
alfa2(0)<=a(0);
-- I aquesta, els dos de menys pes.
beta1(1)<=b(3);
beta1(0)<=b(2);
beta2(1)<=b(1);
beta2(0)<=b(0);
-- Igual però per el vector b.

DUT1: comp2bits PORT MAP(enable, alfa1, beta1, sort1);
DUT2: comp2bits PORT MAP(enable, alfa2, beta2, sort2);
DUT3: ajunta PORT MAP(enable, sort1, sort2, sortida);
-- Els PORT MAP que calguin ...
END estructural;


ENTITY bdp_comp4 IS
END bdp_comp4;
ARCHITECTURE test OF bdp_comp4 IS
SIGNAL paraula_a, paraula_b: BIT_VECTOR(3 DOWNTO 0);
SIGNAL z:BIT_VECTOR(2 DOWNTO 0);
SIGNAL enable: BIT;

COMPONENT comparador_4bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(3 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

FOR DUT: comparador_4bits  USE ENTITY WORK.comparador_4bits(estructural);

BEGIN
DUT: comparador_4bits PORT MAP(enable, paraula_a, paraula_b, z);

PROCESS(enable, paraula_a, paraula_b)

BEGIN	
paraula_a(0)<= NOT paraula_a(0) AFTER 50ns;
paraula_a(1)<= NOT paraula_a(1) AFTER 100ns;
paraula_a(2)<= NOT paraula_a(2) AFTER 150ns;
paraula_a(3)<= NOT paraula_a(3) AFTER 200ns;
paraula_b(0)<= NOT paraula_b(0) AFTER 250ns;
paraula_b(1)<= NOT paraula_b(1) AFTER 300ns;
paraula_b(2)<= NOT paraula_b(2) AFTER 350ns;
paraula_b(3)<= NOT paraula_b(3) AFTER 400ns;
enable<= NOT enable AFTER 450ns;
END PROCESS;
END test;

ENTITY comparador_8bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(7 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END comparador_8bits;
ARCHITECTURE estructural OF comparador_8bits IS
SIGNAL p1, p2:BIT_VECTOR(2 DOWNTO 0);
SIGNAL resu1, resu2:BIT;
SIGNAL alfa1, alfa2, beta1, beta2:BIT_VECTOR(3 DOWNTO 0);
COMPONENT comp4bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(3 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

COMPONENT portand2 IS
PORT(a,b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT portor2 IS
PORT(a,b:IN BIT; z: OUT BIT);
END COMPONENT;

FOR DUT1: comp4bits USE ENTITY WORK.comparador_4bits(ifthen);
FOR DUT2: comp4bits USE ENTITY WORK.comparador_4bits(ifthen);
FOR DUT3: portand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT4: portor2 USE ENTITY WORK.or2(logicaretard);
FOR DUT5: portand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT6: portand2 USE ENTITY WORK.and2(logicaretard);
FOR DUT7: portor2 USE ENTITY WORK.or2(logicaretard);

BEGIN
alfa1(3)<=a(7);
alfa1(2)<=a(6);
alfa1(1)<=a(5);
alfa1(0)<=a(4);
alfa2(3)<=a(3);
alfa2(2)<=a(2);
alfa2(1)<=a(1);
alfa2(0)<=a(0);
beta1(3)<=b(7);
beta1(2)<=b(6);
beta1(1)<=b(5);
beta1(0)<=b(4);
beta2(3)<=b(3);
beta2(2)<=b(2);
beta2(1)<=b(1);
beta2(0)<=b(0);

DUT1: comp4bits PORT MAP(enable, alfa1, beta1, p1);
DUT2: comp4bits PORT MAP(enable, alfa2, beta2, p2);
DUT3: portand2 PORT MAP(p1(1), p2(0), resu1);
DUT4: portor2 PORT MAP(resu1, p1(0), z(0));
DUT5: portand2 PORT MAP(p1(1), p2(1), z(1));
DUT6: portand2 PORT MAP(p1(1), p2(2), resu2);
DUT7: portor2 PORT MAP(resu2, p1(2), z(2));

END estructural;

ENTITY bdp_comp8 IS
END bdp_comp8;
ARCHITECTURE test OF bdp_comp8 IS
SIGNAL paraula_a, paraula_b: BIT_VECTOR(7 DOWNTO 0);
SIGNAL z:BIT_VECTOR(2 DOWNTO 0);
SIGNAL enable: BIT;
COMPONENT comparador_8bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(7 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

FOR DUT: comparador_8bits  USE ENTITY WORK.comparador_8bits(estructural);

BEGIN
DUT: comparador_8bits PORT MAP(enable, paraula_a, paraula_b, z);

PROCESS(enable, paraula_a, paraula_b)

		BEGIN
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

			enable<= NOT enable AFTER 850ns;
		END PROCESS;
	END test;

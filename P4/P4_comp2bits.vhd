-- Christian Jose Soler - Comparador de 2 bits

ENTITY comparador_2bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(1 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END comparador_2bits;

ARCHITECTURE ifthen OF comparador_2bits IS
BEGIN
        PROCESS (enable,a,b)
        BEGIN
		IF enable='1' THEN z<="000";
		ELSE
            	IF a(1)='1' AND b(1)='0' THEN z<="100";
              	ELSIF a(1)='0' AND b(1)='1' THEN z<="001";
              	ELSIF a(1)=b(1) THEN
                  	IF a(0)='1' AND b(0)='0' THEN z<="100";
                  	ELSIF a(0)='0' AND b(0)='1' THEN z<="001";
			ELSIF a(0)=b(0) THEN z<="010";
                  	END IF;
              	END IF;
		END IF;
        END PROCESS;
END ifthen;

-- Banco de pruebas del comparador de 2 bits

ENTITY banc_de_proves IS
END banc_de_proves;

ARCHITECTURE test OF banc_de_proves IS

COMPONENT comparador_2bits IS
PORT (enable: IN BIT; a,b: IN BIT_VECTOR(1 DOWNTO 0); z: OUT BIT_VECTOR (2 DOWNTO 0));
END COMPONENT;

SIGNAL enable: BIT;
SIGNAL paraula_a,paraula_b: BIT_VECTOR (1 DOWNTO 0);
SIGNAL sortida: BIT_VECTOR (2 DOWNTO 0);


FOR DUT: comparador_2bits USE ENTITY WORK.comparador_2bits(ifthen);

BEGIN
DUT: comparador_2bits PORT MAP (enable,paraula_a,paraula_b,sortida);

PROCESS
BEGIN
enable<='1'; WAIT FOR 207ns;
enable<='0'; WAIT FOR 309ns;
enable<='1'; WAIT FOR 500ns;
enable<='0';

END PROCESS;

PROCESS (paraula_a,paraula_b)
BEGIN
paraula_a (0)<= NOT paraula_a (0) AFTER 50ns;
paraula_a (1)<= NOT paraula_a (1) AFTER 100ns;
paraula_b (0)<= NOT paraula_b (0) AFTER 30ns;
paraula_b (1)<= NOT paraula_b (1) AFTER 60ns;

END PROCESS;
END test;

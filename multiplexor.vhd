-- ENTITAT multiplexor de 8 a 1
ENTITY mux8a1 IS
	PORT (enable: IN BIT; a : IN BIT_VECTOR(7 DOWNTO 0); s : IN BIT_VECTOR(2 DOWNTO 0); z: OUT BIT);
	END mux8a1;

-- seva arquitectura ifthen
ARCHITECTURE ifthen OF mux8a1 IS
BEGIN
	PROCESS(enable,s,a)
	BEGIN
		IF enable = '1' THEN z<='0' AFTER 5 ns;
		ELSE
			IF s = "000" THEN z<=a(0) AFTER 5 ns;
			ELSIF s = "001" THEN z<=a(1) AFTER 5 ns;
			ELSIF s = "010" THEN z<=a(2) AFTER 5 ns;
			ELSIF s = "011" THEN z<=a(3) AFTER 5 ns;
			ELSIF s = "100" THEN z<=a(4) AFTER 5 ns;
			ELSIF s = "101" THEN z<=a(5) AFTER 5 ns;
			ELSIF s = "110" THEN z<=a(6) AFTER 5 ns;
			ELSIF s = "111" THEN z<=a(7) AFTER 5 ns;
			END IF;
		END IF;
	END PROCESS;
END ifthen;

-- banc de proves del multiplexor
ENTITY bdp_mux IS
END bdp_mux;

ARCHITECTURE test OF bdp_mux IS

	COMPONENT mux8a1 IS
		PORT(enable: IN BIT; a : IN BIT_VECTOR(7 DOWNTO 0); s : IN BIT_VECTOR(2 DOWNTO 0); z: OUT BIT);
	END COMPONENT;

	SIGNAL e: BIT;
	SIGNAL ent : BIT_VECTOR(7 DOWNTO 0);
	SIGNAL sel: BIT_VECTOR(2 DOWNTO 0);
	SIGNAL sort: BIT;

	FOR DUT: mux8a1 USE ENTITY Work.mux8a1(ifthen);

	BEGIN
		DUT: mux8a1 PORT MAP(e,ent,sel,sort);
	
	PROCESS (e,ent,sel)
	BEGIN
	e <= NOT e AFTER 1920 ns;
	
	sel(0) <= NOT sel(0) AFTER 40 ns;
	sel(1) <= NOT sel(1) AFTER 80 ns;
	sel(2) <= NOT sel(2) AFTER 120 ns;

	ent(0) <= NOT ent(0) AFTER 240 ns;
	ent(1) <= NOT ent(1) AFTER 480 ns;
	ent(2) <= NOT ent(2) AFTER 720 ns;
	ent(3) <= NOT ent(3) AFTER 960 ns;
	ent(4) <= NOT ent(4) AFTER 1200 ns;
	ent(5) <= NOT ent(5) AFTER 1440 ns;
	ent(6) <= NOT ent(6) AFTER 1680 ns;
	ent(7) <= NOT ent(7) AFTER 1920 ns;

	END PROCESS;
END test;

--  , 
-- inversor, or2, and2, or3, and3

-- entidad inversor

ENTITY inversor IS
	PORT (a : IN BIT; z : OUT BIT);
END inversor;

ARCHITECTURE logica OF inversor IS
BEGIN
z <= NOT a;
END logica;

ARCHITECTURE logica_motorola OF inversor IS
BEGIN
z <= NOT a AFTER 10 ns;
END logica_motorola;


-- entidad and2

ENTITY and2 IS	
PORT(a,b : IN BIT; z : OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
z <= a AND b;
END logica;

ARCHITECTURE logica_retard OF and2 IS
BEGIN
z <= a AND b AFTER 3 ns;
END logica_retard;


-- entidad or2

ENTITY or2 IS
	PORT (a,b : IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
z <= a OR b;
END logica;

ARCHITECTURE logica_retard OF or2 IS
BEGIN
z <= a OR b AFTER 3 ns;
END logica_retard;


-- entidad and3

ENTITY and3 IS
	PORT(a,b,c : IN BIT; z : OUT BIT);
END and3;

ARCHITECTURE logica OF and3 IS
BEGIN
z <= a AND b AND c;
END logica;

ARCHITECTURE logica_retard OF and3 IS
BEGIN
z <= a AND b AND c AFTER 3 ns;
END logica_retard;


-- entidad or3

ENTITY or3 IS
	PORT(a,b,c : IN BIT; z : OUT BIT);
END or3;

ARCHITECTURE logica OF or3 IS
BEGIN
z <= a OR b OR c;
END logica;

ARCHITECTURE logica_retard OF or3 IS
BEGIN
z <= a OR b OR c AFTER 3 ns;
END logica_retard;



-- banc de proves de and2,and3,or2,or3

ENTITY bdp_portes IS
END bdp_portes;

ARCHITECTURE vectors OF bdp_portes IS
	COMPONENT porta_inversora
		PORT (a: IN BIT; z: OUT BIT);
	END COMPONENT;
	
	COMPONENT porta_or2
		PORT (a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and2
		PORT (a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_or3
		PORT (a,b,c: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and3
		PORT (a,b,c: IN BIT; z: OUT BIT);
	END COMPONENT;

SIGNAL ent1, ent2, ent3, sortida1, sortida2, sort_and2_logica, sort_and2_logica_retard, sort_or2_logica, sort_or2_logica_retard, 
	 sort_or3_logica, sort_or3_logica_retard, sort_and3_logica, sort_and3_logica_retard : BIT;

FOR DUT: porta_inversora USE ENTITY Work.inversor(logica);

FOR DUT2: porta_inversora USE ENTITY Work.inversor(logica_motorola);


FOR DUT3 : porta_or2 USE ENTITY Work.or2(logica);

FOR DUT4 : porta_or2 USE ENTITY Work.or2(logica_retard);


FOR DUT5 : porta_and2 USE ENTITY Work.and2(logica);

FOR DUT6 : porta_and2 USE ENTITY Work.and2(logica_retard);


FOR DUT7 : porta_or3 USE ENTITY Work.or3(logica);

FOR DUT8 : porta_or3 USE ENTITY Work.or3(logica_retard);


FOR DUT9 : porta_and3 USE ENTITY Work.and3(logica);

FOR DUT10 : porta_and3 USE ENTITY Work.and3(logica_retard);


BEGIN 
DUT: porta_inversora PORT MAP (ent1,sortida1);
DUT2: porta_inversora PORT MAP (ent1,sortida2);
DUT3: porta_or2 PORT MAP (ent1,ent2,sort_or2_logica);
DUT4: porta_or2 PORT MAP (ent1,ent2,sort_or2_logica_retard);
DUT5: porta_and2 PORT MAP (ent1,ent2,sort_and2_logica);
DUT6: porta_and2 PORT MAP (ent1,ent2,sort_and2_logica_retard);
DUT7: porta_or3 PORT MAP (ent1,ent2,ent3,sort_or3_logica);
DUT8: porta_or3 PORT MAP (ent1,ent2,ent3,sort_or3_logica_retard);
DUT9: porta_and3 PORT MAP (ent1,ent2,ent3,sort_and3_logica);
DUT10: porta_and3 PORT MAP (ent1,ent2,ent3,sort_and3_logica_retard);

PROCESS
BEGIN

	ent1 <= '0';
	ent2 <= '0';
	ent3 <= '0';

	WAIT FOR 50ns;

	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '0';

	WAIT FOR 50ns;

	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;

	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '0';

	WAIT FOR 50ns;

	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;

	ent3 <= '1';
	ent2 <= '0';
	ent1 <= '1';

	WAIT FOR 50ns;

	ent3 <= '0';
	ent2 <= '1';
	ent1 <= '1';

	WAIT FOR 50ns;

	ent3 <= '1';
	ent2 <= '1';
	ent1 <= '1';
	
	WAIT FOR 50ns;

	ent3 <= '0';
	ent2 <= '0';
	ent1 <= '0';

END PROCESS;
END vectors;
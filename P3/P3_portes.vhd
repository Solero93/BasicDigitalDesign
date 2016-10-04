-- Christian José Soler, 
-- inversor, or2, and2, or3, and3, or4, and4, xor2

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


-- entidad or4

ENTITY or4 IS
	PORT(a,b,c,d : IN BIT; z : OUT BIT);
END or4;

ARCHITECTURE logica OF or4 IS
BEGIN
	z <= a OR b OR c OR d;
END logica;

ARCHITECTURE logica_retard OF or4 IS
BEGIN
	z <= a OR b OR c OR d AFTER 3 ns;
END logica_retard;


-- entidad and4

ENTITY and4 IS
	PORT(a,b,c,d : IN BIT; z : OUT BIT);
END and4;

ARCHITECTURE logica OF and4 IS
BEGIN
	z <= a AND b AND c AND d;
END logica;

ARCHITECTURE logica_retard OF and4 IS
BEGIN
	z <= (a AND b AND c AND d) AFTER 3 ns;
END logica_retard;


-- entidad xor2 con arquitectura estructural
-- a la conclusión de como hacer la XOR solo con puertas AND y OR se llega aplicando el teorema de de Morgan

ENTITY xor2 IS
	PORT(a, b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
BEGIN
	z <= a XOR b;
END logica;

ARCHITECTURE estructural OF xor2 IS
	COMPONENT porta_inversora IS 
		PORT(a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and2 IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL not_a, not_b, alpha, beta, not_alpha, not_beta, not_z: BIT;

	FOR DUT1: porta_inversora USE ENTITY WORK.inversor(logicaretard);
	FOR DUT2: porta_inversora USE ENTITY WORK.inversor(logicaretard);
	FOR DUT3: porta_and2 USE ENTITY WORK.and2(logicaretard);
	FOR DUT4: porta_and2 USE ENTITY WORK.and2(logicaretard);

	FOR DUT5: porta_inversora USE ENTITY WORK.inversor(logicaretard);		
	FOR DUT6: porta_inversora USE ENTITY WORK.inversor(logicaretard);	
	FOR DUT7: porta_and2 USE ENTITY WORK.and2(logicaretard);		
	FOR DUT8: porta_inversora USE ENTITY WORK.inversor(logicaretard);	
BEGIN
	DUT1: porta_inversora PORT MAP(a, not_a);
	DUT2: porta_inversora PORT MAP(b, not_b);
	DUT3: porta_and2 PORT MAP(not_a, b, alpha);
	DUT4: porta_and2 PORT MAP(a, not_b, beta);

	DUT5: porta_inversora PORT MAP(alpha, not_alpha);	
	DUT6: porta_inversora PORT MAP(beta, not_beta);	
	DUT7: porta_and2 PORT MAP(not_alpha, not_beta, not_z);
	DUT8: porta_inversora PORT MAP(not_z, z);
END estructural;
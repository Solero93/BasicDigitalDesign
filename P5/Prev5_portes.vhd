-- INVERSOR  -----------------------------------------
ENTITY inv IS 
	PORT(a:IN BIT; z:OUT BIT);
END inv;


ARCHITECTURE logica OF inv IS
BEGIN
	z<= NOT a;
END logica;


ARCHITECTURE logica_retard OF inv IS
BEGIN
	z<= NOT a AFTER 5ns;
END logica_retard;


-- AND2 -----------------------------------------
ENTITY and2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END and2;


ARCHITECTURE logica OF and2 IS
BEGIN
	z<= a AND b;
END logica;

ARCHITECTURE logica_retard OF and2 IS
BEGIN
	z<= a AND b  AFTER 5ns;
END logica_retard;

-- OR2 -----------------------------------------
ENTITY or2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END or2;


ARCHITECTURE logica OF or2 IS
BEGIN
	z<= a OR b;
END logica;

ARCHITECTURE logica_retard OF or2 IS
BEGIN
	z<= a OR b  AFTER 5ns;
END logica_retard;

-- NOR2 -----------------------------------------
ENTITY nor2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END nor2;

ARCHITECTURE logica OF nor2 IS
BEGIN
	z<= a NOR b;
END logica;

-- XOR2 -----------------------------------------
ENTITY xor2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END xor2;


ARCHITECTURE logica OF xor2 IS
BEGIN
	z<= (NOT a AND b) OR (a AND NOT b);
END logica;

ARCHITECTURE logica_retard OF xor2 IS
BEGIN
	z<= (NOT a AND b) OR (a AND NOT b) AFTER 5ns;
END logica_retard;

-- AND3 -----------------------------------------
ENTITY and3 IS
	PORT(a,b,c:IN BIT; z: OUT BIT);
END and3;


ARCHITECTURE logica OF and3 IS
BEGIN
	z<= a AND b AND c;
END logica;

ARCHITECTURE logica_retard OF and3 IS
BEGIN
	z<= a AND b AND c AFTER 5ns;
END logica_retard;


-- OR3 -----------------------------------------
ENTITY or3 IS
	PORT(a,b,c:IN BIT; z: OUT BIT);
END or3;


ARCHITECTURE logica OF or3 IS
BEGIN
	z<= a OR b OR c;
END logica;

ARCHITECTURE logica_retard OF or3 IS
BEGIN
	z<= a OR b OR c AFTER 5ns;
END logica_retard;


------------------------ Banc de proves de les portes -------------------------------

ENTITY banc_proves IS                           
END banc_proves;

ARCHITECTURE test OF banc_proves IS
COMPONENT inv IS
	PORT(a:IN BIT; z:OUT BIT);
END COMPONENT;

COMPONENT and2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT or2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT xor2 IS
	PORT(a,b:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and3 IS
	PORT(a,b,c:IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT or3 IS
	PORT(a,b,c:IN BIT; z: OUT BIT);
END COMPONENT;


FOR DUT1: inv USE ENTITY WORK.inv(logica);
FOR DUT2: and2 USE ENTITY WORK.and2(logica);
FOR DUT3: or2 USE ENTITY WORK.or2(logica);
FOR DUT4: xor2 USE ENTITY WORK.xor2(logica);
FOR DUT5: or3 USE ENTITY WORK.or3(logica);
FOR DUT6: and3 USE ENTITY WORK.and3(logica);

SIGNAL a,b,c, sort_inv, sort_and2, sort_or2, sort_xor2, sort_or3, sort_and3: BIT;

BEGIN

DUT1: inv PORT MAP(a,sort_inv);
DUT2: and2 PORT MAP(a,b,sort_and2);
DUT3: or2 PORT MAP(a,b,sort_or2);
DUT4: xor2 PORT MAP(a,b,sort_xor2);
DUT5: or3 PORT MAP(a,b,c,sort_or3);
DUT6: and3 PORT MAP(a,b,c,sort_and3);

PROCESS(a,b,c)
BEGIN
	a<= NOT a AFTER 50ns; 
	b<= NOT b AFTER 100ns; 
	c<= NOT c AFTER 200ns;
END PROCESS;
END test;


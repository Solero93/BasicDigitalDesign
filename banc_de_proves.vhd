ENTITY banc_de_proves IS
END banc_de_proves;

ARCHITECTURE excitacio OF banc_de_proves IS
	COMPONENT porta_inversora
		PORT (a: IN BIT; f: OUT BIT);
	END COMPONENT;

SIGNAL entrada, sortida1, sortida2 : BIT;

FOR DUT: porta_inversora USE ENTITY Work.inversor(logica);

FOR DUT2: porta_inversora USE ENTITY Work.inversor(logica_motorola);

BEGIN
DUT: porta_inversora PORT MAP (entrada,sortida1);

DUT2: porta_inversora PORT MAP (entrada,sortida2);

PROCESS
BEGIN
	entrada <= '1';
	
	WAIT FOR 20ns;

	entrada <= '0';
	
	WAIT FOR 123ns;
	
	entrada <= '1';
	
	WAIT FOR 295ns;
	
	entrada <= '0';

END PROCESS;
END excitacio;
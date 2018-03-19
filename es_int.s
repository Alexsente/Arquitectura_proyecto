* Inicializa el SP y el PC
        ORG     $0
        DC.L    $8000           *Pila
        DC.L    INICIO          *PC
        ORG     $400

	*Buffers
BUS_RBA:DS.B 10
BUS_RBB:DS.B 10
BUS_TBA:DS.B 10
BUS_TBB:DS.B 10

	*Punteros
RBA_IN_PUNT: DC.L 0
RBA_FIN_PUNT:DC.L 0
RBA_EXT_PUNT:DC.L 0
RBA_INT_PUNT:DC.L 0
RBB_IN_PUNT: DC.L 0
RBB_FIN_PUNT:DC.L 0
RBB_EXT_PUNT:DC.L 0
RBB_INT_PUNT:DC.L 0
TBA_IN_PUNT: DC.L 0
TBA_FIN_PUNT:DC.L 0
TBA_EXT_PUNT:DC.L 0
TBA_INT_PUNT:DC.L 0
TBB_IN_PUNT: DC.L 0
TBB_FIN_PUNT:DC.L 0
TBB_EXT_PUNT:DC.L 0
TBB_INT_PUNT:DC.L 0



* Definicion de equivalencias

MR1A    EQU     $effc01       * de modo A (escritura)
MR2A    EQU     $effc01       * de modo A (2 escritura)
SRA     EQU     $effc03       * de estado A (lectura)
CSRA    EQU     $effc03       * de seleccion de reloj A (escritura)
CRA     EQU     $effc05       * de control A (escritura)
TBA     EQU     $effc07       * buffer transmision A (escritura)
RBA     EQU     $effc07       * buffer recepcion A  (lectura)
TBB     EQU     $effc17       * buffer trasmisión B
RBB     EQU     $effc17       * buffer recepción B
ACR     EQU     $effc09       * de control auxiliar
IMR     EQU     $effc0B       * de mascara de interrupcion A (escritura)
ISR     EQU     $effc0B       * de estado de interrupcion A (lectura)

*INIT
INIT:
	MOVE.L #BUS_RBA,RBA_IN_PUNT
	MOVE.L #BUS_RBA,RBA_EXT_PUNT
	MOVE.L #BUS_RBA,RBA_INT_PUNT
	MOVE.L #BUS_RBA,RBA_FIN_PUNT
	ADD.L  #$8,RBA_FIN_PUNT
	MOVE.L #BUS_RBB,RBB_IN_PUNT
	MOVE.L #BUS_RBB,RBB_EXT_PUNT
	MOVE.L #BUS_RBB,RBB_INT_PUNT
	MOVE.L #BUS_RBB,RBB_FIN_PUNT
	ADD.L  #$8,RBB_FIN_PUNT
	MOVE.L #BUS_TBA,TBA_IN_PUNT
	MOVE.L #BUS_TBA,TBA_EXT_PUNT
	MOVE.L #BUS_TBA,TBA_INT_PUNT
	MOVE.L #BUS_TBA,TBA_FIN_PUNT
	ADD.L  #$7,TBA_FIN_PUNT
	MOVE.L #BUS_TBB,TBB_IN_PUNT
	MOVE.L #BUS_TBB,TBB_EXT_PUNT
	MOVE.L #BUS_TBB,TBB_INT_PUNT
	MOVE.L #BUS_TBB,TBB_FIN_PUNT
	ADD.L  #$8,TBB_FIN_PUNT
	RTS

  *********************LEECAR**********************

  LEECAR:
    BTST    #0,D0
    BEQ LINEA_A

  LINEA_B:
    CMP #$00000001,D0
    BEQ REC_B
  TRANS_B:
    MOVE.L TBB_INT_PUNT,A4
    MOVE.L TBB_EXT_PUNT,A3
    CMP  A3,A4
    BEQ VACIO
    MOVE.L TBB_FIN_PUNT,A4
    ADD.L #1,A4
    CMP A3,A4
    BEQ TBB_RESET
    MOVE.L  TBB_EXT_PUNT,A5
    MOVE.L  (A5)+,D0
    MOVE.L  A5,TBB_EXT_PUNT
    BRA FIN_LEECAR
  TBB_RESET:
    MOVE.L  TBB_EXT_PUNT,A5
    MOVE.L  A5,D0
    MOVE.L  TBA_IN_PUNT,A5
    MOVE.L  A5,TBB_EXT_PUNT
    BRA FIN_LEECAR

  REC_B:
    MOVE.L RBB_INT_PUNT,A4
    MOVE.L RBB_EXT_PUNT,A3
    CMP  A3,A4
    BEQ VACIO
    MOVE.L RBB_FIN_PUNT,A4
    ADD.L #1,A4
    CMP A3,A4
    BEQ RBB_RESET
    MOVE.L  RBB_EXT_PUNT,A5
    MOVE.L  (A5)+,D0
    MOVE.L  A5,RBB_EXT_PUNT
    BRA FIN_LEECAR
  RBB_RESET:
    MOVE.L  RBB_EXT_PUNT,A5
    MOVE.L  A5,D0
    MOVE.L  RBB_IN_PUNT,A5
    MOVE.L  A5,RBB_EXT_PUNT
    BRA FIN_LEECAR

  LINEA_A:
    CMP #$00000000,D0
    BEQ TRANS_A

  TRANS_A:
    MOVE.L TBA_INT_PUNT,A4
    MOVE.L TBA_EXT_PUNT,A3
    CMP  A3,A4
    BEQ VACIO
    MOVE.L TBA_FIN_PUNT,A4
    ADD.L #1,A4
    CMP A3,A4
    BEQ TBA_RESET
    MOVE.L  TBA_EXT_PUNT,A5
    MOVE.B  (A5)+,D0
    MOVE.L  A5,TBA_EXT_PUNT
    BRA FIN_LEECAR
  TBA_RESET:
    MOVE.L  TBA_EXT_PUNT,A5
    MOVE.L  A5,D0
    MOVE.L  TBA_IN_PUNT,A5
    MOVE.L  A5,TBA_EXT_PUNT
    BRA FIN_LEECAR

  REC_A:
  *  MOVE.L RBA_INT_PUNT,A4
    MOVE.L TBA_EXT_PUNT,A3
    *CMP  A3,A4
    *BEQ VACIO
    MOVE.L TBA_FIN_PUNT,A4
    ADD.L #4,A4
    CMP A3,A4
    BEQ TBA_RESET
    MOVE.L  TBA_EXT_PUNT,A5
    MOVE.L  (A5)+,D0
    MOVE.L  A5,TBA_EXT_PUNT
    BRA FIN_LEECAR
  RBA_RESET:
    MOVE.L  TBA_EXT_PUNT,A5
    MOVE.L  (A5),D0
    MOVE.L  TBA_IN_PUNT,A5
    MOVE.L  A5,TBA_EXT_PUNT
    BRA FIN_LEECAR


  VACIO:
    MOVE.L #$ffffffff,D0
  FIN_LEECAR:RTS

********************ESCCAR********************
ESCCAR:

	         BTST #0,D0
	         BEQ ELINEA_A

ELINEA_A:

           BTST   #1,D0
	        * BEQ EREC_A

ETRANS_A:
    MOVE.L TBA_INT_PUNT,A5 *Se mete el puntero I en A5
    MOVE.L TBA_FIN_PUNT,A4 *Se mete el puntero FIn en A4
    MOVE.L TBA_EXT_PUNT,A3 *Se mete el puntero de E al A3
    MOVE.L  TBA_IN_PUNT,A2 *Se mete el puntero de Principio al A2
    ADD.L #1,A4   *Se le añade 1 al puntero de fin
    CMP.L A4,A5   *Se comparan los punteros I y F+1
    SUB.L #1,A4   *Se restablece el valor del puntero FIn
    BEQ  AUX      *Está en la posicion auxiliar
    CMPA.L A4,A5  *Se comprueba si F e I estan en la misma posicion
    BEQ    I_FIN  *Si I y Fin son iguales salta a la etiqueta de fin

I_NO_FIN:
    SUB.L #1,A3  *Se le resta a E una unidad
    CMP.L A5,A3  *Se mira si son iguales I y E-1
    ADD.L #1,A3  *Se restablece el valor de E
    BEQ  LLENO   *Si son iguales esta lleno

CONTINUA:
    ADD.L #1,A4 *Se le añade 1 al puntero de fin
    CMP.L A4,A5 *Se comparan los punteros I y F+1
    SUB.L #1,A4 *Se restablece el valor del puntero FIn
    BEQ  AUX    *Está en la posicion auxiliar

NO_AUX:
  MOVE.B  D1,(A5)+           *Push del registro D1 en el buffer
  MOVE.L  A5,TBA_INT_PUNT           *Guarda la nueva direcion del puntero
  RTS

AUX:
    CMP.L A3,A2  *Se comprueba si E y P estan en la misma posicion
    BEQ LLENO
    MOVE.B  D1,(A5)   *Push del registro D1 en el buffer
    MOVE.L  TBA_IN_PUNT,TBA_INT_PUNT  *Se Inicializa I con el valor de Principio
    RTS

NO_LLENO:
    MOVE.B  D1,(A5)+           *Push del registro D1 en el buffer
    MOVE.L  A5,TBA_INT_PUNT           *Guarda la nueva direcion del puntero
    RTS

I_FIN:
    MOVE.B  D1,(A5)+           *Push del registro D1 en el buffer
    MOVE.L  A5,TBA_INT_PUNT           *Guarda la nueva direcion del puntero
    RTS

LLENO:
    MOVE.L #$ffffffff,D0
    RTS

*PRINT
PRINT:RTS
*LINEA
LINEA:RTS
*SCAN
SCAN:RTS
*RTI
RTI:RTS


*Pruebas
PRUEBA:
  MOVE.L RBA_FIN_PUNT,A4
  *MOVE.L RBB_IN_PUNT,A4
  RTS

*Programa Principal
INICIO: BSR INIT
	MOVE.L #$00000000,D0
  MOVE.L #000000000,D1
  BSR ESCCAR
  MOVE.L #$00000001,D1
  BSR ESCCAR
    MOVE.L #$00000002,D1
  BSR ESCCAR
    MOVE.L #$00000003,D1
  BSR ESCCAR
    MOVE.L #$00000004,D1
  BSR ESCCAR
    MOVE.L #$00000005,D1
  BSR ESCCAR
    MOVE.L #$00000006,D1
  BSR ESCCAR
    MOVE.L #$00000007,D1
  BSR ESCCAR
  BSR ESCCAR
  MOVE.L #$00000000,D0
  BSR LEECAR
    MOVE.L #$00000009,D1
  BSR ESCCAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
    BSR LEECAR
  BREAK

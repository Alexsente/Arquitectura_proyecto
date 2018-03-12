* Inicializa el SP y el PC
        ORG     $0
        DC.L    $8000           * Pila
       
        DC.L    INICIO          * PC

        ORG     $400

* Definicion de equivalencias

MR1A    EQU     $effc01       * de modo A (escritura)
MR2A    EQU     $effc01       * de modo A (2 escritura)
SRA     EQU     $effc03       * de estado A (lectura)
CSRA    EQU     $effc03       * de seleccion de reloj A (escritura)
CRA     EQU     $effc05       * de control A (escritura)
TBA     EQU     $effc07       * buffer transmision A (escritura)
RBA     EQU     $effc07       * buffer recepcion A  (lectura)
ACR     EQU     $effc09       * de control auxiliar
IMR     EQU     $effc0B       * de mascara de interrupcion A (escritura)
ISR     EQU     $effc0B       * de estado de interrupcion A (lectura)

*LEECAR
LEECAR:
BTST #0, D0
BEQ LINEA_A

LINEA_B:BTST #1, D0
BEQ REC_B

TRANS_B:
REC_B:

LINEA_A:BTST #1, D0
BEQ REC_A

TRANS_A:
REC_A:
RTS
*Programa Principal
INICIO:
MOVE.L  #$5000, -(A7) *Dirección de buffer
BSR LEECAR
BREAK

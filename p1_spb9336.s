/******************************************************************************
*
* @author Saurya Bhattarai
******************************************************************************/
 
.global main
.func main
   
main:
    BL  _prompt             @ branch to prompt procedure with return
    BL  _scanf              @ branch to scanf procedure with return
    MOV R1, R0
    BL  _getchar
    MOV R5, R0
    BL  _scanf
    MOV R2, R0              @ move return value R0 to argument register R1
    BL  _compare
    BL  _printf             @ branch to print procedure with return
    B   _exit               @ branch to exit procedure with no return

_exit:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R3, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_getchar:
    MOV R7, #3
    MOV R0, #1
    MOV R3, #1
    LDR R5, =read_char
    SWI 0
    LDR R0, [R5]
    MOV PC, LR

_compare:
    CMP R5, #'+'
    BEQ _add
    BNE _compareS

_compareS:
    CMP R5, #'-'
    BEQ _sub
    BNE _comparemul

_comparemul:
    CMP R5, #'*'
    BEQ _mul
    BNE _compareM

_compareM:
    CMP R5, #'M'
    BEQ _max

_add:
    MOV R4, LR
    ADD R0, R1, R2
    MOV PC, R4
_sub:
    MOV R4, LR
    SUB R0, R1, R2
    MOV PC, R4
_mul:
    MOV R4, LR
    MUL R0, R1, R2
    MOV PC, R4
_max:
    MOV R4, LR
    CMP R1, R2
    MOVGT R2, R1
    MOV PC, R4

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R3, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R8, R8              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return

_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

.data
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a number, operator and another number: "
printf_str:     .asciz      "The answer is: %d\n"
exit_str:       .ascii      "Terminating program.\n"
read_char:      .ascii      " "

/******************************************************************************
* @file factorial.s
* @brief simple recursion example
*
* Simple example of recursion and stack management
*
* @author Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
    BL  _scanf              @ branch to scan procedure with return
    MOV R4, R0              @ store n in R4
    MOV R1, R4              @ pass n to factorial procedure

    BL _scanf
    MOV R5, R0
    MOV R2, R5

    PUSH {R1}
    PUSH {R2}
    BL  _count_partitions   @ branch to factorial procedure with return
    POP {R2}
    POP {R1}

    MOV R3, R2             @ pass n to printf procedure
    MOV R2, R1              @ pass result to printf procedure
    MOV R1, R0

    BL  _printf             @ branch to print procedure with return
   
    @ B   _exit               @ branch to exit procedure with no return

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str      @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return

_count_partitions:
   
    PUSH {LR}               @ store the return address

    CMP R1, #0              @ compare the input argument to 1
    MOVEQ R0, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
    MOVLT R0, #0
    POPLT {PC}
   
    CMP R2, #0
    MOVEQ R0, #0
    POPEQ {PC}
   
    PUSH {R2}
    SUB R2, R2, #1          @ decrement the input argument
    BL _count_partitions    @ compute _count_partitions(n-m,m)
    POP {R2}
    
    PUSH {R0}
    
    PUSH {R1}
    SUB R1, R1, R2
    BL _count_partitions
    POP {R1}
    
    POP {R3}
    
    ADD R0,R0,R3
 
    @POP {R1}                 @ restore input argument
    @ADD R0, R0, R7          @ compute fact(n-1)*n
    POP {PC}               @ restore the stack pointer and return

_exit:
   MOV R7, #4
   MOV R0, #1
   MOV R2, #21
   LDR R1, =exit_str
   SWI 0
   MOV R7, #1
   SWI 0
 
.data
number:         .word       0
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d"
exit_str:       .ascii      "Terminating program.\n"

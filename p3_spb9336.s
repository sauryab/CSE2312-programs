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
    MOV R4, R0
    MOV R1, R4              @ store n in R1


    BL _scanf
    MOV R5, R0
    MOV R2, R5              @store m in R2


    PUSH {R1}
    PUSH {R2}

    BL  _count_partitions   @ branch to factorial procedure with return
    POP {R2}
    POP {R1}

    MOV R3, R2              @ pass m to printf procedure
    MOV R2, R1              @ pass n to printf procedure
    MOV R1, R0              @ pass result to printf procedure


    BL  _printf             @ branch to print procedure with return

    B main                  @ branch to main procedure

_count_partitions:
   
    PUSH {LR}               @ store the return address

    CMP R1, #0              @ compare the n to 0
    MOVEQ R0, #1            @ set return value to 1 if equal
    POPEQ {PC}              @ restore stack pointer and return if equal
    MOVLT R0, #0            @set return value to 0 is less then
    POPLT {PC}
   
    CMP R2, #0             @compare m to 0
    MOVEQ R0, #0           @set return value to 0 is equal
    POPEQ {PC}
   
    PUSH {R2}               @preserve value of m
    SUB R2, R2, #1          @ m= m-1
    BL _count_partitions    @ compute _count_partitions(n,m-1)
    POP {R2}
    
    PUSH {R1}
    PUSH {R0}

    SUB R1, R1, R2          @ n=n-m
    BL _count_partitions    @compute _count_partitions(n-m,m)
    POP {R3}
    
    ADD R0,R0,R3
 
    POP {R1}               @ restore input argument
    POP {PC}               @ restore the stack pointer and return

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

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str      @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_exit:
   MOV R7, #4
   MOV R0, #1
   MOV R2, #21
   LDR R1, =exit_str
   SWI 0
   MOV R7, #1
   SWI 0


 
.data

format_str:     .asciz      "%d"
format_str1:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d"
exit_str:       .ascii      "Terminating program.\n"

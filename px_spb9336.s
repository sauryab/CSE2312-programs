/******************************************************************************
* @px_spb9336
* @Final Lab
* @author Saurya Bhattarai
**************************************************************************/
 
.global main
.func main
   
main:
    MOV R0, #0              @ initialze index variable

writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done

    LDR R1, =array_a        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}
    PUSH {R1}
    PUSH {R2}
    BL _scanf
    MOV R7, R0
    POP {R2}
    POP {R1}
    POP {R0}
    STR R7, [R2]            @ write the address of a[i] to a[i]

    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration

writedone:
    MOV R0, #0              @ initialze index variable

readloop:
    PUSH {LR}
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration

readdone:
    BL _prompt
    BL _scanf
    MOV R4, R0
    MOV R0, #0
    MOV R3, #0

_search:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ  donesearch            @ exit loop if done

    LDR R1, =array_a        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    PUSH {R4}
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    CMP R4, R2
    BLEQ _found
    POP {R4}
    POP {R2}
    POP {R1}
    POP {R0}

    ADD R0, R0, #1
    B _search

_found:
    PUSH {LR}
    PUSH {R3}
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {R3}
    ADD R3, R3, #1
    POP {PC}

donesearch:
   CMP R3, #0
   BEQ _notfound
   BNE _exit

_notfound:
    MOV R7, #4
    MOV R0, #1
    MOV R2, #40
    LDR R1, =notfound_str
    SWI 0
    B _exit


_scanf:
    PUSH {LR}
    PUSH {R1}
    LDR R0, =format_str
    SUB SP, SP, #4
    MOV R1, SP
    BL scanf
    LDR R0, [SP]
    ADD SP, SP, #4
    POP {R1}
    POP {PC}


_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return


_prompt:
    PUSH {LR}
    MOV R7, #4
    MOV R0, #1
    MOV R2, #22
    LDR R1, =prompt_str
    SWI 0
    POP {PC}


_exit:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

.data

.balign 4
array_a:        .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
prompt_str:     .asciz      "ENTER A SEARCH VALUE: "
format_str:     .asciz      "%d"
notfound_str:   .asciz      "That value does not exist in the array!\n"
exit_str:       .ascii      "Terminating program.\n"

global _start
extern printf, scanf

section .bss
    userInput resb 1

section .data
    message db "Please input max Fn", 0x0a
    outFormat db "%d", 0x0a, 0x00
    inFormat db "%d", 0x00

section .text
_start:                 ; defines the start funtion
    call printMessage   ; print intro message
    call getInput       ; get max number from user
    call initFib        ; set initial Fibonacci values
    call loopFib        ; calculate Fib numbers
    call Exit           ; exit the program

printMessage:
    mov rax, 1          ; moves "1" into rax denoting the "write" syscall
    mov rdi, 1          ; sets 1st argument of syscall to 1 instructing printing using stdout
    mov rsi,message     ; pointer to the message labeled in the data section
    mov rdx, 20         ; instructs the length of message to be printed
    syscall             ; call the write syscall set above to display the intro message
    ret

getInput:
    sub rsp, 8         ; stack alignment
    mov rdi, inFormat  ; set 1st parameter (inFormat)
    mov rsi, userInput ; set 2nd parameter (userInput)
    call scanf         ; scanf(inFormat, userInput)
    add rsp, 8         ; stack alignment
    ret

initFib:
    xor rax, rax        ; initialize rax to 0
    xor rbx, rbx        ; initialize rbx to 0
    inc rbx             ; increment rbx by 1
    ret

printFib:
    push rax            ; push rax to stack
    push rbx            ; push rbx to stack
    mov rdi, outFormat  ; set 1st argument (Print Format type)
    mov rsi, rbx        ; set 2nd argument (Fib number)
    call printf         ; printf(outFormat, rbx)
    pop rbx             ; retrieve rbx from stack
    pop rax             ; retrieve rax from stack
    ret

loopFib:                ; defines the loopFib funtion
    call printFib       ; prints current Fib number
    add rax, rbx        ; get the next number
    xchg rax, rbx       ; swap rax and rbx registers
    cmp rbx, [userInput]; do rbx - userInput
    js loopFib          ; jump to loopFib if result is <0
    ret

Exit:
    mov rax, 60         ; moves "60" into rax denoting the "exit" syscall
    mov rdi, 0          ; sets rdi to 0 denoting an exit code argument of 0 - normal  
    syscall             ; calls the exit syscall set above to exit the program normally

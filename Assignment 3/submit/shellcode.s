.text
.globl main
main:
        xor     %eax,%eax
        push    %eax
        push    $0x7433336C
        push    $0x2F6E6962
        push    $0x2F6C6163
        push    $0x6F6C2F72
        push    $0x73752F2F
        movl    %esp,%ebx
        push    %eax
        push    %ebx
        mov     %esp,%ecx
        movl    %eax,%edx
        mov     $11,%al
        int     $0x80
        xor     %eax,%eax
        mov     $1,%al
        xor     %ebx,%ebx
        int     $0x80
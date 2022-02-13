	org 0
	bits 16

_start:				; Start BIOS Parameter Block
	jmp short start
	nop

	times 33 db 0x0	; Fake parameters

start:
	jmp 0x7c0:step2
step2:
	cli				; Clear Interrupts
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	mov ax, 0x0
	mov ss, ax
	mov sp, 0x7c00
	sti				; Enable Interrupts

	mov si, message
	call print
	jmp $
print:
	mov bx, 0x0
.loop:
	lodsb
	cmp al, 0x0
	je .done
	call print_char
	jmp .loop
.done:
	ret
print_char:
	mov ah, 0eh
	int 0x10
	ret

message: db "Hello, world!", 0x01, 0x00

times 510-($ - $$) db 0
dw 0xAA55
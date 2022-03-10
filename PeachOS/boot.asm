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

	mov ah, 0x2		; Read Sector Command
	mov al, 0x1 	; One Sector to Read
	mov ch, 0x0		; Cylinder low eight bits
	mov cl, 0x2		; Read sector two
	mov dh, 0		; Head number
	mov bx, buffer
	int 0x13
	jc error

	mov si, buffer
	call print

	jmp $

error:
	mov si, error_message
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

error_message: db 'Failed to load sector', 0x0

times 510-($ - $$) db 0
dw 0xAA55

buffer:
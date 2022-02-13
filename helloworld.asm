	org 0x7c00
	bits 16
print:
	mov bx, message
repeat:
	mov al, [bx]
	push bx
	mov bx, 0x0002
	call print_char
	pop bx
	cmp al, 0x0
	je end
	inc bx
	jmp repeat

print_char:
	mov ah, 0eh
	int 0x10
	ret
end:
	jmp end

message:
	db "Hello, world!", 0x01, 0x00

times 510-($ - $$) db 0
dw 0xAA55
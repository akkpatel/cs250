.data
	sourceString: .ascii "There are no secrets better kept than the secrets that everybody guesses.\n"
	len = .-sourceString
	next: .ascii "\n"
	nextlen = .-next
	.comm regulartext,len
	.comm ciphertext,len
	.comm decrypted,len
	.comm new,nextlen
	
.global main

main:
	mov $sourceString,%esi
	mov $regulartext,%edi
	mov $len,%ecx
	rep movsb

	mov $len,%edx
	mov $regulartext,%ecx
	mov $1,%ebx
	mov $4,%eax
	int $0x80

	mov $0,%ebx
	mov $len,%ecx

loop1:
	cmp %ecx, %ebx
	jge out1
	nop
	
	mov $sourceString, %edx
	add %ebx, %edx
	mov (%edx), %dl
	mov $ciphertext, %edi
	add %ebx, %edi
	xor $0xC4, %dl
	mov %dl, (%edi)
	incl %ebx
	jmp loop1
	nop

out1:
	mov $len, %edx
	mov $ciphertext, %ecx
	mov $1,%ebx
	mov $4,%eax
	int $0x80
	
	mov $next,%esi
	mov $new,%edi
	mov $len,%ecx
	rep movsb
	
	mov $nextlen, %edx
	mov $new, %ecx
	mov $1, %ebx
	mov $4, %eax
	int $0x80
	
	mov $0, %ebx
	mov $len, %ecx
	
loop2:
	cmp %ecx, %ebx
	jge out2
	nop
	
	mov $ciphertext, %edx
	add %ebx, %edx
	mov (%edx), %dl
	mov $decrypted, %edi
	add %ebx, %edi
	xor $0xC4, %dl
	mov %dl, (%edi)
	incl %ebx
	jmp loop2
	nop

out2:
	mov $sourceString,%esi
	mov $decrypted,%edi
	mov $len,%ecx
	rep movsb

	mov $len, %edx
	mov $decrypted, %ecx
	mov $1, %ebx
	mov $4, %eax
	int $0x80

	mov $0,%ebx
	mov $1,%eax
	int $0x80
	
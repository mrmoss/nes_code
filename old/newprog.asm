memory:
	.bank 0
		.org $0000
		.inesprg 1
		.inesmap 0
		.inesmir 1
		.ineschr 1

	.bank 1
		.org $FFFA
		.dw 0
		.dw setup
		.dw 0

	.bank 2
		.org $0000

	.bank 0
		.org $0000

		.org $8000

		setup:
			set_display:
				lda #%00001000
				sta $2000
				lda #%00011110
				sta $2001
		loop:
			v_sync:
				lda $2002
				bpl v_sync
				jmp loop
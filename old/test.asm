;%		= binary
;$		= hex
;none	= dec

;header table
	.inesprg 1
	.ineschr 1
	.inesmir 1
	.inesmap 0

;program memory
	.bank 0
	.org $0000
	player_x:	.db		100
	player_y:	.db		100

;program code
	.org $8000

	;section .data
	palette_data:
		.incbin "our.pal"

	;section .text
		start:
			;Setup the PPUCTRL (Picture Processing Unit Control)
			;	7654 3210
			;	|||| ||||
			;	|||| |||+- 1: Add 256 to the X scroll position
			;	|||| ||+-- 1: Add 240 to the Y scroll position
			;	|||| |+--- VRAM address increment per CPU read/write of PPUDATA
			;	|||| |     (0: add 1, going across; 1: add 32, going down)
			;	|||| +---- Sprite pattern table address for 8x8 sprites
			;	||||       (0: $0000; 1: $1000; ignored in 8x16 mode)
			;	|||+------ Background pattern table address (0: $0000; 1: $1000)
			;	||+------- Sprite size (0: 8x8; 1: 8x16)
			;	|+-------- PPU master/slave select
			;	|          (0: read backdrop from EXT pins; 1: output color on EXT pins)
			;	+--------- Generate an NMI at the start of the
			;	           vertical blanking interval (0: off; 1: on)
			lda #%00001000
			sta $2000

			;Setup PPUMASK (Picture Proccessing Unit Mask)
			;	76543210
			;	||||||||
			;	|||||||+- Grayscale (0: normal color; 1: produce a monochrome display)
			;	||||||+-- 1: Show background in leftmost 8 pixels of screen; 0: Hide
			;	|||||+--- 1: Show sprites in leftmost 8 pixels of screen; 0: Hide
			;	||||+---- 1: Show background
			;	|||+----- 1: Show sprites
			;	||+------ Intensify reds (and darken other colors)
			;	|+------- Intensify greens (and darken other colors)
			;	+-------- Intensify blues (and darken other colors)
			lda #%00011110
			sta $2001

			;Go to the start of the PPU palette
			lda #$3F
			sta $2006
			lda #$00
			sta $2006

			;Load Color Palette
			ldx #0

			load_palette:
				lda palette_data,x
				sta $2007
				inx
				cpx #32
				bne load_palette

			loop:
				lda $2002  ; these 3 lines wait for VBlank, this loop will actually miss VBlank
				bpl waitblank

				;Y position
				ldy #50
				sty $2004

				;index
				lda #$01
				sta $2004

				;flags
				lda #$00
				sta $2004

				;X position
				ldx player_x
				stx $2004

				;reset controller
				lda #$01
				sta $4016
				lda #$00
				sta $4016

				jmp loop

;vector table
	.bank 1
	.org $FFFA
	.dw 0
	.dw start	;(Reset_Routine)
	.dw 0

;resource table
	.bank 2
	.org $0000
	.incbin "our.bkg"
	.incbin "our.spr"
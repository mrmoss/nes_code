memory:
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
		backgrounds:		.incbin		"game.bkg"
		sprites:			.incbin		"game.spr"

	.bank 0
		.org $0000
		;enter values for these memory locations do not work?!
		player_y:			.db			0
		player_index:		.db			0
		player_flags:		.db			0
		player_x:			.db			0

		.org $8000
		palette_data:		.incbin		"game.pal"

		setup:
			default_player_settings:
				lda #120
				sta player_y
				lda #1
				sta player_index
				lda #2
				sta player_flags
				lda #128
				sta player_x

			set_display:
				lda #%00001000
				sta $2000
				lda #%00011110
				sta $2001

			reset_palette:
				lda #$3F
				sta $2006
				lda #$00
				sta $2006
				ldx #0

			load_palette:
				lda palette_data,x
				sta $2007
				inx
				cpx #32
				bne load_palette

		loop:
			v_sync:
				lda $2002
				bpl v_sync

			player_draw:
				lda player_y
				sta $2004
				lda player_index
				sta $2004
				lda player_flags
				sta $2004
				lda player_x
				sta $2004

			reset_gamepad:
				lda #$01
				sta $4016
				lda #$00
				sta $4016

			check_gamepad:
				lda $4016
					and #1
					bne pressed_a
				lda $4016
					and #1
					bne pressed_b
				lda $4016
					and #1
					bne pressed_select
				lda $4016
					and #1
					bne pressed_start
				lda $4016
					and #1
					bne pressed_up
				lda $4016
					and #1
					bne pressed_down
				lda $4016
					and #1
					bne pressed_left
				lda $4016
					and #1
					bne pressed_right
				jmp pressed_none

			pressed_a:
				jmp pressed_none
			pressed_b:
				jmp pressed_none
			pressed_select:
				jmp pressed_none
			pressed_start:
				jmp pressed_none
			pressed_up:
				dec player_y
				jmp pressed_none
			pressed_down:
				inc player_y
				jmp pressed_none
			pressed_left:
				dec player_x
				jmp pressed_none
			pressed_right:
				inc player_x
			pressed_none:
				jmp loop
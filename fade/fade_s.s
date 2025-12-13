**************************************************************************************
*	FADE_S.S
*
*	interrupt based fade rout
*
*	[c] 2001 Reservoir Gods
**************************************************************************************

**************************************************************************************
;	EXPORTS / IMPORTS
**************************************************************************************

	XDEF	Fade_Vbl

	XREF	gFadeVblLockFlag
	XREF	gFadeVblActiveFlag

	XREF	Fade_PalSTE
	XREF	Video_SetNextPalST

	XREF	gFade


**************************************************************************************
;	STRUCTS
**************************************************************************************

	rsreset

sFade_mGamma:           rs.w    1
sFade_mVblAdd:          rs.l    1
sFade_mVblScale:        rs.l    1
sFade_mpVblTmpPal:      rs.l    1
sFade_mpVblOldPal:      rs.l    1
sFade_mpVblTargetPal:   rs.l    1
sFade_mVblOldPal:       rs.w    16
sFade_mVblTmpPal:       rs.w    16
sFade_mCurrentBasePal:  rs.w    16
sFade_sizeof:           rs.w    1


**************************************************************************************
	TEXT
**************************************************************************************

*------------------------------------------------------------------------------------*
* FUNCTION : Fade_Vbl
* ACTION   : does a vbl based fade
* CREATION : 11.04.01 PNK
*------------------------------------------------------------------------------------*

Fade_Vbl:

	tst.b	gFadeVblActiveFlag
	beq.s	.nofade

	tas		gFadeVblLockFlag
	bne		.nofade

	movem.l	d0-a6,-(a7)

	move.l	gFade+sFade_mVblAdd,d0
	add.l	d0,gFade+sFade_mVblScale

	move.w	gFade+sFade_mVblScale,d1
	cmp.w	#$100,d1
	blt.s	.less
	move.w	#$100,d1
	clr.b	gFadeVblActiveFlag
.less:

	move.l	gFade+sFade_mpVblTmpPal,a0
	move.l	gFade+sFade_mpVblOldPal,a1
	moveq	#16,d0
	move.l	gFade+sFade_mpVblTargetPal,-(a7)
	jsr		Fade_PalSTE
	addq.l	#4,a7

	move.l	gFade+sFade_mpVblTmpPal,a0
	jsr		Video_SetNextPalST

	movem.l	(a7)+,d0-a6
	clr.b	gFadeVblLockFlag

.nofade:
	rts


**************************************************************************************

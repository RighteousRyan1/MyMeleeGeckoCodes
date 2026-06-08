static s32 r4; // the sfx id shift

void pitch_asm() {
	int r3 = 0;
	// lis r8, 0x8046
	// ori r8, 0xB6A0
	void* match_info = (void*)0x8046B6A0;
	
	// lhz r8, 0x2C(match_info)
	s16 mtimer = (s16)(match_info + 0x2C);
	
	// 50% regular sound, 25% high pitch, 25% low
	mtimer &= 3;
	// 00001000
	// 00000111
	
	// cmpwi mtimer, 1
	if (mtimer == 1) {
		r3 = r4 + 2;
	}
	// cmpwi mtimer, 2
	if (mtimer == 2) {
		r3 = r4 + 1;
	}
	
	// blr
	return;
}

void lr() {
	// melee code yadda yadda
	pitch_asm();
}

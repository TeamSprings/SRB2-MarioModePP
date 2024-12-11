--[[
		Pipe Kingdom Zone's Colors - info_colors.lua

Description:
Animated colors for all things

Contributors: Skydusk
@Team Blue Spring 2024
]]

-- Extra Colors





-- Utility Skin Colors

-- Skin Colors used for blocks

skincolors[SKINCOLOR_BROWNEMPTYBLOCK] = {
	ramp = {223,226,227,228,229,229,230,233,234,236,237,238,239,239,31,31},
	accessible = false
}

skincolors[SKINCOLOR_CYANEMPTYBLOCK] = {
	ramp = {136, 137, 137, 137, 137, 138, 138, 175, 175, 169, 187, 199, 47, 47, 30, 30, },
	accessible = false
}

skincolors[SKINCOLOR_GREENEMPTYBLOCK] = {
	ramp = {190, 191, 191, 191, 191, 105, 105, 106, 106, 108, 109, 109, 109, 109, 110, 111, },
	accessible = false
}

skincolors[SKINCOLOR_GRAYEMPTYBLOCK] = {
	ramp = {15, 18, 18, 18, 20, 24, 24, 169, 169, 139, 30, 30, 30, 30, 30, 111, },
	accessible = false
}

skincolors[SKINCOLOR_BEIGEEMPTYBLOCK] = {
	ramp = {86, 87, 243, 244, 245, 246, 246, 248, 248, 249, 250, 238, 239, 239, 239, 111, },
	accessible = false
}

skincolors[SKINCOLOR_BROWNBRICK] = {
	ramp = {80,80,82,82,64,64,64,66,67,69,69,70,70,46,46,47},
	accessible = false
}

skincolors[SKINCOLOR_CYANBRICK] = {
	ramp = {1, 1, 1, 1, 1, 128, 128, 128, 131, 134, 135, 136, 137, 138, 139, 139, },
	accessible = false
}

skincolors[SKINCOLOR_GREENBRICK] = {
	ramp = {81, 82, 83, 72, 73, 188, 189, 190, 191, 105, 106, 127, 108, 109, 110, 111, },
	accessible = false
}

skincolors[SKINCOLOR_GRAYBRICK] = {
	ramp = {3, 5, 7, 8, 10, 12, 14, 16, 20, 23, 24, 25, 26, 175, 175, 139, },
	accessible = false
}

skincolors[SKINCOLOR_BEIGEBRICK] = {
	ramp = {217, 218, 219, 220, 221, 222, 223, 224, 228, 230, 248, 250, 251, 25, 27, 28, },
	accessible = false
}

-- Animated Skin Colors for blocks

skincolors[SKINCOLOR_GOLDENBLOCK] = {
	ramp = {80,82,64,64,64,65,66,67,68,70,71,71,46,46,47,47},
	accessible = false
}

local GOLDENBLOCK_RAMP = {
	{80,82,64,64,64,65,66,67,68,70,71,71,46,46,47,47},
	{80,82,85,85,85,65,66,67,68,70,71,71,46,46,47,47},
	{80,81,84,84,84,65,66,67,68,70,71,71,46,46,47,47},
	{80,81,72,72,72,64,66,67,68,70,71,71,46,46,47,47},
	{80,80,82,82,82,64,65,67,68,70,71,71,46,46,47,47},
	{80,80,81,81,81,84,65,66,67,70,71,71,46,46,47,47},
	{0,0,80,80,80,83,84,65,67,70,71,71,46,46,47,47},
	{0,0,1,1,1,81,82,64,66,69,71,71,46,46,47,47},
}

skincolors[SKINCOLOR_CYANBLOCK] = {
	ramp = {132, 134, 136, 136, 136, 136, 136, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	accessible = false
}

local CYANBLOCK_RAMP = {
	{132, 134, 136, 136, 136, 136, 136, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{131, 133, 136, 136, 136, 136, 136, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{131, 133, 142, 142, 142, 142, 142, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{130, 132, 142, 142, 142, 142, 142, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{130, 132, 135, 135, 135, 135, 135, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{129, 131, 135, 135, 135, 135, 135, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{129, 131, 134, 134, 134, 134, 134, 137, 137, 138, 139, 139, 139, 139, 139, 139, },
	{128, 130, 133, 133, 133, 133, 133, 136, 136, 137, 139, 139, 139, 139, 139, 139, },
	{1, 129, 132, 132, 132, 132, 132, 135, 135, 136, 138, 138, 138, 138, 138, 138, },
}

skincolors[SKINCOLOR_BEIGEBLOCK] = {
	ramp = {84, 85, 240, 240, 240, 240, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	accessible = false
}

local BEIGEBLOCK_RAMP = {
	{84, 85, 240, 240, 240, 240, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{83, 84, 86, 86, 86, 86, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{82, 84, 240, 240, 240, 240, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{81, 83, 240, 240, 240, 240, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{81, 82, 85, 85, 85, 85, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{80, 81, 85, 85, 85, 85, 242, 243, 245, 246, 251, 251, 238, 238, 239, 239, },
	{80, 82, 84, 84, 84, 84, 241, 242, 245, 246, 251, 251, 238, 238, 239, 239, },
	{81, 82, 82, 82, 82, 240, 241, 245, 246, 251, 251, 238, 238, 239, 239, 239, },
	{240, 241, 245, 246, 251, 251, 238, 238, 239, 239,  239, 239, 239, 239, 239, 239, },
}

skincolors[SKINCOLOR_GREENBLOCK] = {
	ramp = {72, 188, 190, 190, 190, 190, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	accessible = false
}

local GREENBLOCK_RAMP = {
	{72, 188, 190, 190, 190, 190, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{72, 74, 190, 190, 190, 190, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{83, 74, 189, 189, 189, 189, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{81, 73, 189, 189, 189, 189, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{81, 73, 189, 189, 189, 189, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{80, 72, 189, 189, 189, 189, 103, 105, 105, 107, 110, 110, 111, 111, 111, 111, },
	{80, 72, 188, 188, 188, 188, 102, 104, 104, 107, 110, 110, 111, 111, 111, 111, },
	{82, 73, 73, 73, 73, 188, 190, 190, 107, 110, 110, 111, 111, 111, 111, 111, },
	{72, 72, 72, 72, 74, 189, 189, 106, 109, 109, 111, 111, 111, 111, 111, 111, },
}

skincolors[SKINCOLOR_GRAYBLOCK] = {
	ramp = {13, 18, 21, 21, 21, 23, 23, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	accessible = false
}

local GRAYBLOCK_RAMP = {
	{13, 18, 21, 21, 21, 23, 23, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{12, 17, 20, 20, 20, 23, 23, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{12, 17, 19, 19, 19, 22, 22, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{11, 16, 18, 18, 18, 21, 21, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{11, 16, 18, 18, 18, 21, 21, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{9, 14, 18, 18, 18, 21, 21, 174, 174, 169, 30, 30, 31, 31, 31, 31, },
	{9, 15, 17, 17, 17, 19, 19, 173, 173, 169, 30, 30, 31, 31, 31, 31, },
	{7, 13, 15, 15, 15, 17, 17, 172, 172, 168, 28, 28, 31, 31, 31, 31, },
	{4, 9, 12, 12, 12, 14, 14, 172, 172, 168, 28, 28, 31, 31, 31, 31, },
}

skincolors[SKINCOLOR_AURORAROLLBLOCK] = {
	ramp = {0, 1, 120, 88, 80, 88, 188, 96, 98, 101, 104, 107, 109, 109, 109, 109, },
	accessible = false
}

local AURORAROLLBLOCK_RAMP = {
	{0, 1, 120, 88, 80, 88, 188, 96, 98, 101, 104, 107, 109, 109, 109, 109, },
	{0, 1, 128, 88, 88, 120, 96, 96, 113, 114, 116, 107, 109, 109, 109, 109, },
	{0, 1, 128, 120, 88, 96, 96, 96, 123, 114, 116, 127, 109, 109, 109, 109, },
	{0, 1, 128, 120, 128, 96, 121, 121, 122, 124, 142, 127, 109, 109, 109, 109, },
	{0, 1, 128, 120, 128, 121, 121, 121, 122, 124, 142, 127, 138, 138, 138, 138, },
	{0, 2, 4, 129, 128, 121, 121, 121, 133, 142, 126, 127, 119, 119, 119, 119, },
	{0, 2, 5, 129, 128, 121, 121, 131, 134, 142, 136, 108, 139, 139, 139, 139, },
	{0, 144, 145, 129, 128, 130, 131, 133, 135, 136, 137, 138, 139, 139, 139, 139, },
	{0, 144, 145, 129, 128, 140, 133, 134, 136, 137, 137, 138, 139, 139, 139, 139, },
	{0, 252, 200, 145, 144, 170, 148, 149, 151, 151, 157, 159, 253, 253, 253, 253, },
	{0, 252, 200, 146, 5, 148, 149, 149, 150, 151, 199, 169, 253, 253, 253, 253, },
	{0, 252, 200, 146, 6, 148, 163, 163, 164, 164, 167, 168, 169, 169, 169, 169, },
	{0, 252, 200, 146, 6, 148, 163, 163, 164, 164, 167, 168, 169, 169, 169, 169, },
	{0, 252, 200, 146, 5, 148, 149, 149, 150, 151, 199, 169, 253, 253, 253, 253, },
	{0, 252, 200, 145, 144, 170, 148, 149, 151, 151, 157, 159, 253, 253, 253, 253, },
	{0, 144, 145, 129, 128, 140, 133, 134, 136, 137, 137, 138, 139, 139, 139, 139, },
	{0, 144, 145, 129, 128, 130, 131, 133, 135, 136, 137, 138, 139, 139, 139, 139, },
	{0, 2, 5, 129, 128, 121, 121, 131, 134, 142, 136, 108, 139, 139, 139, 139, },
	{0, 2, 4, 129, 128, 121, 121, 121, 133, 142, 126, 127, 119, 119, 119, 119, },
	{0, 1, 128, 120, 128, 121, 121, 121, 122, 124, 142, 127, 138, 138, 138, 138, },
	{0, 1, 128, 120, 128, 96, 121, 121, 122, 124, 142, 127, 109, 109, 109, 109, },
	{0, 1, 128, 120, 88, 96, 96, 96, 123, 114, 116, 127, 109, 109, 109, 109, },
	{0, 1, 128, 88, 88, 120, 96, 96, 113, 114, 116, 107, 109, 109, 109, 109, },
}

-- Skin Colors used for custom low-detail Font

skincolors[SKINCOLOR_MARIOPUREWHITEFONT] = {
	ramp = {0,0,0,9,9,9,9,14,14,14,14,14,21,21,21,21},
	accessible = false
}

skincolors[SKINCOLOR_MARIOPUREGOLDFONT] = {
	ramp = {64,64,64,66,66,66,66,67,67,67,67,67,69,69,69,69},
	accessible = false
}

skincolors[SKINCOLOR_MARIOPURECYANFONT] = {
	ramp = {133,133,133,133,135,135,135,136,136,136,136,136,138,138,138,138},
	accessible = false
}

skincolors[SKINCOLOR_MARIOTINTCYANFONT] = {
	ramp = {129,129,129,129,132,132,132,135,135,135,135,135,136,136,136,136},
	accessible = false
}

skincolors[SKINCOLOR_MARIOTINTAQUAFONT] = {
	ramp = {122,122,122,122,125,125,125,125,125,125,125,125,126,126,126,126},
	accessible = false
}

skincolors[SKINCOLOR_MARIOPUREGREENFONT] = {
	ramp = {99,99,99,99,103,103,103,106,106,106,106,106,108,108,108,108},
	accessible = false
}

skincolors[SKINCOLOR_MARIOPUREREDFONT] = {
	ramp = {37,37,37,37,40,40,40,42,42,42,42,42,44,44,44,44},
	accessible = false
}

skincolors[SKINCOLOR_MARIOTINTREDFONT] = {
	ramp = {33,33,33,33,204,204,204,205,205,205,205,205,185,185,185,185},
	accessible = false
}

-- Animated Rainbow Font

skincolors[SKINCOLOR_MARIORAINBOWFONT1] = {
    ramp = {37, 37, 37, 37, 40, 40, 40, 42, 42, 42, 42, 42, 44, 44, 44, 44},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT2] = {
    ramp = {37, 37, 37, 37, 40, 40, 40, 62, 62, 62, 62, 62, 44, 44, 44, 44},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT3] = {
    ramp = {34, 34, 34, 34, 215, 215, 215, 61, 61, 61, 61, 61, 63, 63, 63, 63},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT4] = {
    ramp = {56, 56, 56, 56, 58, 58, 58, 60, 60, 60, 60, 60, 70, 70, 70, 70},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT5] = {
    ramp = {53, 53, 53, 53, 56, 56, 56, 58, 58, 58, 58, 58, 69, 69, 69, 69},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT6] = {
    ramp = {52, 52, 52, 52, 55, 55, 55, 57, 57, 57, 57, 57, 231, 231, 231, 231},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT7] = {
    ramp = {51, 51, 51, 51, 222, 222, 222, 225, 225, 225, 225, 225, 229, 229, 229, 229},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT8] = {
    ramp = {65, 65, 65, 65, 66, 66, 66, 67, 67, 67, 67, 67, 78, 78, 78, 78},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT9] = {
    ramp = {74, 74, 74, 74, 75, 75, 75, 76, 76, 76, 76, 76, 77, 77, 77, 77},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT10] = {
    ramp = {188, 188, 188, 188, 189, 189, 189, 190, 190, 190, 190, 190, 77, 77, 77, 77},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT11] = {
    ramp = {97, 97, 97, 97, 99, 99, 99, 101, 101, 101, 101, 101, 191, 191, 191, 191},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT12] = {
    ramp = {98, 98, 98, 98, 100, 100, 100, 102, 102, 102, 102, 102, 104, 104, 104, 104},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT13] = {
    ramp = {121, 121, 121, 121, 123, 123, 123, 124, 124, 124, 124, 124, 126, 126, 126, 126},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT14] = {
    ramp = {140, 140, 140, 140, 141, 141, 141, 142, 142, 142, 142, 142, 143, 143, 143, 143},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT15] = {
    ramp = {131, 131, 131, 131, 133, 133, 133, 135, 135, 135, 135, 135, 137, 137, 137, 137},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT16] = {
    ramp = {131, 131, 131, 131, 133, 133, 133, 149, 149, 149, 149, 149, 154, 154, 154, 154},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT17] = {
    ramp = {147, 147, 147, 147, 149, 149, 149, 153, 153, 153, 153, 153, 156, 156, 156, 156},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT18] = {
    ramp = {147, 147, 147, 147, 171, 171, 171, 172, 172, 172, 172, 172, 173, 173, 173, 173},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT19] = {
    ramp = {147, 147, 147, 147, 163, 163, 163, 165, 165, 165, 165, 165, 167, 167, 167, 167},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT20] = {
    ramp = {192, 192, 192, 192, 193, 193, 193, 164, 164, 164, 164, 164, 167, 167, 167, 167},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT21] = {
    ramp = {179, 179, 179, 179, 193, 193, 193, 194, 194, 194, 194, 194, 195, 195, 195, 195},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT22] = {
    ramp = {201, 201, 201, 201, 202, 202, 202, 203, 203, 203, 203, 203, 205, 205, 205, 205},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT23] = {
    ramp = {201, 201, 201, 201, 212, 212, 212, 214, 214, 214, 214, 214, 215, 215, 215, 215},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT24] = {
    ramp = {212, 212, 212, 212, 34, 34, 34, 37, 37, 37, 37, 37, 41, 41, 41, 41},
    accesible = false,
}

skincolors[SKINCOLOR_MARIORAINBOWFONT25] = {
    ramp = {33, 33, 33, 33, 35, 35, 35, 38, 38, 38, 38, 38, 62, 62, 62, 62},
    accesible = false,
}


-- Animated Power Up Skin Colors

skincolors[SKINCOLOR_FLAMEPOWERUP1] = {
    ramp = {49, 50, 32, 34, 35, 37, 39, 40, 41, 42, 43, 44, 45, 45, 46, 47},
    accesible = false,
}

skincolors[SKINCOLOR_FLAMEPOWERUP2] = {
    ramp = {48, 49, 51, 33, 34, 37, 39, 40, 41, 42, 43, 44, 45, 45, 46, 47},
    accesible = false,
}

skincolors[SKINCOLOR_FLAMEPOWERUP3] = {
    ramp = {48, 49, 51, 52, 34, 36, 38, 40, 41, 42, 43, 44, 45, 45, 46, 47},
    accesible = false,
}

skincolors[SKINCOLOR_FLAMEPOWERUP4] = {
    ramp = {48, 48, 50, 52, 53, 34, 36, 39, 41, 42, 43, 44, 45, 45, 46, 47},
    accesible = false,
}

skincolors[SKINCOLOR_ICEPOWERUP1] = {
    ramp = {128, 128, 129, 130, 131, 131, 132, 133, 133, 134, 135, 172, 173, 173, 175, 169},
    accesible = false,
}

skincolors[SKINCOLOR_ICEPOWERUP2] = {
    ramp = {128, 128, 129, 130, 131, 131, 132, 131, 131, 134, 142, 143, 127, 127, 175, 169},
    accesible = false,
}

skincolors[SKINCOLOR_ICEPOWERUP3] = {
    ramp = {128, 128, 129, 130, 131, 131, 132, 141, 141, 141, 125, 126, 127, 127, 109, 110},
    accesible = false,
}

skincolors[SKINCOLOR_ICEPOWERUP4] = {
    ramp = {128, 128, 129, 130, 131, 131, 132, 140, 123, 124, 125, 126, 127, 127, 109, 110},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN1] = {
    ramp = {133, 134, 134, 135, 171, 172, 172, 172, 173, 173, 173, 173, 174, 186, 186, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN2] = {
    ramp = {129, 129, 129, 140, 170, 170, 12, 171, 15, 16, 196, 196, 197, 197, 186, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN3] = {
    ramp = {96, 97, 98, 99, 100, 100, 92, 93, 93, 93, 21, 22, 23, 198, 198, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN4] = {
    ramp = {88, 89, 89, 90, 90, 241, 241, 242, 243, 17, 18, 196, 197, 197, 198, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN5] = {
    ramp = {180, 180, 202, 203, 203, 204, 204, 205, 205, 185, 185, 185, 186, 186, 186, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN6] = {
    ramp = {201, 201, 201, 202, 193, 193, 194, 194, 195, 195, 196, 196, 197, 186, 186, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN7] = {
    ramp = {170, 170, 171, 171, 194, 194, 195, 195, 196, 196, 196, 197, 197, 186, 186, 187},
    accesible = false,
}

skincolors[SKINCOLOR_MARIOINVULN8] = {
    ramp = {128, 145, 145, 170, 170, 170, 171, 171, 15, 195, 196, 196, 197, 197, 186, 187},
    accesible = false,
}

-- CURRENTLY UNUSED ANIMATED RAMPS

local animated_rainbow_block_ramp = {
	{0, 144, 145, 129, 128, 130, 131, 133, 135, 136, 137, 138, 139, 139, 139, 139, },
	{0, 144, 145, 129, 128, 140, 133, 134, 136, 137, 137, 138, 139, 139, 139, 139, },
	{0, 252, 200, 145, 144, 170, 148, 149, 151, 151, 157, 159, 253, 253, 253, 253, },
	{0, 252, 200, 146, 5, 148, 149, 149, 150, 151, 199, 169, 253, 253, 253, 253, },
	{0, 252, 200, 146, 6, 148, 163, 163, 164, 164, 167, 168, 169, 169, 169, 169, },
	{0, 252, 200, 177, 176, 192, 180, 180, 182, 183, 185, 186, 187, 187, 187, 187, },
	{0, 252, 200, 177, 176, 179, 180, 180, 204, 206, 207, 186, 187, 187, 187, 187, },
	{0, 208, 216, 177, 176, 202, 180, 180, 34, 206, 63, 71, 47, 47, 47, 47, },
	{0, 0, 80, 210, 216, 32, 33, 33, 58, 59, 61, 198, 199, 199, 199, 199, },
	{0, 0, 80, 218, 48, 52, 53, 52, 55, 68, 69, 236, 239, 239, 239, 239, },
	{0, 0, 80, 49, 208, 218, 51, 50, 65, 67, 78, 250, 239, 239, 239, 239, },
	{0, 0, 88, 48, 208, 49, 64, 64, 74, 86, 77, 79, 238, 238, 238, 238, },
	{0, 0, 88, 81, 80, 83, 72, 72, 188, 190, 191, 94, 238, 238, 238, 238, },
	{0, 0, 88, 81, 80, 83, 72, 188, 98, 190, 191, 107, 109, 109, 109, 109, },
	{0, 1, 120, 88, 80, 88, 188, 96, 98, 101, 104, 107, 109, 109, 109, 109, },
	{0, 1, 128, 88, 88, 120, 96, 96, 113, 114, 116, 107, 109, 109, 109, 109, },
	{0, 1, 128, 120, 88, 96, 96, 96, 123, 114, 116, 127, 109, 109, 109, 109, },
	{0, 1, 128, 120, 128, 96, 121, 121, 122, 124, 142, 127, 109, 109, 109, 109, },
	{0, 1, 128, 120, 128, 121, 121, 121, 122, 124, 142, 127, 138, 138, 138, 138, },
	{0, 2, 4, 129, 128, 121, 121, 121, 133, 142, 126, 127, 119, 119, 119, 119, },
	{0, 2, 5, 129, 128, 121, 121, 131, 134, 142, 136, 108, 139, 139, 139, 139, },
}

local animated_red_block_ramp = {
	{201, 211, 34, 34, 34, 35, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{200, 210, 34, 34, 34, 35, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{200, 201, 33, 33, 33, 35, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{200, 201, 32, 32, 32, 35, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{176, 200, 33, 33, 33, 34, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{176, 176, 33, 33, 33, 34, 38, 39, 41, 186, 187, 187, 199, 199, 199, 199, },
	{1, 177, 32, 32, 32, 33, 36, 38, 41, 186, 187, 187, 199, 199, 199, 199, },
	{176, 201, 201, 201, 180, 34, 38, 41, 186, 187, 187, 199, 199, 199, 199, 199, },
	{1, 200, 200, 200, 178, 202, 204, 205, 186, 187, 187, 199, 199, 199, 199, 199, },
}

local animated_aqua_block_ramp = {
	{128, 129, 130, 130, 130, 140, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, },
	{2, 129, 130, 130, 130, 140, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, },
	{1, 128, 130, 130, 130, 140, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, },
	{128, 130, 130, 130, 140, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, 109, },
	{128, 129, 129, 129, 130, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, 109, },
	{129, 129, 129, 129, 141, 125, 125, 126, 127, 127, 108, 108, 109, 109, 109, 109, },
	{128, 128, 128, 129, 140, 124, 124, 125, 127, 127, 108, 108, 109, 109, 109, 109, },
	{128, 128, 128, 128, 140, 123, 123, 124, 127, 127, 108, 108, 109, 109, 109, 109, },
	{1, 1, 1, 1, 121, 122, 122, 124, 127, 127, 108, 108, 109, 109, 109, 109, },
}

local animated_brown_block_ramp = {
	{64, 65, 223, 223, 223, 223, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{64, 65, 223, 223, 223, 223, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{83, 64, 223, 223, 223, 223, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{81, 84, 223, 223, 223, 223, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{81, 84, 221, 221, 221, 221, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{80, 83, 221, 221, 221, 221, 224, 230, 230, 250, 25, 25, 28, 28, 30, 30, },
	{80, 84, 220, 220, 220, 220, 223, 229, 229, 250, 25, 25, 28, 28, 30, 30, },
	{82, 217, 217, 217, 217, 221, 227, 227, 250, 25, 25, 28, 28, 28, 28, 30, },
	{216, 216, 216, 216, 220, 227, 227, 250, 25, 25, 28, 28, 28, 28, 28, 30, },
}

local animated_q_block_timing = {2,2,2,2,2,2,3,4,5,6,7,8,8,8,8,7,6,5,4,3,2}


local animated_flame_ramp = {
	SKINCOLOR_FLAMEPOWERUP1,
	SKINCOLOR_FLAMEPOWERUP2,
	SKINCOLOR_FLAMEPOWERUP3,
	SKINCOLOR_FLAMEPOWERUP4,
	SKINCOLOR_FLAMEPOWERUP3,
	SKINCOLOR_FLAMEPOWERUP2,
}

local animated_froze_ramp = {
	SKINCOLOR_ICEPOWERUP1,
	SKINCOLOR_ICEPOWERUP1,
	SKINCOLOR_ICEPOWERUP2,
	SKINCOLOR_ICEPOWERUP3,
	SKINCOLOR_ICEPOWERUP4,
	SKINCOLOR_ICEPOWERUP4,
	SKINCOLOR_ICEPOWERUP3,
	SKINCOLOR_ICEPOWERUP2,
}

-- Color functions

if xMM_registry then
	-- get hue color form rainbow palette
	xMM_registry.getHueFontColor = function(index)
		local i = (index-1 % 25) + 1
		return _G["SKINCOLOR_MARIORAINBOWFONT"..i]
	end

	-- rainbow
	xMM_registry.getRainbowFontColor = function(delay)
		local i = ((leveltime/delay - 1) % 25) + 1
		return _G["SKINCOLOR_MARIORAINBOWFONT"..max(i, 1)]
	end

	-- flamy
	xMM_registry.getFlameColor = function(delay)
		local i = ((leveltime/delay - 1) % #animated_flame_ramp) + 1
		return animated_flame_ramp[i]
	end

	-- icy
	xMM_registry.getIcyColor = function(delay)
		local i = ((leveltime/delay - 1) % #animated_froze_ramp) + 1
		return animated_froze_ramp[i]
	end

	addHook("ThinkFrame", function()
		if not leveltime then return end

		-- ?-block animated "skincolors", backend
		local qblocks_i = ((leveltime - 1) % #animated_q_block_timing) + 1
		local qblocks_frame = animated_q_block_timing[qblocks_i]
		skincolors[SKINCOLOR_GOLDENBLOCK].ramp = GOLDENBLOCK_RAMP[qblocks_frame]
		skincolors[SKINCOLOR_CYANBLOCK].ramp = CYANBLOCK_RAMP[qblocks_frame]
		skincolors[SKINCOLOR_BEIGEBLOCK].ramp = BEIGEBLOCK_RAMP[qblocks_frame]
		skincolors[SKINCOLOR_GREENBLOCK].ramp = GREENBLOCK_RAMP[qblocks_frame]
		skincolors[SKINCOLOR_GRAYBLOCK].ramp = GRAYBLOCK_RAMP[qblocks_frame]

		-- Random Block animated "skincolors", backend
		local rollblocks_i = ((leveltime/3 - 1) % #AURORAROLLBLOCK_RAMP) + 1
		skincolors[SKINCOLOR_AURORAROLLBLOCK].ramp = AURORAROLLBLOCK_RAMP[rollblocks_i] or AURORAROLLBLOCK_RAMP[1]


		xMM_registry.current_rainbowfontcolor = xMM_registry.getRainbowFontColor(2)


	end)
end


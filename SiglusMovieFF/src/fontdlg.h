// SiglusMovieFF - font settings window layout repair (see fontdlg.cpp).
#pragma once

// Implemented in dllmain.cpp: rewrite one IAT slot of the host executable.
bool SmfPatchHostIat(const char* dll, const char* name, void* replacement);

// Called once after the IAT hooks are installed.
void SmfFontDialogInit();

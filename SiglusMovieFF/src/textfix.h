// SiglusMovieFF - text layout fixes (see textfix.cpp).
#pragma once

// Applies the byte patches.  Must run before the host starts laying out text,
// so it is called from DllMain.
void SmfTextFixPatch();

// Prepares the width-table correction list; called after the loader is done.
void SmfTextFixInit();

// Identifiers for instrumented memory copies, so a fault can be attributed to a
// specific call site (the test harness prints the id it last received).
#pragma once

enum SmfMemcpySite {
    SMF_CPY_UNKNOWN       = 0,
    SMF_CPY_AUDIO_FEEDER  = 1,
    SMF_CPY_D3D_TEXTURE   = 2,
    SMF_CPY_GDI_FULL      = 3,
    SMF_CPY_GDI_ROW       = 4,
    SMF_CPY_D3D_ROW       = 5,
    SMF_CPY_HOST_PATCH    = 6,
};

const char* SmfMemcpySiteName(unsigned site);

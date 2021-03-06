#include "ui_host.h"
#include "dialogs.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef PRODBG_MAC

extern void MacDialog_infoDialog(const char* title, const char* message);
extern void MacDialog_errorDialog(const char* title, const char* message);
extern void MacDialog_warningDialog(const char* title, const char* message);

PDMessageFuncs g_serviceMessageFuncs =
{
    MacDialog_infoDialog,
    MacDialog_errorDialog,
    MacDialog_warningDialog,
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#elif PRODBG_WIN

void Windows_infoDialog(const char*, const char*);
void Windows_errorDialog(const char*, const char*);
void Windows_warningDialog(const char*, const char*);

PDMessageFuncs g_serviceMessageFuncs =
{
    Windows_infoDialog,
    Windows_errorDialog,
    Windows_warningDialog,
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#else

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Dummy_infoDialog(const char*, const char*) {}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Dummy_errorDialog(const char*, const char*) {}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void Dummy_warningDialog(const char*, const char*) {}

PDMessageFuncs g_serviceMessageFuncs =
{
    Dummy_infoDialog,
    Dummy_errorDialog,
    Dummy_warningDialog,
};

#endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PDDialogFuncs g_dialogFuncs =
{
    Dialog_open,
    Dialog_save,
    Dialog_selectDirectory,
};

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

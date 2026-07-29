# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['jpy-rate-updater.py'],
    pathex=[],
    binaries=[],
    datas=[
		(
            'const.py',
            'siglus_ssu'
        ),
	],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='JPYRateUpdater',
    icon='AngelBeats!.ico',
    version='version-rate-update.txt',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

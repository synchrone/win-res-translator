@echo off
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -action compile -open menus.rc -save menus.res -log CON
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open orig\FlowENGB.dll -log CON -save FlowENGB.dll -action addoverwrite -res menus.res -mask MENU,,


"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -action compile -open dialogs.rc -save dialogs.res -log CON
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open FlowENGB.dll -log CON -save FlowENGB.dll -action addoverwrite -res dialogs.res -mask DIALOG,,

"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -action compile -open stringtables.rc -save stringtables.res -log CON
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open FlowENGB.dll -log CON -save FlowENGB.dll -action addoverwrite -res stringtables.res -mask STRINGTABLE,,
pause
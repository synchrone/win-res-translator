@echo off
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open FlowENGB.dll -log CON -action extract -mask MENU,, -save menus.rc
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open FlowENGB.dll -log CON -action extract -mask STRINGTABLE,, -save stringtables.rc
"C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe" -open FlowENGB.dll -log CON -action extract -mask DIALOG,, -save dialogs.rc

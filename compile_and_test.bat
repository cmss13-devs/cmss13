@echo off
call dm ColonialMarinesALPHA.dme
if %ERRORLEVEL% == 0 goto :run_server
goto :end

:run_server
call DreamDaemon ColonialMarinesALPHA.dmb 58140 -trusted -params "local_test=1"

:end
exit
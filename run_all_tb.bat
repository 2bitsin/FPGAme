@echo off
for %%a in (clkdiv uart_tx top) do (
  echo Executing testbench %%a ...
  call run_tb.bat %%a
)
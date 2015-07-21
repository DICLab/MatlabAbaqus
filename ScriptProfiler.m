function ScriptProfiler(scriptName)
% Profiler para scrips

profile on

eval(scriptName)% script del que se quiere hacer profile

profile off
profile viewer
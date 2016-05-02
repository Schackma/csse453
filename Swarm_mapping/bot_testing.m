clc; clear;

globalMap = [1,1,1,1,1;
    1,0,0,0,1;
    1,0,0,0,1;
    1,0,0,0,1;
    1,1,1,1,1;];

pos = [3,2];
motherPos = pos;

b = BOT(pos,motherPos,globalMap);
% b.move(globalMap)
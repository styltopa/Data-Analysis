% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Exercise 3

clc;
clear;
close all;

data = table2array(readtable("Heathrow.xlsx"));

years = data(:, 1);
% example feature
info = data(:, 2);
pArr = Group10Exe3Fun1(years, info);

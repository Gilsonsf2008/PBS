%function [RMSE_EKF, di, x, a_i, x_cap] = calc_EKF(l, w, n, sigma, mc)
%
clear all;
clc;
close all;
tic;
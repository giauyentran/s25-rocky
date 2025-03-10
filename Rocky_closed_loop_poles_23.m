% Rocky_closed_loop_poles_23.m
%
% 1) Symbolically calculates closed loop transfer function of a disturbannce
% rejection PI control system for Rocky. 
% No motor model (M =1). With motor model (1st order TF)
%
% 2) Specify location of (target)poles based on desired reponse. The number of
% poles = denominator polynomial of closed loop TF
%
% 3) Extract the closed loop denomiator poly and set = polynomial of target
% poles
%
% 4) Solve for Ki, Kp  to match coefficients of polynomials. In general,
% this will be underdefined and will not be able to place poles in exact
% locations. In this, the control constants can be found exactly 
%
% 5) Plot impulse and step response to see closed-loop behavior. 
%
% based on code by SG. last modified 2/25/23 CL

clear all; 
close all;

syms s a b l g Kp Ki Jp Ji Ci   % define symbolic variables

Hvtheta = -s/l/(s^2-g/l);       % TF from velocity to angle of pendulum

K = Kp + Ki/s;                  % TF of the PI angle controller
J = Jp + Ji/s + Ci/s^2;         % TF of the PI velocity controller
M = a*b/(s+a);                  % TF of motor (1st order model) 
JM = M/(1+J*M);                 % TF of motor and controller

% closed loop transfer function from disturbance d(t)totheta(t)
Hcloop = 1/(1-Hvtheta*JM*K);    % use this for no motor feedback

pretty(simplify(Hcloop));       % to display the total transfer function

% Substitute parameters and solve
% system parameters
g = 9.81;
l = 0.3062;         %effective length
t = 0.0644;         %tau
K = 0.0027;         %K
a = 1/t;       %nominal motor parameters
b = K;         %nominal motor parameters
m = 0.53;      %m


Hcloop_sub = subs(Hcloop); % sub parameter values into Hcloop

% specify locations of the target poles,
% choose # based on order of Htot denominator
% e.g., want some oscillations, want fast decay, etc. 
p1 = -1 + 1i;      % dominant pole pair
p2 = -1 - 1i;      % dominant pole pair 
p3 = -6;
p4 = -7;
p5 = -7;


% target characteristic polynomial
% if motor model (TF) is added, order of polynomial will increases
tgt_char_poly = (s-p1)*(s-p2)*(s-p3)*(s-p4)*(s-p5);
npoly = 5;


% get the denominator from Hcloop_sub
[n d] = numden(Hcloop_sub);

% find the coefficients of the denominator polynomial TF
coeffs_denom = coeffs(d, s);

% divide though the coefficient of the highest power term
coeffs_denom = coeffs(d, s)/(coeffs_denom(end));

% find coefficients of the target charecteristic polynomial
coeffs_tgt = coeffs(tgt_char_poly, s);

% solve the system of equations setting the coefficients of the
% polynomial in the target to the actual polynomials
solutions = solve(coeffs_denom(1:npoly) == coeffs_tgt(1:npoly),  Kp, Ki, Jp, Ji, Ci);

% display the solutions as double precision numbers
Kp = double(solutions.Kp)
Ki = double(solutions.Ki)
Jp = double(solutions.Jp)
Ji = double(solutions.Ji)
Ci = double(solutions.Ci)

% reorder coefficients for the check polynomial 
for ii = 1:length(coeffs_denom)
    chk_coeffs_denom(ii) = coeffs_denom(length(coeffs_denom) + 1 - ii);
end
closed_loop_poles = vpa (roots(subs(chk_coeffs_denom)), npoly );


% Plot impulse response of closed-loop system
    TFstring = char(subs(Hcloop));
    % Define 's' as transfer function variable
    s = tf('s');
    % Evaluate the expression
    eval(['TFH = ',TFstring]);
    figure (1)
    impulse(TFH);   %plot the impulse reponse
    figure(2)
    step(TFH)       %plot the step response
    
    %run simulink model
    g = -9.81;
    model2023








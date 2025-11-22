function P_rx = polyphase_wpt_model(d, P_tx, misalign)
% ---------------------------------------------------------------
%  WPT_PowerTransfer
%
%  Calculates the actual power that reaches the receiver side of a
%  100‑kW, 3‑phase, poly‑phase wireless power‑transfer (WPT) system
%  as described in the 100‑kW Polyphase WPT papers (Onar 2024–2025).
%
%  INPUTS
%   d        – Transmitter–receiver air‑gap (m)  
%   P_tx     – Transmitted power at the primary side (W)  
%   misalign – Relative mis‑alignment (unitless, 0 = perfect,
%              1 = complete loss of coupling).  The user may
%              also pass a lateral offset (m) – the code will
%              convert it to a fractional loss automatically
%              if the value is > 1 and < 0.5*(r_t+r_r).
%
%  OUTPUT
%   P_rx     – Actual power that reaches the receiver DC bus (W)
%
%% ---- 1. System constants  -------------------------------------
% Nominal distance
dn = 0.17; %m

% Coupling efficiency at nominal conditions based on the paper
eta_at_dn = 0.9435;      % 94.35 % % 50kW power

% Distance‑exponent (for coaxial circular loops, M ∝ d^-3)
n_dist = 3;

%% ---- 2. Pre‑process the mis‑alignment input -----------------

% If the user has entered a lateral offset (m) instead of a fraction,
% convert it to a fractional loss.  We assume the loss is linear in
% offset up to the sum of coil radii, after which coupling is zero.
if misalign > 1
    % interpret as an offset in metres
    offset = misalign;
    max_offset = r_t + r_r;          % worst case offset (full decoupling)
    frac = min(max(offset/max_offset,0),1);
    misalign = frac;
end
% misalign must be between 0 and 1
misalign = max(min(misalign,1),0);

%% ---- 3. Effective coupling coefficient -----------------------

% Distance scaling (assumes d >= d0)
if d < dn

k_dist = 1 + 1 / (-3 - exp(-70*d+14.587787)) ;
k_eff = k_dist * (1 - misalign);
eta_couple = (k_eff / 1)^1;

elseif d == dn

    eta_couple = eta_at_dn * (1-misalign)^2;

else

    d_eff = d;
    k_dist = (dn/d_eff)^n_dist; 
    k_eff = k_dist * (1 - misalign);
    eta_couple = (k_eff)^2;

end

%% ---- 5. Delivered power -------------------------------------

% Delivered power at the receiver DC bus
P_rx = P_tx * eta_couple;

% Clamp to the system's rated maximum (≈ 300 kW)
P_rx = min(P_rx, 300e3);

end
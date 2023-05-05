% eegplugin_REST_fieldtrip() - EEGLAB plugin for computing infinity
%                              reference (uses FieldTrip)
%
% Usage:
%   >> eegplugin_REST_fieldtrip(fig, trystrs, catchstrs);
%
% Inputs:
%   fig        - [integer]  EEGLAB figure
%   trystrs    - [struct] "try" strings for menu callbacks.
%   catchstrs  - [struct] "catch" strings for menu callbacks.
%
% Author: Arnaud Delorme, UCSD, 2023

% Copyright (C) 2023 Arnaud Delorme
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
% THE POSSIBILITY OF SUCH DAMAGE.

function vers = eegplugin_REST_fieldtrip(fig, trystrs, catchstrs)

    vers = 'REST_fieldtrip1.0';
    if nargin < 3
        error('eegplugin_REST_fieldtrip requires 3 arguments');
    end

    % add folder to path
    % -----------------------
    if ~exist('eegplugin_REST_fieldtrip')
        p = which('eegplugin_REST_fieldtrip');
        p = p(1:findstr(p,'eegplugin_REST_fieldtrip.m')-1);
        addpath([p vers]);
    end

    % find import data menu
    % ---------------------
    menu = findobj(fig, 'label', 'Tools');
    comref = [trystrs.no_check '[EEG, LASTCOM] = pop_refrefinf(EEG);' catchstrs.new_and_hist];

    % create menus if necessary
    % -------------------------
    uimenu( menu, 'Label', 'Infinity reference (FieldTrip)', 'CallBack', comref, 'userdata', 'study:on');
  

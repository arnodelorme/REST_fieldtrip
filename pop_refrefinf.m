% pop_refrefinf() - Computing infinity reference (uses FieldTrip) but also
%                   median and average reference.
%
% Usage:
%   >> EEG = pop_refrefinf(EEG, reftype);
%
% Input:
%   reftype  - ['infinity'|'average'|'median'] type of re-referencing.
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

function [EEG, com] = pop_refrefinf(EEG, reftype)

if nargin < 1
    help pop_refrefinf;
    return
end

allRefTypes = { 'Infinity' 'Average' 'Median'  };
if nargin < 2
    uilist   = { { 'style' 'text' 'String' 'Choose the type of rereferencing:' } ...
        { 'style' 'popupmenu' 'string' allRefTypes 'tag' 'ref' } ...
        { 'style' 'text' 'String' 'Note: for infinity reference, first compute Leadfield matrix using DIPFIT' } ...
        };
    geom = { [3 1.5] [1] };
    [result,~,~,restag] = inputgui( geom, uilist, 'pophelp(''pop_refrefinf'')', 'Rereference data using Fieldtrip -- pop_refrefinf()');
    if isempty(result) return; end

    reftype = allRefTypes{ restag.ref };
end

reftype = lower(reftype);
if ~contains(lower(allRefTypes), reftype)
    error('Unknown reference')
end

dataPre = eeglab2fieldtrip(EEG, 'preprocessing', 'dipfit');

if isequal(reftype, 'infinity')
    if ~isfield(EEG.dipfit, 'sourcemodel') || ~isfield(EEG.dipfit.sourcemodel, 'leadfield')
        error('You must compute the Leadfield matrix with DIPFIT first')
    end

    cfg             = [];
    cfg.implicitref = [];
    cfg.reref = 'yes';
    cfg.refmethod = 'rest';
    cfg.refchannel = 'all';
    cfg.leadfield = EEG.dipfit.sourcemodel;
    dataref = ft_preprocessing(cfg, dataPre);
else
    cfg             = [];
    cfg.implicitref = [];
    cfg.reref = 'yes';
    cfg.refmethod = reftype;
    if isequal(reftype, 'average')
        cfg.refmethod = 'avg';
    end
    cfg.refchannel = 'all';
    dataref = ft_preprocessing(cfg, dataPre);
end

% copy the data back to the EEGLAB structure
if length(dataref.trial) == 1
    EEG.data = dataref.trial{1};
else
    EEG.data = [dataref.trial{:} ];
    EEG = eeg_checkset(EEG);
end

com = sprintf('EEG = pop_refrefinf(EEG, ''%s'');', reftype);
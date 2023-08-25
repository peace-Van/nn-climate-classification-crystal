close all; clear; clc;

%% parameters

wl = 30;                    % window length
first_year = 2001 - wl;     % 1971 - 2000
last_year = 2021 - wl;      % 1991 - 2020
batch_size = 64;

%% load data

fprintf('Loading original data...\n')
load('pre.mat'); load('pet.mat'); load('tmp.mat');
load('tmn.mat'); load('tmx.mat'); load('elev.mat');
fprintf('\n')

%% prepare dataset

fprintf('Preparing dataset...\n')
for yr = first_year:last_year
    tic
    fprintf('%d ', yr + wl)
    load(sprintf('veg_%d.mat', yr + wl))
    res = audit(yr - 1900, wl, tmp, pre, pet, tmn, tmx, veg, elev);
    save(sprintf("dataset_%d.mat", yr + wl), "res");
    toc
end
fprintf('\n')

%% prepare datastore

fprintf('Preparing training datastore...\n')
t = {};
for yr = first_year:last_year
    tic
    fprintf('%d ', yr + wl)
    load(sprintf('dataset_%d.mat', yr + wl))
    ds = res2datastore(res, true, batch_size);
    t = [t; readall(ds)];
    toc
end
ds_train = arrayDatastore(t, ReadSize=batch_size, OutputType='same');
save('datastore_train.mat', "ds_train");
fprintf('\n')

% validation on last year
fprintf('Preparing validation datastore...\n')
tic
fprintf('%d ', last_year + wl)
load(sprintf('dataset_%d.mat', last_year + wl))
ds_valid = res2datastore(res, true, batch_size);
toc
save('datastore_valid.mat', "ds_valid")
fprintf('\n')

fprintf('Preparing prediction datastore...\n')
for yr = first_year:last_year
    tic
    fprintf('%d ', yr + wl)
    load(sprintf('dataset_%d.mat', yr + wl))
    ds = res2datastore(res, false, batch_size);
    save(sprintf('datastore_%d.mat', yr + wl), "ds");
    toc
end
fprintf('All done.\n')

clear

%% load data and import functions
path(pathdef)
addpath .\lib\stagedPointProcess
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

M = containers.Map({'linear', 'quadratic', 'sin'}, [1, 2, 3]);
transType = M('sin');

spikeTrainX = input{1};
spikeTrainY = outputY{transType,1};
lambdaYTrain = outputLambda{transType,1};
[Nx, K] = size(spikeTrainX);

spikeTrainXvalidate = input{2};
spikeTrainYvalidate = outputY{transType,2};
lambdaYValidate = outputLambda{transType,2};

spikeTrainXtest = input{3};
spikeTrainYtest = outputY{transType,3};
lambdaYTest = outputLambda{transType,3};

%% get hyperparams
[preTrainN, H, Nz, xi1, xi2, mu, threshold, iterationThres, maxIterations, alpha] = hyperParams();

%% get Xhat
Xhat = getXhat(spikeTrainX, H);
XhatValidate = getXhat(spikeTrainXvalidate, H);
XhatTest = getXhat(spikeTrainXtest, H);

%%
% load goodW.mat
% load Goodmu.mat
Whistory = zeros(preTrainN, Nx*H*Nz+Nz+Nz+1);
PreLhistory = zeros(1 ,preTrainN);
% muHistory = zeros(1 ,preTrainN);
mu0 = mu;
for pre=1:preTrainN
    %% initialize the params
%     if (pre > size(goodW, 1))
      W = initialParams(H, Nx, Nz, xi1, xi2);
      mu = mu0;
%     else
%       W = goodW(pre, :);
%       mu = 1;
%     end
    % mu = Goodmu(pre);

    %% initialize histories
    LHistory = zeros(1, maxIterations+1);
    [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XhatValidate, W, H, Nx, Nz);
    L = logLikelyhood(spikeTrainYvalidate, lambdaYTrainPredictValidate, alpha * 0.5 * norm(W, 2)^2); % get L
    iteration = 1;
    LHistory(iteration) = L;
    overIterations = 0;

    %% Train the model
    for i=1:maxIterations
        if (mod(iteration, 3) == 0)
          fprintf('#')
        end
        % update params
        [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(Xhat, W, H, Nx, Nz);
        [Wnew, bad] = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), Xhat, mu, W, Nx, H, alpha);
        if (bad)
          fprintf('bad condition. ')
          break;
        end
        normW = alpha * 0.5 * norm(W, 2)^2;
        % validate
        [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XhatValidate, Wnew, H, Nx, Nz);
        L = logLikelyhood(spikeTrainYvalidate, lambdaYTrainPredictValidate, normW); % get L

        % update fail, multiply mu and re-update
        if (L <= LHistory(iteration) - 30 && mu <= 1e7)
          mu = mu * 1000;
          continue;
        end

        iteration = iteration + 1;
        LHistory(iteration:length(LHistory)) = L; % record L
        plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, Wnew)
%         plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, Wnew)
        % update overIterations
        if (L - LHistory(iteration-1) < threshold)
          overIterations = overIterations + 1;
        else
          overIterations = 0;
        end
        % check iter condition
        if (overIterations > iterationThres)
          fprintf('Converge. ')
          break;
        end

        % update mu & W
        W = Wnew;
        if (L > LHistory(iteration-1) - 30 && mu > 1e-7)
          mu = mu/100;
        end

        if (max(W) > 100)
          fprintf('Large W. ')
          break;
        end
    end

    Whistory(pre, :) = W;
    PreLhistory(pre) = L;
    % muHistory(pre) = mu;
    fprintf('  pretrain %2d Completed.\n', pre);
    %% Test
%     [lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(XhatTest, W, H, Nx, Nz);
%     plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

    figure(fix((pre-1)/5)+3)
    subplot(5, 1, mod(pre-1, 5)+1)
    t = 0:0.01:(length(lambdaYTrainPredictValidate) - 1) * 0.01;
    plot(t, lambdaYTrainPredictValidate);
    drawnow
end

%% calculate DBR
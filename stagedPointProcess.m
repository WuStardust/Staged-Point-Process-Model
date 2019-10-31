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
% load GoodW.mat
% load Goodmu.mat
Whistory = zeros(preTrainN, Nx*H*Nz+Nz+Nz+1);
PreLhistory = zeros(1 ,preTrainN);
% muHistory = zeros(1 ,preTrainN);
mu0 = mu;
for pre=1:preTrainN
    %% initialize the params
    W = initialParams(H, Nx, Nz, xi1, xi2);
    % W = GoodW(pre, :);
    % mu = Goodmu(pre);
    mu = mu0;

    %% initialize histories
    LHistory = zeros(1, maxIterations+1);
    L = -Inf; % initialize Lpre as -Inf
    LHistory(1) = L;
    overIterations = 0;

    %% Train the model
    for iteration=1:maxIterations
        % update params
        [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(Xhat, W, H, Nx, Nz);
        [W, G, He] = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), Xhat, mu, W, Nx, H, alpha);

        normW = alpha * 0.5 * norm(W, 2)^2;
        % validate
        [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XhatValidate, W, H, Nx, Nz);
        [L, overIterations] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, L, overIterations, threshold, normW);
        LHistory(iteration+1:length(LHistory)) = L; % record L
        if (overIterations > iterationThres)
        break;
        end
        plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)

        if (L > LHistory(iteration))
        mu = mu/10;
        else
        mu = 10*mu;
        end

        if (mod(iteration, 5) == 0)
          fprintf('#')
        end
        if (L < -1e5)
          break;
        end
    end

    Whistory(pre, :) = W;
    PreLhistory(pre) = L;
    % muHistory(pre) = mu;
    fprintf('  pretrain %2d Completed.\n', pre);
    %% Test
    [lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(XhatTest, W, H, Nx, Nz);
    plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

    figure(fix((pre-1)/5)+1)
    subplot(5, 1, mod(pre-1, 5)+1)
    t = 0:0.01:(length(lambdaYTrainPredictValidate) - 1) * 0.01;
    plot(t, lambdaYTrainPredictValidate);
end

%% calculate DBR
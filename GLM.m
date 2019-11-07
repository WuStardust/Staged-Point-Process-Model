clear

%% load data and import functions
path(pathdef)
addpath .\lib\GLM
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

DBRresults = zeros(3, 10);
bestDBR = [Inf, Inf, Inf];
bestDataset = zeros(1, 3);
results = cell(3, 6);

for sample = 1:10
  for transType=1:3
    complete = 0;
    while(~complete)
    spikeTrainX = input{sample, 1};
    spikeTrainY = outputY{sample, transType, 1};
    lambdaYTrain = outputLambda{sample, transType, 1};

    spikeTrainXvalidate = input{sample, 2};
    spikeTrainYvalidate = outputY{sample, transType, 2};
    lambdaYValidate = outputLambda{sample, transType, 2};

    spikeTrainXtest = input{sample, 3};
    spikeTrainYtest = outputY{sample, transType, 3};
    lambdaYTest = outputLambda{sample, transType, 3};

    %% get hyperparams
    [H, Wh, xi, threshold, iterationThres, maxIterations, alpha] = hyperParams();

    %% get Xhat
    [Nx, K] = size(spikeTrainX);
    Xhat = zeros(Nx * H + 1, K - H + 1);
    for h=1:H
        for i=1:Nx
            Xhat(Nx * (h - 1) + i, :) = spikeTrainX(i, H-h+1:K-h+1);
        end
    end
    Xhat(Nx * H + 1, :) = ones(1, K - H + 1);
    Xhat = sparse(Xhat);

    %% initialize the params
    W = initialParams(H, Nx, xi);

    %% history variables
    LHistory = zeros(1, maxIterations);
    L = -Inf; % initialize Lpre as -Inf
    overIterations = 0;

    %% Train the model
    for iteration=1:maxIterations
      % update params
      [lambdaYTrainPredict, spikeTrainYpredict] = model(spikeTrainX, W);
      [W, isSingular] = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), Xhat, W, alpha);
      if (isSingular)
        break;
      end

      normW = alpha * norm(W, 1);
      % validate
      [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(spikeTrainXvalidate, W);
      [L, overIterations] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, L, overIterations, threshold, normW);
      LHistory(iteration:length(LHistory)) = L; % record L
      if (overIterations > iterationThres)
        break;
      end
      % plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
    end

    if (isSingular)
      continue;
    end

    %% test
    [lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(spikeTrainXtest, W);
%     plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, LHistory, W)
    [DBR, y] = dbr(lambdaYTrainPredictTest, spikeTrainYtest);
%     disp(['Test result: DBR: ', num2str(DBR)])
    DBRresults(transType, sample) = DBR;

    complete = 1;
    end
    if (DBR < bestDBR(transType))
      bestDBR(transType) = DBR;
      results(transType, :) = {spikeTrainYtest, lambdaYTest, lambdaYTrainPredictTest, spikeTrainYpredicTest, W, y};
    end
  end
end
DBRresults(: ,11) = mean(DBRresults, 2);
disp(['Test result: DBR: ', num2str(DBRresults(:, 11)')])

plotResults(results)
save('results\new\GLMResults.mat', 'results', 'DBRresults')

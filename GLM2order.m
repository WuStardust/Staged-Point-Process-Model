clear

%% load data and import functions
path(pathdef)
addpath .\lib\GLM2order
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

DBRresults = zeros(3, 10);
bestDBR = [Inf, Inf, Inf];
bestDataset = zeros(1, 3);
results = cell(3, 6);

for sample = 1:10
  for transType=1:3
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
    if (transType == 1)
      alpha = 0.003;
    end

    %% get Xhat, XcovHat
    Xall = getXall(spikeTrainX, H);
    XallValidate = getXall(spikeTrainXvalidate, H);
    XallTest = getXall(spikeTrainXtest, H);

    %% initialize the params
    [Nx, K] = size(spikeTrainX);
    W = initialParams(H, Nx, xi);

    %% history variables
    Whistory = zeros(Wh, length(W));
    LHistory = zeros(1, maxIterations);
    L = -Inf; % initialize Lpre as -Inf
    overIterations = 0;

    %% Train the model
    for iteration=1:maxIterations
      % update params
      [lambdaYTrainPredict, spikeTrainYpredict] = model(Xall, W, H);
      W = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), Xall, W, alpha);
      Whistory = [Whistory(2:Wh, :); W];

      normW = alpha * norm(W, 1);
      % validate
      [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XallValidate, W, H);
      [L, overIterations] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, L, overIterations, threshold, normW);
      LHistory(iteration:length(LHistory)) = L; % record L
      if (overIterations > iterationThres)
        break;
      end
      % plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
    end

    %% test
    [lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(XallTest, W, H);
    % plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, LHistory, W)
    [DBR, y] = dbr(lambdaYTrainPredictTest, spikeTrainYtest);
    % disp(['Test result: DBR: ', num2str(DBR)])
    DBRresults(transType, sample) = DBR;

    if (DBR < bestDBR(transType))
      bestDBR(transType) = DBR;
      results(transType, :) = {spikeTrainYtest, lambdaYTest, lambdaYTrainPredictTest, spikeTrainYpredicTest, W, y};
    end
  end
end
DBRresults(: ,11) = mean(DBRresults, 2);
disp(['Test result: DBR: ', num2str(DBRresults(:, 11)')])

plotResults(results)
save('results\new\secondGLMResults.mat', 'results', 'DBRresults')
saveas(1, 'results\new\secondGLM1.fig')
saveas(2, 'results\new\secondGLM2.fig')
saveas(3, 'results\new\secondGLM3.fig')

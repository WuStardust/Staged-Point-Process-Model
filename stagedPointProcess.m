clear

%% load data and import functions
path(pathdef)
addpath .\lib\stagedPointProcess
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

DBRresults = zeros(3, 10);
bestDBR = [Inf, Inf, Inf];
bestDataset = zeros(1, 3);
results = cell(3, 6);

for sample = 1:1
  for transType=3:3
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
    [~, H, Nz, xi1, xi2, mu, threshold, iterationThres, maxIterations, alpha] = hyperParams();

    %% get Xhat
    [Nx, K] = size(spikeTrainX);
    Xhat = getXhat(spikeTrainX, H);
    XhatValidate = getXhat(spikeTrainXvalidate, H);
    XhatTest = getXhat(spikeTrainXtest, H);

    % load goodW.mat
    % Whistory = zeros(preTrainN, Nx*H*Nz+Nz+Nz+1);
    % PreLhistory = zeros(1 ,preTrainN);
    % mu0 = mu;
    % for pre=1:preTrainN
        %% initialize the params
        % if (pre > size(goodW, 1))
          W = initialParams(H, Nx, Nz, xi1, xi2);
        % else
          % W = goodW(pre, :);
        % end
        % mu = mu0;

        %% initialize histories
        LHistory = zeros(1, maxIterations+1);
        [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XhatValidate, W, H, Nx, Nz);
        L = logLikelyhood(spikeTrainYvalidate, lambdaYTrainPredictValidate, alpha * 0.5 * norm(W, 2)^2); % get L
        [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(Xhat, W, H, Nx, Nz);
        LtrainPre = logLikelyhood(spikeTrainYpredict, lambdaYTrainPredict, alpha * 0.5 * norm(W, 2)^2); % get L on train
        iteration = 1;
        LHistory(iteration) = L;
        overIterations = 0;

        %% Train the model
        Whistory = zeros(ceil(maxIterations/5), Nx*H*Nz+Nz+Nz+1);
        for i=1:maxIterations
          if (mod(iteration, 3) == 0)
            fprintf('#')
          end
          % update params
          [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(Xhat, W, H, Nx, Nz);
          Ltrain = logLikelyhood(spikeTrainYpredict, lambdaYTrainPredict, alpha * 0.5 * norm(W, 2)^2); % get L on train
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
          if (Ltrain <= LtrainPre && mu <= 1e7)
            mu = mu * 10;
            continue;
          end

          iteration = iteration + 1;
          LHistory(iteration:length(LHistory)) = L; % record L
          % update overIterations
          if (L - LHistory(iteration-1) < threshold)
            overIterations = overIterations + 1;
          else
            overIterations = 0;
          end
          % check iter condition
          if (overIterations > iterationThres)
            % fprintf('Converge. ')
            break;
          end

          % update mu & W
          W = Wnew;
          if (Ltrain > LtrainPre && mu > 1e-7)
            mu = mu/10;
          end

          LtrainPre = Ltrain;
          
          figure(1)
          subplot(2, 1, 1)
          plot(LHistory)
          subplot(2, 1, 2)
          plot(W)
          figure(ceil((iteration-1)/25)+1)
          subplot(5, 1, ceil(mod(iteration-1, 25)/5))
          t = 0:0.01:(length(spikeTrainYvalidate) - 1) * 0.01;
          plot(t, lambdaYTrainPredictValidate);
          Whistory(ceil((iteration-1)/5), :) = W;

          if (max(W) > 50)
            fprintf('Large W. ')
            bad = 1;
            break;
          end
        end

        if (bad)
          continue;
        end

        % Whistory(pre, :) = W;
        % PreLhistory(pre) = L;
        % fprintf('Pretrain %2d Completed.\n', pre);
        %% Test
    %     
    %     plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

        % figure(fix((pre-1)/5)+3)
        % subplot(5, 1, mod(pre-1, 5)+1)
        % t = 0:0.01:(length(lambdaYTrainPredictValidate) - 1) * 0.01;
        % plot(t, lambdaYTrainPredictValidate);
        % drawnow
    % end

    %% calculate DBR
    [lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(XhatTest, W, H, Nx, Nz);
    [DBR, y] = dbr(lambdaYTrainPredictTest, spikeTrainYtest);
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
save('results\new\ANNResults.mat', 'results', 'DBRresults')
saveas(1, 'results\new\ANN1.fig')
saveas(2, 'results\new\ANN2.fig')
saveas(3, 'results\new\ANN3.fig')

clear

%% load data and import functions
path(pathdef)
addpath .\lib\ann
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

sample = 1;
transType = 3;

spikeTrainX = input{sample, 1};
spikeTrainY = outputY{sample, transType, 1};
lambdaYTrain = outputLambda{sample, transType, 1};

spikeTrainXvalidate = input{sample, 2};
spikeTrainYvalidate = outputY{sample, transType, 2};
lambdaYValidate = outputLambda{sample, transType, 2};

spikeTrainXtest = input{sample, 3};
spikeTrainYtest = outputY{sample, transType, 3};
lambdaYTest = outputLambda{sample, transType, 3};

spikeX = [spikeTrainX, spikeTrainXvalidate, spikeTrainXtest];
spikeY = [spikeTrainY, spikeTrainYvalidate, spikeTrainYtest];
trainLen = length(spikeTrainX); valLen = length(spikeTrainXvalidate); testLen = length(spikeTrainXtest);

% hyperparams
[~, H, Nz, xi1, xi2, mu, threshold, iterationThres, maxiter, alpha] = hyperParams();

% split dataset  --- by Qian
Xhat = [zeros(H+1, H-1), getXhat(spikeX, H)];
train = Xhat(:, H:trainLen);
val = Xhat(:, trainLen+1:trainLen+valLen);
test = Xhat(:, trainLen+valLen+1:trainLen+valLen+testLen);

% initial temp variables
[Nx, K] = size(spikeTrainX);
iter = 1;
LtrainHis = zeros(1, maxiter);


% initial weights
W = initialParams(H, Nx, Nz, xi1, xi2);
W = [W, zeros(length(W), maxiter-1)];

% agorithm modified from Qian
while(iter<maxiter)
  if (success)
    % forward
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(train, W(:, iter), H, Nx, Nz);
    Ltrain = logLikelyhood(spikeTrainY, lambdaYTrainPredict, (alpha*norm(W, 2)^2)/2);
    LtrainHis(iter) = Ltrain;
    disp(strcat(num2str(iter-1),'/',num2str(maxiter),'...L',num2str(Ltrain),'...mu',num2str(mu)));
    if(isnan(Ltrain))
      disp('?');
    end

    % BP
    theta = W(iter, (Nx*H+1)*Nz+1:(Nx*H+1)*Nz+Nz);
    Grad = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, train, theta, Nx, H);
    He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H);
  end

  % lm update
  

  % forward & check

  % update

  % validate

end
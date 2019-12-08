close all;clear;clc;

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
train = Xhat(:, H:trainLen); spikeTrainY = spikeTrainY(H:end); lambdaYTrain = lambdaYTrain(H:end);
val = Xhat(:, trainLen+1:trainLen+valLen);
test = Xhat(:, trainLen+valLen+1:trainLen+valLen+testLen);

% initial temp variables
[Nx, K] = size(spikeTrainX);
iter = 1;
LtrainHis = zeros(1, maxiter);
LvalHis = zeros(1, maxiter);
valConverge = 0;

% initial weights
W = initialParams(H, Nx, Nz, xi1, xi2);
W = [W; zeros(maxiter-1, length(W))];

% forward
[lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(train, W(iter, :), H, Nx, Nz);
Ltrain = logLikelyhood(spikeTrainY, lambdaYTrainPredict, (alpha*norm(W(iter, :), 2)^2)/2);
LtrainHis(iter) = Ltrain;
lambdaYVal= model(val, W(iter, :), H, Nx, Nz);
Lval = logLikelyhood(spikeTrainYvalidate, lambdaYVal, (alpha*norm(W(iter, :), 2)^2)/2);
LvalHis(iter) = Lval;
DBRval = dbr(lambdaYVal, spikeTrainYvalidate);

% agorithm modified from Qian
while(iter<maxiter)
  disp(strcat(num2str(iter-1),'/',num2str(maxiter),'...L=',num2str(Ltrain),'...mu=',num2str(mu),'...Lval=',num2str(Lval),'...DBRval',num2str(DBRval)));

  % BP
  theta = W(iter, (Nx*H+1)*Nz+1:(Nx*H+1)*Nz+Nz);
  Grad = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, train, theta) - alpha * W(iter, :);
  Hessian = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, train, theta);
  Hessian = Hessian - alpha*eye(size(Hessian));
  if (rcond(Hessian) < 1e-15 || sum(sum(isnan(Hessian))) == 1)
    disp('Error: BAD He!');
  end

  while(1)
    % lm update
    Wnew = W(iter, :) - Grad/(Hessian-mu*eye(size(Hessian)));

    % forward
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = model(train, Wnew, H, Nx, Nz);
    Lnew = logLikelyhood(spikeTrainY, lambdaYTrainPredict, (alpha*norm(Wnew, 2)^2)/2);

    % check L
    if (Lnew<Ltrain) % fail to get better L, use lm with better mu.
      if (mu < 1e7)
        % update mu
        mu = mu*1000;
        continue; % increase mu and do it again
      else
        break; % mu is too large, still go on
      end
    else
      break; % Lnew is better, nice to go on
    end
  end

  % step: Lnew is better OR mu is too Large
  iter = iter + 1;
  W(iter, :) = Wnew;
  LtrainHis(iter) = Lnew;
  % update mu
  if (Lnew>Ltrain) % for Lnew is smaller but mu is large, don't change mu
    if (mu>1e-7) % mu is not so small, change mu; if mu is small, do not change
      mu = mu/100;
    end
  end
  Ltrain = Lnew;

  % validate
  lambdaYVal= model(val, W(iter, :), H, Nx, Nz);
  LvalNew = logLikelyhood(spikeTrainYvalidate, lambdaYVal, (alpha*norm(W(iter, :), 2)^2)/2);
  if (abs(LvalNew-Lval)<threshold || LvalNew-Lval<-50) % L on validation set change too little
    valConverge = valConverge + 1;
  else
    valConverge = 0;
  end
  Lval = LvalNew;
  LvalHis(iter) = Lval;
  if (valConverge > iterationThres)
    disp('Finish: Converge on Validation Set.');
    break;
  end
  DBRval = dbr(lambdaYVal, spikeTrainYvalidate);
  figure(1)
  subplot(5,1,1);plot(LtrainHis(2:iter))
  subplot(5,1,2);plot(LvalHis(2:iter))
  subplot(5,1,3);plot(W(iter,:))
  subplot(5,1,4);plot(lambdaYVal)
  subplot(5,1,5);plot(lambdaYValidate)
  drawnow
end

% run test
[lambdaYTestPre, spikeYTestPre] = model(test, W(iter, :), H, Nx, Nz);
figure(2)
subplot(4,1,1); plot(lambdaYTestPre)
subplot(4,1,2); plot(spikeYTestPre)
subplot(4,1,3); plot(lambdaYTest)
subplot(4,1,4); plot(spikeTrainYtest)

DBR = dbr(lambdaYTestPre(1:1500), spikeTrainYtest(1:1500));
DBR = DBR + dbr(lambdaYTestPre(751:2250), spikeTrainYtest(751:2250));
DBR = DBR + dbr(lambdaYTestPre(1501:3000), spikeTrainYtest(1501:3000));
DBR = DBR + dbr(lambdaYTestPre(2251:3750), spikeTrainYtest(2251:3750));
DBR = DBR + dbr(lambdaYTestPre(3001:4500), spikeTrainYtest(3001:4500));
DBR = DBR + dbr(lambdaYTestPre(3751:5250), spikeTrainYtest(3751:5250));
DBR = DBR + dbr(lambdaYTestPre(4501:6000), spikeTrainYtest(4501:6000));
DBR = DBR/7;
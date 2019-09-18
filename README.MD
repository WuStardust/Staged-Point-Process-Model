# Nonlinear Modeling of Neural Interaction for Spike Prediction Using the Staged Point Process Model
---
## 1. Description
This project is wrote for simulating the papper *Nonlinear Modeling of Neural Interaction for Spike Prediction Using the Staged Point Process Model*.

## 2. File Tree
/  
│  generateData.m     ```generate data for train and test```  
│  main.m     ```train and test```  
│  NECO-12-17-3034-PDF.pdf  ```The original paper```  
│  README.MD  ```This file```  
└─lib  ```functions for simulation```  
　　├─generateSpikes  ```synthetic data```  
　　│　　　inputSpike.m  
　　│　　　lambda2Spike.m  
　　│　　　transferLiner.m  
　　│　　　transferQuadratic.m  
　　│　　　transferSinusoidal.m  
　　├─optimize  ```optimize the model```  
　　│　　　gradient.asv  
　　│　　　gradient.m  
　　│　　　logLikelyhood.m  
　　└─stagedPointProcess  ```staged point process model```  
　　　　　　firstLayer.m  
　　　　　　model.m  
　　　　　　secondLayer.m  
　　　　　　sigmaFunc.m  

## 3. Process
* Run the ```./generateData.m``` can generate given pairs of train set and test set.  
* Run the ```./main.m``` can build the staged point process model, optimize the log-likelihood function by gradient ascent, and Assess Goodness-of-fit.  
* I meet problem when calculating the gradient following the **equation (10)**. So the ```main.m``` can't run as my wish.
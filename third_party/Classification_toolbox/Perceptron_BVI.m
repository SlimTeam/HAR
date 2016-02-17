function [test_targets, a] = Perceptron_BVI(train_patterns, train_targets, test_patterns, params)

% Classify using the batch variable increment Perceptron algorithm
% Inputs:
% 	train_patterns	- Train patterns
%	train_targets	- Train targets
%   test_patterns   - Test  patterns
%	param		    - [Num iter, Convergence rate]
%
% Outputs
%	test_targets	- Predicted targets
%   a               - Perceptron weights
%
% NOTE: Works for only two classes.
%
%See also LS, Perceptron, Perceptron_Batch, Perceptron_FM, Perceptron_VIM, Perceptron_Voted
%
%Example:
% load clouds
% t = Perceptron_BVI(patterns, targets, patterns, [1000 0.01]);
% disp(mean(t == targets))

[c, n]		    = size(train_patterns);
[Max_iter, eta]	= process_params(params);

train_patterns  = [train_patterns ; ones(1,n)];
train_zero      = find(train_targets == 0);

%Preprocessing
y               = train_patterns;
y(:,train_zero) = -y(:,train_zero);
a               = sum(y')';

%Initial weights
iter  	        = 0;
Yk				= [1];

while (~isempty(Yk) & (iter < Max_iter))
   iter = iter + 1;
   
   %If y_j is misclassified then append y_j to Yk
   Yk = [];
   for k = 1:n,
      if (a'*train_patterns(:,k).*(2*train_targets(:,k)-1) < 0),
         Yk = [Yk k];
      end
   end
   
   % a <- a + eta*sum(Yk)
   a = a + eta * sum(y(:,Yk), 2);
end

if (iter == Max_iter),
   disp(['Maximum iteration (' num2str(Max_iter) ') reached']);
end

%Classify test patterns
test_targets = a'*[test_patterns; ones(1, size(test_patterns,2))] > 0;
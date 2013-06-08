function Weights=isa_est(Z, V, n, subspacesize, spatial_size, temporal_size, basis_filename, V_l1l2)

% This code is adapted from Natural Image
% Statistics (Hyvärinen, Hurri, Hoyer, 2009)

% Z                      : whitened data
%
% n = 60..windowsize^2-1 : number of linear components to be estimated
%                          (must be divisible by subspacesize)
%
% subspacesize= 2...10   : subspace size 


%------------------------------------------------------------
% Initialize algorithm
%------------------------------------------------------------

%create matrix where the i,j-th element is one if they are in same subspace
%and zero if in different subspaces
ISAmatrix=subspacematrix(n,subspacesize);
ISAmatrix = ISAmatrix(1:subspacesize:end,:);

%create random initial value of Weights, and orthogonalize it
Weights = orthogonalizerows(randn(n,size(Z,1))); 

%read sample size from data matrix
N=size(Z, 2);

%Initial step size
mu = 1;

%------------------------------------------------------------
% Start algorithm
%------------------------------------------------------------

writeline('Doing ISA. Iteration count: ')

iter = 0;
notconverged = 1;

obj = [];

while notconverged && (iter < 2000) %maximum of 2000 iterations

  iter=iter+1;
  
  %print iteration count
  writenum(iter);
  if mod(iter, 20)==0
      fprintf('\n');
  end


  %-------------------------------------------------------------
  % Gradient step for ISA
  %-------------------------------------------------------------  

    % Compute separately estimates of independent components to speed up 
    Y=Weights*Z; 
    
    %compute energies of subspaces
    K=ISAmatrix*Y.^2;
    
    % This is nonlinearity corresponding to generalized exponential density
    % (note minus sign)
    epsilon=0.0001;
    gK = -(epsilon+K).^(-0.5);
    
    % Store the objective function value
    obj = [obj sum(sum(sqrt(epsilon+K)))];

    % Calculate product with subspace indicator matrix
    F=ISAmatrix'*gK;
    
    % This is the basic gradient
    grad = (Y.*F)*Z'/N;

    % project gradient on tangent space of orthogonal matrices (optional)
    grad=grad-Weights*grad'*Weights;

    %store old value
    Weightsold = Weights;

    % do gradient step
    Weights = Weights + mu*grad;

    % Orthogonalize rows or decorrelate estimated components
    Weights = orthogonalizerows(Weights);

    % Adapt step size every step, or every n-th step? remove this?
    if rem(iter, 1)==0 || iter==1

        %How much do we want to change the step size? Choose this factor
        changefactor=4/3;

        % Take different length steps
        Weightsnew1 = Weightsold + 1/changefactor*mu*grad;
        Weightsnew2 = Weightsold + changefactor*mu*grad;
        Weightsnew1=orthogonalizerows(Weightsnew1);
        Weightsnew2=orthogonalizerows(Weightsnew2);
      
        % Compute objective function values
        J1=-sum(sum(sqrt(epsilon+ISAmatrix*(Weightsnew1*Z).^2)));
        J2=-sum(sum(sqrt(epsilon+ISAmatrix*(Weightsnew2*Z).^2)));
        J0=-sum(sum(sqrt(epsilon+ISAmatrix*(Weights*Z).^2)));

        % Compare objective function values, pick step giving minimum
        if J1>J2 && J1>J0
	        % Take shorter step because it is best
	        mu = 1/changefactor*mu;
            Weights=Weightsnew1;
        elseif J2>J1 && J2>J0
	        % Take longer step because it is best
	        mu = changefactor*mu;
            Weights=Weightsnew2;
        end
    end

    if mod(iter, 50) == 0
        clear('isanetwork');
        isanetwork{1}.W = Weights*V;
        isanetwork{1}.A = pinv(isanetwork{1}.W);
        isanetwork{1}.H = ISAmatrix;
        isanetwork{1}.V = V;
        
        if exist('V_l1l2', 'var')
            isanetwork{1}.V_l1l2 = V_l1l2;
        end
        
        isanetwork{1}.group_size = subspacesize;
        isanetwork{1}.temporal_size = temporal_size;
        isanetwork{1}.spatial_size = spatial_size;        
        isanetwork{1}.iters = iter;
        isanetwork{1}.obj = obj;
        save(basis_filename, 'isanetwork', '-v7.3');
    end
    
    %check convergence
    if iter > 200 && obj(iter) / obj(iter - 50) >= 0.999
        notconverged = 0;
    end

end %of gradient iterations loop

end

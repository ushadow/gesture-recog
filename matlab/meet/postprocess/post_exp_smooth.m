function prediction = post_exp_smooth( prediction, alpha ) 
    if iscell(prediction.train)
        prediction.train = cellfun(@(x) exp_smooth(x,alpha), prediction.train, 'UniformOutput', false);
        prediction.devel = cellfun(@(x) exp_smooth(x,alpha), prediction.devel, 'UniformOutput', false);
        prediction.test = cellfun(@(x) exp_smooth(x,alpha), prediction.test, 'UniformOutput', false); 
    else
        prediction.train = exp_smooth(prediction.train,alpha);
        prediction.devel = exp_smooth(prediction.devel,alpha);
        prediction.test  = exp_smooth(prediction.test,alpha);
    end
end

function y = exp_smooth( x, alpha )     
    y(1) = x(1);
    for i=2:numel(x)
        y(i) = alpha*x(i) + (1-alpha)*(y(i-1));
    end
    y = reshape(y,size(x));
end

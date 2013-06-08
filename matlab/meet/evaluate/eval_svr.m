function r = eval_svr( Y, prediction, params )
% R = eval_svr(Y,R,params)
%

    metric = params.evaluate_metric;

    if ~iscell(Y.train)        
        r.train = evaluate(Y.train, prediction.train, metric);
        r.devel = evaluate(Y.devel, prediction.devel, metric);
        r.test  = evaluate(Y.test, prediction.test, metric);
    else
        for i=1:numel(Y.train)
            rs.train(i) = evaluate(Y.train{i}, prediction.train{i}, metric);
            rs.devel(i) = evaluate(Y.devel{i}, prediction.devel{i}, metric);
            rs.test(i) = evaluate(Y.test{i}, prediction.test{i}, metric);
        end
        for i=1:numel(metric)
            switch metric{i}
                case 'corrcoef'
                    r.train.corrcoef = [rs.train.corrcoef];
                    r.devel.corrcoef = [rs.devel.corrcoef];
                    r.test.corrcoef = [rs.test.corrcoef];
                    r.train.mean_corrcoef = mean(r.train.corrcoef);
                    r.devel.mean_corrcoef = mean(r.devel.corrcoef);
                    r.test.mean_corrcoef = mean(r.test.corrcoef);
            end
        end
    end

    r;
end

function r = evaluate(Ytrue, Ystar, metric)
    for i=1:numel(metric)
        switch metric{i}
            case 'corrcoef'
                r.corrcoef = cross_correlation_coeff(Ytrue,Ystar);
            otherwise
                error('%s is not supported in svr\n',metric{i});
        end
    end
end

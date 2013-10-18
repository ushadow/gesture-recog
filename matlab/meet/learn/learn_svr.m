function R = learn_svr( Y, X, params )     

    cell_input = iscell(X.train);
    if cell_input
        [I.train, X.train, Y.train] = seq2inst(X.train,Y.train);
        [I.devel, X.devel, Y.devel] = seq2inst(X.devel,Y.devel);
        [I.test, X.test, Y.test] = seq2inst(X.test,Y.test);
    end   
    
    % Train model
    [model, t] = svr_train( Y.train, X.train, params );
        
    % Test model
    if isfield(params,'test_on_train') && params.test_on_train
        prediction.train = svr_test( Y.train, X.train, model );
        if cell_input,
            prediction.train = inst2seq(I.train,prediction.train);
        end
    end
    [prediction.devel, s1] = svr_test( Y.devel, X.devel, model );    
    [prediction.test, s2] = svr_test( Y.test, X.test, model );   
    
    if cell_input,
        prediction.devel = inst2seq(I.devel,prediction.devel);
        prediction.test = inst2seq(I.test,prediction.test);
    end
    
    % Log duration of each process
    time.train = t;
    time.devel = s1.time;
    time.test = s2.time;
    
    % Construct output R    
    R.model = model;
    R.prediction = prediction;
    R.time = time;
    R.params = struct();
    for i=1:numel(params.validate_params)
        field = params.validate_params{i};
        R.params = setfield(R.params, field, getfield(params, field));
    end    
end
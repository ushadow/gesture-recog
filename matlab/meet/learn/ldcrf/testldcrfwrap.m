function R = testldcrfwrap(Y, X, model, ~)
llTr = testLDCRF(model.model, X.Tr, makehcrflabel(Y.Tr));
R.Tr = mostlikelylabel(llTr);
llVa = testLDCRF(model.model, X.Va, makehcrflabel(Y.Va));
R.Va = mostlikelylabel(llVa);
end

function label = mostlikelylabel(ll)
  label = cellfun(@(x) maxindex(x), ll, 'UniformOutput', false);
end

function index = maxindex(ll)
[~, index] = max(ll);
end
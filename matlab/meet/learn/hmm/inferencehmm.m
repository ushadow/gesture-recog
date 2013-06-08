function cm = inferencehmm(Y, X, hmm, param)

nclass =  param.vocabularySize;
dataType = fields(Y);
hmm = hmm.model;
for t = 1 : length(dataType)
  XByClass = segmentbyclass(Y.(dataType{t}), X.(dataType{t}), nclass);
  cm = inference(XByClass, hmm, nclass);
end
end

function cm = inference(data, hmm, nclass)
cm = zeros(nclass);
error = 0;
n = 0;
for truth = 1 : length(data)
  examples = data{truth};
  maxLL = -inf;
  pred = 0;
  for i = 1 : length(examples)
    n = n + 1;
    for c = 1 : nclass
      ll = mhmm_logprob(examples{i}, hmm.prior{c}, hmm.transmat{c}, ...
                        hmm.mu{c}, hmm.Sigma{c});
      if (ll > maxLL)
        maxLL = ll;
        pred = c;
      end
    end
    cm(truth, pred) = cm(truth, pred) + 1;
    error = error + (truth ~= pred);
  end
end

cm
errorRate = error / n

end
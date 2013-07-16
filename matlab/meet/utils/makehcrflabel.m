function label = makehcrflabel(label)
label = cellfun(@(x) x(1, :), label, 'UniformOutput', false);
end
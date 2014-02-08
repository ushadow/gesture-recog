function savevariable(filename, vname, v)
%% SAVEVARIABLE saves variable into a .mat file.

matobj = matfile(filename, 'Writable', true);
matobj.(vname) = v;
end
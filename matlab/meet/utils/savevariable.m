function savevariable(filename, vname, v)
matobj = matfile(filename, 'Writable', true);
matobj.(vname) = v;
end
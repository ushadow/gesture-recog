direc = dir([data_dir '/devel*']); 
direc = [direc; dir([data_dir '/valid*'])]; 
direc = [direc; dir([data_dir '/final*'])]; 
str = {direc.name};
[s,OK] = listdlg('PromptString','Select a batch:',...
                      'SelectionMode','single',...
                      'ListString',str);
if ~OK, 
    fprintf('You did not select anything, bye!\n'); 
    return;
else

    if exist('D')
        delete(D);
    end

    % Create a databatch object called "D"
    D=databatch([data_dir '/' direc(s).name]);

    % Create a recognizer
    if use_recog
        Dtr=subset(D, 1:D.vocabulary_size);
        recog_options={'test_on_training_data=0', ['movie_type=''K''']};
        [tr_resu, RK]=train(basic_recog(recog_options), Dtr);
        recog_options={'test_on_training_data=0', ['movie_type=''M''']};
        [tr_resu, RM]=train(basic_recog(recog_options), Dtr);
        if strcmp(display_mode, 'K')
            R=RK;
        else
            R=RM;
        end
    else
        R=[];
    end

    % Show a movie
    show(D, display_mode, h, R);
end
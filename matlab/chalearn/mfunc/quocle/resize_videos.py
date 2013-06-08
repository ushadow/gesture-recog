
import sys
import os
import commands

video_path = ''
orig_video_path = video_path + 'AVIClipstest/';

#default to Hollywood2 dataset: starting with half size, resize by a factor of 1/sqrt(2)
sizes = ['0.5'];

for size in sizes:

    files = os.listdir(orig_video_path)
    m = len(files)
    counter = 0
    new_folder_name = 'AVIClipstest'+'0'+size[2]+'/'
    os.system('mkdir '+video_path+new_folder_name)

    for file in files:
        counter = counter + 1;
        old_file = orig_video_path + file
        
        new_file = video_path + new_folder_name + file
        print "working on video " + str(counter) + " out of " + str(m) + " videos in total"
        command = 'ffmpeg -i ' + old_file
        line = commands.getoutput(command)
        tokens = line.split()
        found = 0;
        print command
        for token in tokens:
            if 'x' in token and 'Header' not in token:
                print token
                tks = token.split('x')
                if tks[0].isdigit() and tks[1].isdigit():
                    w = eval(tks[0])
                    h = eval(tks[1])
                    found = 1;
                    break
        if not found:
            print "something wrong with file " + file
            print line
        print w, h
        command = 'ffmpeg -i ' + old_file + ' -s '+str(int(w*float(size)))+'x'+str(int(h*float(size))) + ' ' + new_file
        #print command
        commands.getoutput(command)

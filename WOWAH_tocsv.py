# -*- coding: utf-8 -*-
"""
Created on Thu May 12 16:50:42 2016

@author: morgan
"""



# PACKAGES
import csv
import re
import os           # This is for os.listdir
import os.path      # This is for the other dir stuff.
import string       # Maybe for directory name cycling etc.
import time			# For timing how long it takes.

# VARIABLES
max_char = 0		# Tracks char ID for error testing.
max_guild = 0		# Tracks guild ID for error testing.s
mfc = 0				# Tracks how many little files were counted.
write_data_loc = "C:\\wowah"       	     						# Adjust to your dir as needed.
write_data_file = '/wowah_data_timecharguildlevelraceclass.csv'
write_data_filename = write_data_loc + write_data_file
the_dir = "C:\\wowah\\WoWAH\\"								# This is where the WoWAH folders are located, adjust as needed. Have them in their own subdir.

#REGEX
line_re = re.compile(r'^.*"[\d+],\s(.*),\s(\d+),(\d+),\s?(\d*),\s(\d+),\s(\w+),\s(\w+),.*".*$')
#                          dummy   time    seq  char   guild    level     race   class   


# FUNCTIONS

def get_subdirs(the_folder):
    this_list = []
    this_list = os.listdir(the_folder)
    print 'From get_subdirs, a list is: ', this_list      # Printing for error control.
    for item in this_list:
        if item.startswith('.'):
            this_list.remove(item)
    return(this_list)
# End of get_subdirs
# '.DS_Store'


def get_file_list(the_folder):				
    this_list = []
    this_list = os.listdir(the_folder)
    for item in this_list:
        if item.startswith('.'):
            this_list.remove(item)
    return(this_list)
# End of get_file_list


def parse_and_write(file, output_file):
    for line in file:                          
#       print 'A line is: ', line
        data = line_re.match(line)
        if data is not(None):
            timestamp = data.group(1)
            char = data.group(3)
            Level = data.group(5)
            RaceInGame = data.group(6)
            classInGame = data.group(7)
            if data.group(4) is not(''):
                guild = data.group(4)
            else:
                guild = '-1'   # Note there are some missing values, i.e. errant -1.
            print timestamp    # This is so you can keep track of where it is. Max Jan 2009 IIRC.
            

            #zoneInGame = data.group(8)

            new_line = char + ',' + guild + ',' + timestamp + ',' + Level + ',' + RaceInGame + ',' + classInGame +'\n'
            output_file.write(new_line)
                
        else:
            print "Didn't match the regex."




def read_tree(output_file):
    global the_dir
    months_folders = get_subdirs(the_dir)		
    for folder in months_folders:                                   
        folder = the_dir + folder                                   
        day_folders = get_subdirs(folder)
        for day_folder in day_folders:
            day_folder = folder + '/' + day_folder
            file_list = get_file_list(day_folder)
            for file in file_list:
                try:
                    file = day_folder + '/' + file
                    with open(file, 'r') as f:
                        this_file = f.readlines()                          
                        parse_and_write(this_file, output_file)
                except IOError:
                    print 'Error opening hoped for data-text file,', str(file), ', reason: ', IOError
# End of read_tree


def main():	
    #open write file here
    output_file = open(write_data_filename, 'a')    
    fieldnames = ('char, guild, timestamp, level, RaceInGame, classInGame\n')
    output_file.write(fieldnames)
    start_time = time.time()
    read_tree(output_file)
    #close write file here
    output_file.close()
    spent_time = time.time() - start_time
    mins_spent = int(spent_time / 60)
    secs_remainder = int(spent_time % 60)
    print 'Time of process: ', mins_spent, ':', secs_remainder     

main()

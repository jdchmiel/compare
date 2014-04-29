compare
=======
This is a script for my own use that you may freely do whatever you want with.  It is a work in progress
that may or may not be updated as my needs change.  The purpose is to create PNG images of all HTML files in two comparison directories.
If filenames are the same, a 3rd image is created that is the difference in the images.



install dependencies
=======
My install was similar to as follows:
sudo apt-get install Xvfb
sudo apt-get install firefox
sudo apt-get install imagemagick

imagemagick was already installed. 

initial setup
===========
ssh -X server  
firefox &

run firefox to view it locally and answer the initial provide feedback questions so the pop up does not appear in images later.
in firefox open about:config and set browser.link.open_newwindow to 1 (http://forums.mozillazine.org/viewtopic.php?f=38&t=1648545)


sample usage:

./vc.sh /home/me/FolderA /home/me/FolderB /home/me/FolderOut






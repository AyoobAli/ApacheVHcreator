### Apache Virtual Host Creator

This is a bash file I created for my own use to easily create/delete Apache VirtualHost directory and configuration file.

Usage:
To create a new VirtualHost:
```bash
$ sudo ./vhostCreate.sh Username DomainName [reload]
```
reload, will restart Apache service after creating the VirtualHost (Optional).

To Delete a VirtualHost;
```bash
sudo ./vhostDelete.sh Username [reload]
```
Deleting a VirtualHost will delete ALL user files, log, configurations, etc...

To edit the default configuration file or the index.html file, edit the two variables `scrConfTxt` and `scrIndexFile` in `vhostCreate.sh` file.
And make sure you have the correct path to the `www` and `sites-available` dir in both bash files.


*__Important NOTE:__* If you're not sure what is this, then please ***DON'T*** use it. Use at your own risk, you might delete your data using the `vhostDelete.sh` wrongly. I didn't create this with security in mind as I made it for my own use.

There are lot of things to improve, like checking the username so you don't accidentally delete system files. Not sure if I'll have the time to do it.

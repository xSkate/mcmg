# mcmg.sh

Don't run as root.

## Depends on
- jre
- screen
- sed
- curl
- wget

## Variables
Change these before running the script. If you run another instance of this script without conflicting name and mcdir, all functions should work for each.
- mcdir - The directory where your server will exist. Directory does not already have to exist.
- name - Name of your server. Only matters if you run more than one instance.
- mem - Amount of memory (in MB) to allocate. 1024 by default
- mcver - Minecraft version. 1.16.4 by default.
- buildurl - Build of Minecraft server to use. Paper set by default, but could be changed.

## Arguments
- start
- stop
- restart
- update
- upgrade
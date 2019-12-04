TODO
====

TODOs will be separated by date in that they are add to better
visualize how long it is in the list.

Maybe keep the fixed ones in another list to keep a tracking.

##### Qua Ago 10 16:37:37 BRT 2016

- Add git submodules for repos that are needed, like tmux-resurrect or
  urxvt-resize-font

##### Fri Oct 25 14:45:27 BRST 2013

- Refactore of files in root of cfg dir.
- Change 'cfg/X' to 'cfg/x'.
- Maybe refactore folders in cfg dir. dei may be the root folder
  of a program config files and folders and not the folder that is
  in $HOME as a hidden one.
- Create a config.sh script or a Makefile to check and install all
  the configurations in the user home. Put some choices as to
  replace existing files or not, check if there is local
  modifications in the existing files, create or not symlinks and
  put all files inside ".config" folder.


##### Mon Nov 11 21:12:50 BRST 2013

- Unify/Integrade 'autostart.sh' & 'delayinit.sh' & 'initx.sh' & (maybe)
  '.config/autostart' folder.
  Would be nice that 'autostart.sh' caled 'initx.sh' or both called a session
  setter so that no work was done in both places and we could call openbox from
  'initx.sh' in console or from lightdm in ubuntu.
  One aternative is 'initx.sh' do not run the X/WinManager part conditionaly.
  OBS: 'delayinit.sh' is in ref to remind of how it should work and it have
  some unique lines not present in 'autostart.sh' and 'initx.sh'.
- Also, complementing the above, two monitor setup should work in all
  resolutions setup xD


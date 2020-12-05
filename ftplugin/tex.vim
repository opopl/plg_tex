
if exists("b:did_tex_tex_ftplugin")
  finish
endif
let b:did_tex_tex_ftplugin = 1

call base#buf#start()

call tex#init()

"""ftplugin_tex
"""ftp_tex_tex

call tex#buff#start()
call tex#buff#setmaps()

call base#stl#set('tex')

KEYMAP russian-jcukenwin



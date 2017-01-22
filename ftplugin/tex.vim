
if exists("b:did_tex_tex_ftplugin")
  finish
endif
let b:did_tex_tex_ftplugin = 1

call base#buf#start()

"""ftplugin_tex

call tex#buff#start()
call tex#buff#setmaps()

call base#stl#set('tex')

KEYMAP russian-jcukenwin



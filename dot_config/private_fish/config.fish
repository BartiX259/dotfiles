set fish_greeting
function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s%s%s $ ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end
if status is-interactive
    # Commands to run in interactive sessions can go here
end
bind \cH backward-kill-word #ctrl+backspace
bind \e\[3\;5~ kill-word #ctrl+delete
bind \e\[3\;3~ kill-word #alt+delete
#function file_manager
#  lfcd
#  commandline -f repaint
#end
function editor
    $EDITOR "$argv"
end
alias e='$EDITOR'
#bind \cj file_manager
bind \cn editor

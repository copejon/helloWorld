# Author.: Ole J
# Date...: 23.03.2008
# License: Whatever

# Wraps a completion function
# make-completion-wrapper <actual completion function> <name of new func.>
#                         <command name> <list supplied arguments>
# eg.
#     alias agi='apt-get install'
#     make-completion-wrapper _apt_get _apt_get_install apt-get install
# defines a function called _apt_get_install (that's ) that will complete
# the 'agi' alias. (complete -F _apt_get_install agi)
#
function make-completion-wrapper () {
    local function_name=""
    local arg_count=-3
    local comp_function_name=""
    shift 2
    local function="
function  {
    ((COMP_CWORD+=))
    COMP_WORDS=( "" ${COMP_WORDS[@]:1} )
    ""
    return 0
}"
    eval ""
    echo 
    echo ""
}

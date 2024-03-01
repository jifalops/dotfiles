alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias git-log="git log --graph --all --decorate --oneline"
# --no-pager
# --pretty=format:'%h%x09%an%x09%ad%x09%s'"

alias flutter-generate="flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs"
alias dart-generate="dart pub run build_runner build"
alias flutter-clean="flutter clean && flutter pub get"

alias rm="trash"

alias os-info="uname -a && cat /etc/os-release"

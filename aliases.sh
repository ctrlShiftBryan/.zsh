# Easier directory navigation.
alias ~="cd ~"
# alias .="cd .."
alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias cd..="cd .." # Typo addressed.


#platform dev
alias dps="docker ps -a --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\""
alias dpsi="docker ps -a --format \"table {{.Names}}\t{{.Image}}\t{{.Status}}\""
alias yad="yarn add --ignore-engines --dev"
alias datt="docker attach --detach-keys="ctrl-c,ctrl-c""
function clearz() {
  printf "\ec\e[3J";
}

function curloop() {
  while true; do sleep 1; curl $@; echo -e '\n'$(date)'\n';done
}

function dci () {
  docker run -it -v $(pwd):/app $@ sh
}

function gcr () {
  git clone --recurse-submodules $@
}

function drmi () {
  docker rmi $(docker images --filter=reference=*$@* -q)
}

function shovel () {
  pushd ~/dev
  ./script/run shovel $@
  popd
}

function mt() {
  mix test $@
}

function mte() {
  iex -S mix test --trace $@
}

function mtw() {
  mix test.watch --stale --max-failures 1 --trace --seed 0
}

function mto() {
  iex -S mix test --only focus --trace $@
}

function ber() {
  bundle exec rspec $@
}

function berf() {
  bundle exec rspec --fail-fast $@
}

function gitbra() {
  git branch -r | grep -v HEAD | while read b; do git log --color --format="%ci _%C(magenta)%cr %C(bold cyan)$b%Creset %s %C(bold blue)<%an>%Creset" $b | head -n 1; done | sort -r | cut -d_ -f2- | sed 's;origin/;;g' | head -10
}

function gitbr() {
  git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset);%(color:yellow)%(refname:short)%(color:reset);(%(color:green)%(committerdate:relative)%(color:reset));%(authorname);%(contents:subject)' | column -t -s ';'
}

function dri() {
  docker run -it --rm $1 $2
}

function dsr {
  docker stop $1; docker rm $1
}

function drl {
  docker restart $1; docker logs -f --tail 20 $1
}

function dstop {
  docker stop $(docker ps -qa)
}

function dhalt {
  docker stop $(docker ps --filter label=net.cmmint.dev.ansible-managed -qa)
}

function dresume {
  docker start $(docker ps --filter label=net.cmmint.dev.ansible-managed -qa)
}

function dlog {
  docker logs -f --tail 20 $1
}

function gcr() {
  git clone  --recurse-submodules $@
}

function gsqa() {
  git pull
  branch=$(git branch | grep \* | cut -d ' ' -f2)
  myvar="_backup"
  backup_branch="$branch$myvar"
  git checkout -b $backup_branch
  git checkout $branch

  git checkout master
  git pull
  git checkout $branch
  git merge master
  git push
  git checkout master
  git merge --squash $branch
  git branch -D $branch
  git checkout -b $branch
  git commit
  git diff origin/$branch
  git push -fu origin $branch
}


source ~/.zsh/env.sh

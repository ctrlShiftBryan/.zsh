# Easier directory navigation.
alias ~="cd ~"
# alias .="cd .."
alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias cd..="cd .." # Typo addressed.


#platform dev
alias dps="docker ps -a --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\""
alias dpsp="docker ps -a --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Ports}}\""
alias dpsi="docker ps -a --format \"table {{.Names}}\t{{.Image}}\t{{.Status}}\""
alias yad="yarn add --ignore-engines --dev"
alias datt="docker attach --detach-keys="ctrl-c,ctrl-c""

#k8s
alias k="kubectl"
alias kgp="k get pods"

function kdelp() {
 k delete pod $POD "$@"
}

function kdp() { 
  k describe pod $POD "$@"
}

function kl() {
  k logs $POD "$@"
}

function klf() {
  k logs -f $POD "$@"
}

function ke() {
  k exec -it $POD -- /bin/sh
}

## create executable bash script
function xbash() {
  echo "" > $1
  chmod +x $1
  pbpaste >> $1
  cursor $1
}

#docker compose
function dcdu(){
  docker compose down
  docker compose up -d $@
}

function dcd(){
  docker compose down
}

function dcu(){
  docker compose up -d $@
}

function dcb(){
  docker compose build $@
}

# alias p="export POD=($1)"
function p() {
    local script_path="$HOME/.zsh/pod-set.sh"  # Adjust this path as needed
    if [[ ! -f "$script_path" ]]; then
        echo "Error: Script not found at $script_path"
        return 1
    fi
    local script_output
    script_output=$("$script_path")
    eval "$script_output"
    echo "POD variable set to: $POD"
}

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

function mtf() {
  mix test --only focus --trace $@
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

function gsqam() {
  git pull
  branch=$(git branch | grep \* | cut -d ' ' -f2)
  myvar="_backup"
  backup_branch="$branch$myvar"
  git checkout -b $backup_branch
  git checkout $branch

  git checkout main
  git pull
  git checkout $branch
  git merge main
  git push
  git checkout main
  git merge --squash $branch
  git branch -D $branch
  git checkout -b $branch
  git commit
  git diff origin/$branch
  git push -fu origin $branch
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

function cpredo() {
  cp /Users/bryanarendt/code/dynasty-nerds/$1  /Users/bryanarendt/code-dn/dynasty-nerds/$1
}

function docker_container_info() {
  echo "Fetching information for all Docker containers...\n"

  docker ps -a --format "{{.Image}}" | while read -r container_id; do
    echo "Size: $(docker image inspect $container_id --format='{{.Size}}')"
    echo "Name: $container_id"
    echo "\n---\n"
  done
}


function docker_container_info() {
  echo "Fetching information for all Docker containers...\n"
  
  docker_size_human_readable() {
    echo $1 | awk '
      function human(x) {
        s=" B  KB MB GB TB PB EB"
        split(s,v," ")
        x += 0
        for(i=1; x>=1024 && i<8; i++) x/=1024
        return sprintf("%.2f %s", x, v[i])
      }
      {print human($1)}'
  }

  docker ps -a --format "{{.ID}}|{{.Image}}|{{.Names}}" | while IFS='|' read -r container_id image_name container_name; do
    image_size=$(docker image inspect $image_name --format='{{.Size}}')
    human_readable_size=$(docker_size_human_readable $image_size)
    
    echo "Container ID: $container_id"
    echo "Container Name: $container_name"
    echo "Image: $image_name"
    echo "Image Size: $human_readable_size"
    echo "\n---\n"
  done
}

function kat() {
  IMAGE=${IMAGE:-registry.cmmint.net/platform/kat:latest}
  # Auto-update, but only check once every 48h
  [[ ! -f $HOME/.kat-update-check || $(find $HOME/.kat-update-check -type f -mtime +48h) ]] && docker pull $IMAGE && touch $HOME/.kat-update-check
  docker run -it -e "USER=${USER}" -v "${HOME}/.kube:/kube" $IMAGE "$@"
}

function katfwd() {
  # Check if namespace argument is provided
  if [ $# -ne 1 ]; then
    echo "Usage: port_forward <namespace>"
    return 1
  fi

  # Get pod name from kubectl get pods command
  pod_name=$(kubectl get pods -n "$1" -o jsonpath='{.items[0].metadata.name}')

  # Check if pod name is empty
  if [ -z "$pod_name" ]; then
    echo "No pods found in the specified namespace."
    return 1
  fi

  # Run kubectl port-forward command
  kubectl port-forward -n "$1" "$pod_name" 3314:1433
}


kat-open() {
    # Capture the output of the 'kat list' command
    local output="$(kat list)"

    # Extract the cluster name using awk to parse the specific column
    # assuming the cluster name is always in the first column of the output
    local cluster_name="$(echo "$output" | awk '/^[[:alnum:]]+-[[:alnum:]]+/ {print $1}' | head -1)"

    # If a cluster name was found, open the corresponding URL
    if [[ -n "$cluster_name" ]]; then
        open "https://readme.$cluster_name.kat.cmmaz.cloud"
    else
        echo "Cluster name not found."
    fi
}

k8c() {
  kubectl $@
}

source ~/.zsh/env.sh

# Easier directory navigation.
alias ~="cd ~"
# alias .="cd .."
alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias cd..="cd .." # Typo addressed.
alias codei="code-insiders"

#platform dev
alias dps="docker ps -a --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\""
alias dpsp="docker ps -a --format \"table {{.Names}}\t{{.ID}}\t{{.Status}}\t{{.Ports}}\""
alias dpsi="docker ps -a --format \"table {{.Names}}\t{{.Image}}\t{{.Status}}\""
alias yad="yarn add --ignore-engines --dev"
alias datt="docker attach --detach-keys=\"ctrl-c,ctrl-c\""

#k8s
alias kubectl='kubecolor'
alias k="kubectl"
alias kgp="k get pods"

function kpf() {
  k port-forward svc/$SERVICE "$@"
}

function p() {
    local script_path="$HOME/.zsh/pod-set.sh"  # Adjust this path as needed
    if [[ ! -f "$script_path" ]]; then
        echo "Error: Script not found at $script_path"
        return 1
    fi
    local script_output
    script_output=$("$script_path" pods)
    eval "$script_output"
    echo "POD variable set to: $POD"
}

function s() {
    local script_path="$HOME/.zsh/pod-set.sh"  # Adjust this path as needed
    if [[ ! -f "$script_path" ]]; then
        echo "Error: Script not found at $script_path"
        return 1
    fi
    local script_output
    script_output=$("$script_path" services)
    eval "$script_output"
    echo "SERVICE variable set to: $SERVICE"
}

function ks() {
  kubectl get services "$SERVICE" "$@"
}

function kdap() {
  echo "kubectl delete all --all --dry-run=client -o name"
  kubectl delete all --all --dry-run=client -o name
}

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

function kberc() {
  k exec -it $POD -- bundle exec rails c
}

# cmm helm
function dh() {
  cd ~/code/kubernetes
  echo "Creating namespace $1 and installing helm chart $1"
  kubectl create namespace $1
  helm upgrade --install $1 ./helm/argocd-app-charts/argocd-app-$1 --namespace $1 --set global.ingressDomain=$(kubectl config current-context).kat.cmmaz.cloud
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

function clearz() {
  printf "\ec\e[3J";
}

function curloop() {
  while true; do sleep 1; curl $@; echo -e '\n'$(date)'\n';done
}

function dci () {
  docker run -it -v $(pwd):/app $@ sh
}

function bc () {
 git checkout $BRANCH
}

function a() {
  # aider --model openai/openrouter/openai/o1-preview --architect --editor-model anthropic/claude-3-5-sonnet-20240620
  # aider --model anthropic/claude-3-5-sonnet-20240620
  aider --model openrouter/openai/o1-preview --architect --editor-model anthropic/claude-3-5-sonnet-20240620
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

# function gitbra() {
#   echo "Branch | User | Commit Msg | Age"
#   git branch -r | grep -v HEAD | while read b; do
#     git log --color --format="%C(bold cyan)$b%Creset %C(bold blue)<%an>%Creset %s %C(magenta)%cr%Creset" $b | head -n 1
#   done | sort -r | sed 's;origin/;;g' | head -10
# }

function gitbra() {
  echo "Branch | sha | Age | User | Commit Msg"
  git for-each-ref --sort=committerdate refs/heads/ --format='%(refname:short); %(objectname:short); %(committerdate:relative);%(authorname);%(contents:subject)' | \
  awk -F';' '{
    printf "%s \033[33m%s\033[0m \033[32m%s\033[0m \033[36m%s\033[0m \033[35m%s\033[0m\n", $1, $2, $3, $4, $5, $6
  }' | column -t -s ' '
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

function bs() {
  # Determine the base branch (main or master)
  if git show-ref --verify --quiet refs/heads/main; then
    BASE_BRANCH="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    BASE_BRANCH="master"
  else
    echo "Error: Neither 'main' nor 'master' branch found."
    return 1
  fi

  local timestamp=$(date +"%Y-%m-%d_%I_%M%p")
  local backup_branch="${BRANCH}_backup_${timestamp}"
  git checkout -b $backup_branch
  git checkout $BRANCH
  git merge $BASE_BRANCH
  git pull
  git checkout $BRANCH
  git merge $BASE_BRANCH
  git push
  git checkout $BASE_BRANCH
  git merge --squash $BRANCH
  git branch -D $BRANCH
  git checkout -b $BRANCH
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

function katop() {
  CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[].name}')
  URL="https://$1.$CLUSTER_NAME.kat.cmmaz.cloud/_ping"
  open $URL
}

function kato() {
  CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[].name}')
  URL="https://$1.$CLUSTER_NAME.kat.cmmaz.cloud/"
  open $URL
}

function katr() {
  CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[].name}')
  URL="https://readme.$CLUSTER_NAME.kat.cmmaz.cloud/"
  open $URL
}

function local-kat() {
  LOCAL_KAT_IMAGE=${LOCAL_KAT_IMAGE:-registry.cmmint.net/platform/local-kat:latest}
  [[ ! -f $HOME/.local-kat-update-check || -n $(find $HOME/.local-kat-update-check \
    -type f -mtime +48h) ]] && \
    docker pull $LOCAL_KAT_IMAGE && touch $HOME/.local-kat-update-check

  docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e KUBECONFIG=/kube/config \
    -v "${HOME}/.kube:/kube" \
    -v "${HOME}/.local-kat:/local-kat" \
    -e CLIENT_HOME="${HOME}" \
    "$LOCAL_KAT_IMAGE" "$@"
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

function b() {
    local script_path="$HOME/.zsh/pod-set.sh"  # Adjust this path as needed
    if [[ ! -f "$script_path" ]]; then
        echo "Error: Script not found at $script_path"
        return 1
    fi
    local script_output
    script_output=$("$script_path" git-branch)
    eval "$script_output"
    echo "BRANCH variable set to: $BRANCH"
}

source ~/.zsh/env.sh

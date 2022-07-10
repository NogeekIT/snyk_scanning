#!/usr/bin/env bash


node_version=$1 #specify node version
auth_token=$2 #snyk auth token
work_dir=$3

function install_node() {
    echo "Downloading nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    nvm_version=$(nvm --version)
    echo "nvm version: $nvm_version"
    echo

    echo "Installing nodejs..."
    nvm install $node_version
    node_version=$(node --version)
    echo "node version: $node_version"
    echo "npm version: $(npm -v)"
}

function install_snyk() {
    echo -n "Installing snyk..."
    npm install -g snyk
    echo -n "snyk version: $(snyk --version)"
}

function snyk_auth() {
    echo -n "Authenticating Snyk..."
    snyk auth $auth_token
}

function snyk_code_scan() {
    echo -n "Initiating snyk_code scan..."
    
    snyk code test $work_dir --severity-threshold=high 2>&1 | tee -a report.txt || status=$?
    echo -n $status
    case $status in
    0)
        echo -n "success, no vulns found"
        ;;

    1)
        echo -n "action_needed, vulns found"
        exit 1;
        ;;

    2)
        echo -n "failure, try to re-run the command"
        ;;

    3)
        echo -n "failure, no supported projects detected"
        ;;

    *)
        echo -n "unknown"
        ;;
    esac
}

function snyk_iac_scan() {
    snyk iac test $work_dir --severity-threshold=medium 2>&1 | tee -a iac_report.txt || status=$?
    echo -n $status
    case $status in
    0)
        echo -n "success, no vulns found"
        ;;

    1)
        echo -n "Snyk iac found issues with high or medium severity !!!"
        exit 1;
        ;;

    2)
        echo -n "failure, try to re-run the command"
        ;;

    3)
        echo -n "failure, no supported projects detected"
        ;;

    *)
        echo -n "unknown"
        ;;
    esac
}

install_node
install_snyk
snyk_auth
snyk_code_scan
snyk_iac_scan

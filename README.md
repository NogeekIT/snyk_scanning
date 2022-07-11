# snyk_scanning

Script to initiate snyk code and snyk iac scans. Usefull for initiating scan on CI/CD pipelines or agents that doesn't have node or snyk installed. 
# How to run?

./scan.sh NODE_VERSION SNYK_AUTH_TOKEN DIRECTORY_TO_SCAN

Takes in 3 arguements: 
- NODE_VERSION - specify node version to install 
- SNYK_AUTH_TOKEN - snyk authentication token - can be generated Under Account Settings from Snyk portal
- DIRECTORY_TO_SCAN - directory/code to scan



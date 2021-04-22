#!/bin/bash

# --------------------------------------------
# Options that must be configured by app owner
# --------------------------------------------
APP_NAME="topological-inventory"  # name of app-sre "application" folder this component lives in
COMPONENT_NAME="topo-api"  # name of app-sre "resourceTemplate" in deploy.yaml for this component
IMAGE="quay.io/cloudservices/topological-inventory-api"

IQE_PLUGINS="topology_inventory"
IQE_MARKER_EXPRESSION="topology_smoke"
IQE_FILTER_EXPRESSION=""

# We are checking PRs with Travis

# Need to make a dummy results file to make tests pass
mkdir -p artifacts
cat << EOF > artifacts/junit-dummy.xml
<testsuite tests="1">
    <testcase classname="dummy" name="dummytest"/>
</testsuite>
EOF

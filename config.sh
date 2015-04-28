# This file holds common parameters for the VM start/stop scripts

VM_NAME=deploy-loopback-to-gce-2
ZONE=us-central1-a
MACHINE_TYPE=n1-standard-4
PROJECT_ID=double-platform-92304

# set project globally
gcloud config set project ${PROJECT_ID}

# utility method
function wait_vm_ready() {
    VM_IP=$(gcloud compute instances describe ${VM_NAME} --format=text | grep natIP | cut -f 2 -d ':' | tr -d ' ')
    echo
    echo "Waiting for VM to be ready on ${VM_IP}."
    echo
    echo "  This will continually check to see if the guestbook is up and "
    echo "  running. If something goes wrong this could hang forever."
    echo
    until $(curl --output /dev/null --silent --head --max-time 1 --fail "http://${VM_IP}"); do
        printf "."
        sleep 2
    done

    echo
    echo "Container VM Guestbook is now up and running"
    echo
    echo "  http://${VM_IP}"
    echo
}
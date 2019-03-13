project=$(gcloud config list --format='value(core.project)')
user=$(gcloud config list --format='value(core.account)')
zone="europe-west1-b"
zone2="southamerica-east1-b"
printf -v context "gke_%s_%s_cluster-1" $project $zone
printf -v context2 "gke_%s_%s_cluster-2" $project $zone2
function join_by { local IFS="$1"; shift; echo "$*"; }
ALL_CLUSTER_CIDRS=$(gcloud container clusters list --format='value(clusterIpv4Cidr)' | sort | uniq)
ALL_CLUSTER_CIDRS=$(join_by , $(echo "${ALL_CLUSTER_CIDRS}"))
ALL_CLUSTER_NETTAGS=$(gcloud compute instances list --format='value(tags.items.[0])' | sort | uniq)
ALL_CLUSTER_NETTAGS=$(join_by , $(echo "${ALL_CLUSTER_NETTAGS}"))
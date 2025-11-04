
## Ressources
- [YAOOK Quickstart Guide](https://docs.yaook.cloud/user/guides/quickstart-guide/index.html)

## Requirements
- `kubectl`
- `helm`
- `yq`

Get all nodes
`kubectl --context workshop-11 get nodes`


Run all the needed steps until `Label the control planes` ...

## Labeling the nodes
Get all nodes `kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'`
```shell
shoot--f6e6896574--workshop-11-w-z1-85d88-4l8wf
shoot--f6e6896574--workshop-11-w-z1-85d88-7q5tb
shoot--f6e6896574--workshop-11-w-z1-85d88-9q49g
shoot--f6e6896574--workshop-11-w-z1-85d88-cmtkk
shoot--f6e6896574--workshop-11-w-z1-85d88-kll56
```
Assign three of them as control planes.
```shell 
export control_plane_nodes="shoot--f6e6896574--workshop-11-w-z1-85d88-4l8wf shoot--f6e6896574--workshop-11-w-z1-85d88-7q5tb shoot--f6e6896574--workshop-11-w-z1-85d88-9q49g"

# Need to be one line, not multiline
export ctl_plane_labels="node-role.kubernetes.io/control-plane=true any.yaook.cloud/api=true infra.yaook.cloud/any=true operator.yaook.cloud/any=true key-manager.yaook.cloud/barbican-any-service=true block-storage.yaook.cloud/cinder-any-service=true compute.yaook.cloud/nova-any-service=true ceilometer.yaook.cloud/ceilometer-any-service=true key-manager.yaook.cloud/barbican-keystone-listener=true gnocchi.yaook.cloud/metricd=true infra.yaook.cloud/caching=true network.yaook.cloud/neutron-northd=true network.yaook.cloud/neutron-ovn-agent=true"

# Remove the quotes
for node in $control_plane_nodes; do
   kubectl label node "$node" $ctl_plane_labels
done

export worker_nodes="shoot--f6e6896574--workshop-11-w-z1-85d88-cmtkk shoot--f6e6896574--workshop-11-w-z1-85d88-kll56"
for node in $worker_nodes; do
   kubectl label node "$node" $ctl_plane_labels
done
``` 
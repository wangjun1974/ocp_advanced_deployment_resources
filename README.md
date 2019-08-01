# ocp_advanced_deployment_resources

```
aws ec2 describe-instances --filters Name=vpc-id,Values=vpc-ac973bc9 --query 'Reservations[].Instances[].[PrivateIpAddress,InstanceId,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /'

aws ec2 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress,InstanceId,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /'

aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name,PrivateIpAddress,PublicIpAddress]' --output text


oc process --local \
--param-file=openshift/multi-project-templates/parameters.yml \
--ignore-unknown-parameters \
-f openshift/multi-project-templates/cakephp-mysql-frontend.yml \
| oc apply -f -


ip-10-0-50-53.us-east-2.compute.internal    Ready    worker         23h   v1.13.4+205da2b4a   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m4.large,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=us-east-2,failure-domain.beta.kubernetes.io/zone=us-east-2a,kubernetes.io/hostname=ip-10-0-50-53,node-role.kubernetes.io/worker=,node.openshift.io/os_id=rhcos,node.openshift.io/os_version=4.1,post-upi-worker=,ssd=true

ip-10-0-71-25.us-east-2.compute.internal    Ready    worker         23h   v1.13.4+205da2b4a   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m4.large,beta.kubernetes.io/os=linux,failure-domain.beta.kubernetes.io/region=us-east-2,failure-domain.beta.kubernetes.io/zone=us-east-2b,kubernetes.io/hostname=ip-10-0-71-25,node-role.kubernetes.io/worker=,node.openshift.io/os_id=rhcos,node.openshift.io/os_version=4.1,post-upi-worker=,ssd=true


    nodeAffinity: 
      requiredDuringSchedulingIgnoredDuringExecution: 
        nodeSelectorTerms:
        - matchExpressions:
          - key: e2e-az-NorthSouth 
            operator: In 
            values:
            - e2e-az-North 
            - e2e-az-South
            
            

spec:
  template:
    spec:
      affinity:
        nodeAffinity: 
          preferredDuringSchedulingIgnoredDuringExecution: 
      - preference:
          matchExpressions:
          - key: "ssd"
            operator: In
            values:
            - "true"
          - key: "failure-domain.beta.kubernetes.io/zone"
            operator: In
            values:
            - "us-east-2a"
        
spec:        
  template:        
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: ssd
                operator: In
                values:
                - "true"
              - key: failure-domain.beta.kubernetes.io/zone
                operator: In
                values:
                - us-east-2a  

spec:        
  template:        
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: failure-domain.beta.kubernetes.io/zone
                operator: In
                values:
                - us-east-2a  

spec:        
  replicas: 2
    
oc patch dc cache -p '{ "spec": { "replicas": 2 } }'    

oc patch dc cache -p '{ "spec": { "template": { "spec": { "affinity": { "nodeAffinity": { "requiredDuringSchedulingIgnoredDuringExecution": { "nodeSelectorTerms": [ { "matchExpressions": [ { "key": "failure-domain.beta.kubernetes.io/zone", "operator": "In", "values": [ "us-east-2a" ] } ] } ] } } } } } } }'




oc patch dc cache -p '{ "spec": { "template": { "spec": { "affinity": { "nodeAffinity": { "requiredDuringSchedulingIgnoredDuringExecution": { "nodeSelectorTerms": [ { "matchExpressions": [ { "key": "ssd", "operator": "In", "values": [ "true" ] }, { "key": "failure-domain.beta.kubernetes.io/zone", "operator": "In", "values": [ "us-east-2a" ] } ] } ] } } } } } } }'                
 
oc patch dc webserver -p '{ "spec": { "template": { "spec": { "affinity": { "nodeAffinity": { "requiredDuringSchedulingIgnoredDuringExecution": { "nodeSelectorTerms": [ { "matchExpressions": [ { "key": "ssd", "operator": "In", "values": [ "true" ] }, { "key": "failure-domain.beta.kubernetes.io/zone", "operator": "In", "values": [ "us-east-2b" ] } ] } ] } } } } } } }'   

oc patch dc cache -p '{ "spec": { "template": { "spec": { "affinity": { "nodeAffinity": { "requiredDuringSchedulingIgnoredDuringExecution": { "nodeSelectorTerms": [ { "key": "failure-domain.beta.kubernetes.io/zone", "operator": "In", "values": [ "us-east-2a" ] } ] } } } } } } }'

oc patch dc webserver -p '{ "spec": { "template": { "spec": { "affinity": { "nodeAffinity": { "requiredDuringSchedulingIgnoredDuringExecution": { "nodeSelectorTerms": [ { "key": "failure-domain.beta.kubernetes.io/zone", "operator": "In", "values": [ "us-east-2a" ] } ] } } } } } } }'
                
spec:
  template:
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - web
            topologyKey: "kubernetes.io/hostname"

spec:
  template:
    spec:
      tolerations:
      - key: "ssd"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
        
oc patch dc cache -p '{ "spec": { "template": { "spec": { "tolerations": [ { "key": "ssd", "operator": "Equal", "value": "true", "effect": "NoSchedule" } ] } } } }'        

oc get nodes -l node-role.kubernetes.io/worker --show-labels

    spec:
      taints:
      - key: ssd
        value: "true"
        effect: NoSchedule

oc patch nodes ip-10-0-50-53.us-east-2.compute.internal -p  '{"spec":{"taints":[{"key":"ssd","value":"true","effect":"NoSchedule"}]}}'


oc patch dc cache -p '{"spec":{"template":{"spec":{"affinity":{ "nodeAffinity":{ "requiredDuringSchedulingIgnoredDuringExecution":[{"preference":{"matchExpressions":[{"key":"ssd","operator":"In","values":["true"]},{"key":"failure-domain.beta.kubernetes.io/zone","operator": "In","values":["us-east-2a"]}]}}]}}}}}}'

```

https://labs.consol.de/development/2019/04/08/oc-patch-unleashed.html


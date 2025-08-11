
eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=quick-eks --approve

eksctl create iamserviceaccount \
    --cluster=quick-eks \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::<account-number>:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region us-west-2 \
    --approve



helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=quick-eks \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-west-2 \
  --set vpcId=<vpc-id>



helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=web-quickstart

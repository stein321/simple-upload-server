

# Overview

This is a helm chart replacement for the widgetapi docker-compose file. It was written in a way so that most of the template files can be reused for any single-container helm chart. Most of the templates were generated via the `helm create` command. From there, I added the ability to define env variables, container arguments, etc in the `values.yaml` file.  The fields in the `values.yaml` file are straightforward to overwrite however this will be deployed. 

# Steps
1. Generate a secret with the token you'd like to use for read/write. There's an example command in [secret.sh](sample-resources/secret.sh). If using a different secret name and/or key name, override the `env:` block in the values.yaml.
2. Setup a storage class on the cluster. There's example ones for docker-desktop and eks in [sample-resouces](sample-resources). I did not include this directly in the helm chart as this should be maintained as part of a separate helm chart or other deployment process. 
3. Run `helm upgrade --install <release-name> -f <value overide file(s)> ./ ` 



# Limitations
This chart as is will only work with a single replica. If this needs to be horizontally scaled out, the design and requirements should be discussed. 

# Testing
We need verify that the app's functionality works as expected. This includes: uploading a file, downloading a file, and being able to redownload the same file even after the pod restarts. This app uses ingresses which require the ingress hostname to be passed in. This is done implicitly when using DNS via a DNS service such as Route53 or even using a local hosts file. The easiest way to test an ingress without making those changes from an internet (or any cluster on your network) accessible cluster is to pass in the hostname via header . 

## Examples
Example below for using docker-desktop and localhost:
`curl -H "Host: chart-example.local" -H "Authorization: Bearer mytoken" http://localhost/upload -Ffile=@helloworld.txt`

Here's an example using eks and an application load balancer url:
`curl -H "Host: simple-upload.eks" \
    http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/upload?token=sometoken -Ffile=@helloworld.txt`

## Testing Situations 

### Test that the token setup works
1. Update the token in the secret
2. Run `helm upgrade`
3. Terminate small-helm-chart pod 
4. Wait for new pod to come up and run curl to upload/download the target file e.g. `curl -H "Host: simple-upload.eks"
    http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/upload?token=newtoken -Ffile=@helloworld.txt` 

### Test general functionality 
1. Run e.g. `curl -H "Host: simple-upload.eks"
    http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/upload?token=newtoken -Ffile=@helloworld.txt` 
2. Run e.g. `curl -H "Host: simple-upload.eks" http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/files/helloworld.txt?token=newtoken`


### Test data persistence
1. Run e.g. `curl -H "Host: simple-upload.eks"
    http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/upload?token=newtoken -Ffile=@helloworld.txt` 
2. Run e.g. `curl -H "Host: simple-upload.eks" http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/files/helloworld.txt?token=newtoken`
3. Terminate small-helm-chart pod
4. Wait for new pod to come up successfully and then run `curl -H "Host: simple-upload.eks" http://k8s-default-suploads-c386552b34-1831655315.us-west-2.elb.amazonaws.com/files/helloworld.txt?token=newtoken` to confirm that it still works.


# Included files/steps
The [sample-resources](sample-resources) folder includes setup files for both docker-desktop and eks.
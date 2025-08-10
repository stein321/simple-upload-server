

# Run






# Steps

1. `helm create small-helm-chart`
2. `helm -n nginx install nginx-ingress ingress-nginx/ingress-nginx`
3. Create kubernetes secret or pass in value to create secret 


curl -H "Host: chart-example.local" \
     -H "Authorization: Bearer mytoken" \
    http://localhost/upload -Ffile=@helloworld.txt


Testing
1. Verify token setup works
2. Verify file exists on container restart
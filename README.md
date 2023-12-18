# AWS 
CODEBUILD 

creating a pipeline using AWS 
REQUIREMENTS 
# AWS acoount 
# code commit
# Codebuild
# ECR
# Codepipeline

Created a simple java script application that prints " HELLO WORLD "
...
   " 
     const express = require('express')
const app = express()
const port = 3000
app.use(express.json())
app.get('/', (req, res) => {
  res.json({message: 'Hello CodeBuild!'})
})
let server = app.listen(port, () => {
  console.log(`jerrys app listening at http://localhost:${port}`)
})
function stop() {
  server.close();
}
module.exports = server;
module.exports.stop = stop;

...

STEPS 

# run npm init -y 
// to initialize npm. 
# npm install express 
// this is to install the express dependency for my project 

# create a dockerfile 

"
FROM node:20-alpine3.18
WORKDIR /app
COPY package*.json ./

COPY . .
RUN npm install
EXPOSE 3000
ENTRYPOINT ["node","index.js"]
"
// this is how my dockerfile for my simple application looks like 

# run docker build -t <image name>
// this command builds a docker image 

# Lod in to AWS account 

# create an ECR (Elastic Container Registry) repository 

# use the push commands to push the built image to the repository 

# create a codecommit repository

# create an IAM  user 
// this gives a user permission to access the repository 

# i would need to connect to the codecommit repository using HTTPS
// SSH means can be used as well but for the sake of the project i used HTTPS

... 
on the terminal now we would need to push our code to the codecommmit repository

# gti init 

git remote add <codecommit URL>

echo node_modules 

git push --set-upstream origin master 
// your branch can differ 

# add a buildspec.yml file to our code 
// just like a .gitlab-ci.yml and a jenkins file you have a buildspec.yml file for 
   AWS CI integration 

   ...
      "
      version: 0.2

phases:
  pre_build:
    commands:
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH}
      - REPO_URL=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME
  build:
    commands:
      - docker build -t $REPO_URL:latest .
      - docker tag $REPO_URL:latest $REPO_URL:$IMAGE_TAG
  post_build:
    commands:
      - docker push $REPO_URL:$IMAGE_TAG
      - docker push $REPO_URL:latest
      - echo "$SSH_KEY" > ~/.ssh/id_rsa
      - chmod 400 ~/.ssh/id_rsa
      - ssh -o StrictHostKeyChecking=no ubuntu@$INSTANCE "/home/ubuntu/app/deploy.sh $IMAGE_TAG"
                 ...
                 "
                 // this is my buildspec.yml file 
                 // our pipeline cant run without this file 

oncce a we start a build the pipeline starts all this stages listed above 
// we will need to add an envroment variable because i included them in the pipeline 

# ADD ENVIROMENT VARIABLES 
  
  varaibles listed 
  * AWS_DEFAULT_REGION 
  * AWS_ACCOUNT_ID
  * IMAGE_REPO_NAME 


# push the buildspec.yml to the codecommit repo

# START BUILD 

// THE WHOLE IDEA OF A PIPELINE IS THAT WHEN CODE IS BEEN PUSHED TO THE MASTER BRANCH, THE PIPELINE SHOULD BE TRIGGERED AUTOMATICALLY ... BUT I HAVE BEEN BEEN DOING THAT MANUALLY

...
 To achieve that purpose, thats where the CODEPIPELINE services comes in.

With CODEPIPELINE you can start an automated build.

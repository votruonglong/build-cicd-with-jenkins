pipeline {
    agent {
        label 'dev-server'
    }

    environment {
        SONAR_PROJECT_KEY = 'shoeshop_shoeshop_f9854c60-4e8e-441f-86a8-3b9e7c4c5e87'
        SONAR_TOKEN = credentials('token-shoeshop')
        DOCKER_HUB = 'tlong1904'
        DOCKERHUB_CREDENTIAL = credentials('dockerhub-credential')
        DOCKER_TAG = "${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
        DOCKER_NAME = 'shoeshop'
    }

    stages {
        stage('Check out source') {
            steps {
                sh(script: """ sudo cp -r . /datas/shoeshop """, label: "check out source")
            }
        }

        stage('Test with sonarqube') {
            steps {
                sh(script: """ docker login -u tlong1904 -p truonglong """, label: "login dockerhub")
                withSonarQubeEnv('Sonarqube Server Connection') {
                    sh "cd /datas/shoeshop \
                    && docker run --rm -e SONAR_HOST_URL=${env.SONAR_HOST_URL} \
                    -e SONAR_SCANNER_OPTS='-Dsonar.projectKey=$SONAR_PROJECT_KEY' \
                    -e SONAR_TOKEN=$SONAR_TOKEN \
                    -v '.:/usr/src' \
                    sonarsource/sonar-scanner-cli"
                }
            }
        }
        stage('Build and push') {
            steps {
                sh(script: """ docker login -u ${DOCKERHUB_CREDENTIAL_USR} -p ${DOCKERHUB_CREDENTIAL_PSW} """, label: "login dockerhub")
                sh(script: """ docker build -t ${DOCKER_HUB}/$DOCKER_NAME:$DOCKER_TAG . """, label: "build image")
                sh(script: """ docker push ${DOCKER_HUB}/$DOCKER_NAME:$DOCKER_TAG """, label: "push to docker hub")
            }
        }
        stage('Pull and Deploy') {
            steps {
                sh(script: """ docker login -u ${DOCKERHUB_CREDENTIAL_USR} -p ${DOCKERHUB_CREDENTIAL_PSW} """, label: "login dockerhub")
                sh(script: """ docker pull ${DOCKER_HUB}/$DOCKER_NAME:$DOCKER_TAG """, label: "pull image")
                sh(script: """ docker rm  -f $DOCKER_NAME """, label: "remove container if exist")
                sh(script: """ docker run --name $DOCKER_NAME -dp 7777:8080 ${DOCKER_HUB}/$DOCKER_NAME:$DOCKER_TAG """, label: "run image")
            }
        }
        stage('Show log') {
            steps {
                sh(script: """ sleep 20; docker logs shoeshop """, label: "login dockerhub")
            }
        }
  }
        
}


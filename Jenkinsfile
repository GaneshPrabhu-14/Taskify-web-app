pipeline {
    agent any

    tools {
        maven 'Maven 3.8.6'
    }

    options {
        skipDefaultCheckout(true)
    }

    triggers {
        githubPush()
    }

    environment {
        DOCKER_IMAGE = 'ganesha06/taskify-web-app:latest'
    }






    stages {
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn clean package -DskipTests'
                    } else {
                        bat 'mvn clean package -DskipTests'
                    }
                }
            }
        }

        stage('Selenium Tests') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('SonarQube') {
            bat 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=taskify-web-app'
                                    }
           }
        }

        stage('Docker Image Build') {
            steps {
                script {
                    if (DOCKER_IMAGE.contains('YOUR_DOCKERHUB_USERNAME') || DOCKER_IMAGE != DOCKER_IMAGE.toLowerCase()) {
                        error('Set DOCKER_IMAGE to your lowercase Docker Hub username and image name.')
                    }
                    if (isUnix()) {
                        sh 'docker build -t "$DOCKER_IMAGE" .'
                    } else {
                        bat 'docker build -t "%DOCKER_IMAGE%" .'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        if (isUnix()) {
                            sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                            sh 'docker push "$DOCKER_IMAGE"'
                        } else {
                            bat 'echo %DOCKER_PASS%| docker login -u %DOCKER_USER% --password-stdin'
                            bat 'docker push "%DOCKER_IMAGE%"'
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            junit 'target/surefire-reports/*.xml'
        }
    }
}
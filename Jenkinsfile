pipeline {
    agent {
        node {
            label 'node.js'
        }
    }

    triggers {
        pollSCM('H/1 * * * *')
    }
    
    stages {

        stage('Install Deps') {
            parallel {
                stage('Frontend Install') {
                    steps {
                        dir('client') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
                stage('Backend Install') {
                    steps {
                        dir('server') {
                            sh 'pnpm install --frozen-lockfile'
                        }
                    }
                }
            }
        }

        stage('Lint') {
            steps {
                dir('chessu') {
                    sh 'pnpm lint'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Frontend Test') {
                    steps {
                        dir('client') {
                            sh 'pnpm test'
                        }
                    }
                }
                stage('Backend Test') {
                    steps {
                        dir('server') {
                            sh 'pnpm test'
                        }
                    }
                }
            }
        }
        stage('Build') {
            parallel {
                stage('Frontend Build') {
                    steps {
                        dir('client') {
                            sh 'pnpm build'
                        }
                    }
                }
                stage('Backend Build') {
                    steps {
                        dir('server') {
                            sh 'pnpm build'
                        }
                    }
                }
            }
        }
    }
}

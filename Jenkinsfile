pipeline {
    agent any
	 options {
        disableConcurrentBuilds()
    }
    stages {
        stage('checkout validations') {
			when {
	            allOf {
				expression { BRANCH_NAME ==~ /(feature\/dwh_bi_Rel_[0-9][0-9]_.*$|dwh_bi_Rel_[0-9][0-9]|bugfix\/dwh_bi_Rel_[0-9][0-9]_.*$)/ }
				expression { BUILD_NUMBER != '1'}
				      }
				}
			steps {
                echo "checkout of scm at ${WORKSPACE}"
			    echo "Branch name is ${BRANCH_NAME}"
				echo "Build number is ${BUILD_NUMBER}"
		        bat "set PATH=C:\\Program Files\\Git\\;%PATH% && git-bash.exe C:\\Users\\admin\\git_checkouts\\checkout_validation.sh ${WORKSPACE} ${BRANCH_NAME} ${BUILD_NUMBER}"
				
				echo "checkout validation logs are as below :"
				script {
				     def validate_logs = readFile(file: 'build.log')
                     println(validate_logs)
					  def data = readFile(file: 'failure_checkout.log').trim()
                      println(data)
					  if (data == 'Y') {
                        echo 'Failed in checkout validations.. exiting'
						error "Checkout Validation Stage has failed..."
                    } else {
                        echo 'Suceeded in checkout validations.. proceeding with next stage...'
                    }
				       }
    				}
        }
        stage('packaging and artifactory push') {
			when {
	            allOf {
				expression { BRANCH_NAME ==~ /(feature\/dwh_bi_Rel_[0-9][0-9]_.*$|dwh_bi_Rel_[0-9][0-9]|bugfix\/dwh_bi_Rel_[0-9][0-9]_.*$)/ }
				expression { BUILD_NUMBER != '1' }
				      }
				}
           steps {
                echo 'running build.sh'
                bat "set PATH=C:\\Program Files\\Git\\;%PATH% && git-bash.exe C:\\Users\\admin\\git_checkouts\\artifact_processing.sh ${WORKSPACE} ${BRANCH_NAME}"
				echo "artifact logs are as below :"
				script {
				   def artifact_log = readFile(file: 'artifact.log')
                   println(artifact_log)
				}
                 }
        }
    }

    post {
        // Cleanup the workspace after build
        always {
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}

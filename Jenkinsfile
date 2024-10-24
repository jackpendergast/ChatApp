node('ubuntu-AppServer-3120')
{
 
def app
stage('Cloning Git')
{
    /* Let's make sure we have the repository cloned to our workspace */
    checkout scm
}

stage('Build-and-Tag')
{
    /* This builds the actual image; 
         * This is synonymous to docker build on the command line */
    app = docker.build('penjack/chatapp')
}
 
stage('Post-to-dockerhub')
{
    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials')
    {
        app.push('latest')
    }
}

stage('Prepare Environment') {
    // Find and stop any Docker container using port 80 or 443
    sh '''
    for PORT in 80 443; do
        CONTAINER_ID=$(docker ps -q --filter "publish=$PORT")
        if [ -n "$CONTAINER_ID" ]; then
            echo "Stopping container using port $PORT: $CONTAINER_ID"
            docker stop $CONTAINER_ID
            docker rm $CONTAINER_ID
        else
            echo "No container using port $PORT."
        fi
    done
    '''
}
 
stage('Deploy')
{
    sh "docker-compose down"
    sh "docker-compose up -d"
}
 
}

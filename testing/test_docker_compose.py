import yaml
import os

def test_docker_compose_file():
    # Load the docker-compose.yml file
    with open('docker-compose.yml', 'r') as file:
        compose_content = yaml.safe_load(file)

    # Test the version
    assert compose_content['version'] == '3'

    # Test the services
    services = compose_content['services']
    assert 'app' in services
    assert 'application-nginx' in services

    # Test the app service
    app_service = services['app']
    assert app_service['container_name'] == 'new_app'
    assert app_service['ports'] == ['8080:8080']
    assert app_service['restart'] == 'on-failure'
    assert app_service['volumes'] == ['./data:/var/www/data']
    assert app_service['depends_on'] == ['mariadb']
    assert app_service['networks'] == ['fullstack']

    # Test the application-nginx service
    nginx_service = services['application-nginx']
    assert nginx_service['image'] == 'nginx:alpine'
    assert nginx_service['container_name'] == 'application-nginx'
    assert nginx_service['restart'] == 'always'
    assert nginx_service['tty'] is True
    assert nginx_service['environment'] == ['APPLICATION_UPSTREAM=application-backend:9001']

if __name__ == "__main__":
    test_docker_compose_file()
    print("All tests passed!")
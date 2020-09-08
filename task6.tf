provider "aws" {
	region = "ap-south-1"
	profile = "nileshmathur"                  #Specifying AWS as provider         

}
#######################################################################################
resource "aws_db_instance" "mysql_db"{
    allocated_storage=20
    storage_type="gp2"
    engine="mysql"
    engine_version="5.7.30"
    instance_class="db.t2.micro"                   #Creating MySQL Database using RDS
    identifier="mysql"
    name="mydb"
    username="nileshmathur"
    password="mypassword"
    parameter_group_name="default.mysql5.7"
    auto_minor_version_upgrade=true
    publicly_accessible=true
    port="3306"
    vpc_security_group_ids=["sg-01dc1de8f00cbcbfc"]          
    skip_final_snapshot=true

}
###############################################################################################################
provider "kubernetes"{
    config_context_cluster="minikube"              #Specifying Kubernetes as provider for WordPress container         

}
################################################################################################################
resource "kubernetes_service" "wordpress_service"{
    metadata{
        name="wordpress-service"
    }
    spec{
        selector={
            app="wordpress_site"
        }
        
        port{
            node_port=32000
            port=8080
            target_port=80
        }
        type="NodePort"
    }
}
###############################################################################################################
resource "kubernetes_deployment" "wordpress"{
    metadata{
        name="wordpress"
        
    }
    spec{
        replicas=1
        selector{                                        #Deploying WordPress container
            match_labels={
                app="wordpress_site"
            }
        }
        template{
            metadata{
                labels={
                    app="wordpress_site"
                }
            }
            spec{
                container{
                    image="wordpress"
                    name="wordpress_container"
                    port{
                        container_port=80
                    }
                }
            }
        }
    }
}
#########################################################################################

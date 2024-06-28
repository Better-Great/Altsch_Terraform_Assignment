# Terraform Static Website Infrastructure
## Project Summary 
This project sets up a reliable, secure, and efficient infrastructure for hosting a static website for Tween-gency using AWS services. It uses services like S3 bucket for storage, CloudFront for fast global content delivery, API Gateway for accessing static content via APIs, and IAM for managing permissions. Terraform is used to manage and automate the setup.

The goal is to create an easy-to-manage infrastructure that supports quick deployment and updates for the website. The design ensures high availability, fast content delivery, and robust security, making it simple to update and manage website content.

### Root Directory Configuration
### main.tf
This file serves as the entry point for our Terraform configuration, orchestrating all the modules:

1. S3 Bucket Module:
    - Creates and configures the S3 bucket for storing website content
    - Uses variables for bucket name and environment

2. CloudFront Module:
    - Sets up a CloudFront distribution for content delivery
    - Depends on the S3 bucket module
    - Uses outputs from the S3 module for configuration

3. IAM Module:
    - Creates necessary IAM roles and policies
    - Uses the S3 bucket ARN for permissions

4. API Gateway Module:
    - Configures API Gateway for accessing S3 content
    - Uses outputs from S3 and IAM modules

*Note: The Route53 module is commented out, indicating it's optional or for future use.*

### variables.tf
Defines the input variables for the root module:
- AWS region (`default: us-east-1`)
- S3 bucket name (`default: tween-gency-12345`)
- Environment (`default: dev`)
- Domain name (optional, for future use)

### outputs.tf
Specifies the outputs from the root module, including:
- S3 bucket ID, ARN, name, and website endpoint
- CloudFront distribution domain name

These outputs provide essential information for managing and accessing the deployed infrastructure.

### init.tf
Sets up the Terraform configuration:
- Specifies required Terraform version
- Defines required AWS provider version
- Configures the AWS provider with the specified region

### data.tf
Fetches dynamic data from AWS:
- Current AWS account information
- Available AWS availability zones in the region

This data can be used throughout the Terraform configuration for dynamic resource creation and configuration.

## S3 Bucket Module
### Purpose:
The s3_bucket module is responsible for creating an Amazon S3 bucket. This bucket was used to create and upload the files for the static website for Tween-gency. 

#### Files in this module:
- `main.tf`: In this file, the required script for the primary configuration in creating the S3 bucket and enabling hosting for a static website was done.
- `variables.tf`: Defines the variables used in the module, allowing customization of the bucket's settings without modifying the module code.
- `outputs.tf`: Specifies the outputs of the module, making important values available for use in other parts of the Terraform configuration.
- `s3-bucket.md`: Explains what the files and configurations in this directory is doing.
- `website`: This is the directory containing all the files for the website, we intent to upload to the s3 bucket.  

#### Key components:

- **Main resource**: aws_s3_bucket
- **Website configuration**: aws_s3_bucket_website_configuration
- **Versioning**: aws_s3_bucket_versioning
- **Public access block**: aws_s3_bucket_public_access_block
- **CORS configuration**: aws_s3_bucket_cors_configuration
- **Files upload**: aws_s3_object   

#### How to use it:

1. Specify a unique bucket name
2. Provide your website files
3. Set the environment (e.g., "dev" or "prod")

The module outputs important information like the bucket name, ARN, and website endpoint for use in other parts of your infrastructure.

## CloudFront Module
In this module, I've set up Amazon CloudFront to work with our S3 bucket, creating a content delivery network for our static website. Here's what I've implemented:

#### Key Components
1. **Origin Access Identity (OAI)** I created an Origin Access Identity for CloudFront. This acts as a special CloudFront user, allowing it to access our S3 bucket.
2. **CloudFront Distribution**  I set up the main CloudFront distribution, which is the core of our content delivery network.
3. **S3 Bucket Policy**  I implemented a policy that allows our CloudFront distribution to access the S3 bucket.

#### What This Module Does

- Creates a CloudFront distribution that points to our S3 bucket
- Sets up HTTPS/HTTP for content delivery
- Implements caching behaviors to improve performance
- Restricts S3 bucket access to only allow requests through CloudFront

#### How I Configured It

- The distribution is enabled and supports IPv6
- I set the default root object to "index.html"
- I configured it to redirect HTTP to HTTPS for better security
- Geo-restrictions are set to "none", allowing global access

#### Variables I Used

- `environment`: To tag resources appropriately
- `bucket_name`: The name of our S3 bucket
- `bucket_regional_domain_name`: The regional domain of our S3 bucket
- `bucket_arn`: The ARN of our S3 bucket

#### Outputs

- `cloudfront_domain_name`: The domain name of our CloudFront distribution
- `cloudfront_hosted_zone_id`: The hosted zone ID of the distribution

To use this module, you'll need to provide the S3 bucket details. Make sure you've already set up the S3 bucket module before using this one. This CloudFront setup works hand-in-hand with our S3 bucket to deliver content quickly and securely to users around the globe. 

## IAM Module
Within this module, I've set up the necessary IAM (Identity and Access Management) resources to manage permissions for the Tween-gency project i am working on. Here's what I've implemented:

#### Key Components

1. **IAM Role** I created an IAM role specifically for our API Gateway service.
2. **IAM Policy** I attached a custom policy to the role, granting specific permissions to interact with our S3 bucket.

#### What This Module Does
- Creates an IAM role that can be assumed by API Gateway
- Defines a policy that allows read access to our S3 bucket
- Attaches the policy to the role

#### How I Configured It

- The role is set up to trust the API Gateway service
- The policy grants `s3:GetObject` and `s3:ListBucket` permissions on our S3 bucket
- I used JSON encoding for the policy document to make it easily readable and maintainable

#### Variables I Used

- `s3_bucket_arn`: The ARN of our S3 bucket, which is used in the policy to specify the resource. 

#### Outputs

- `iam_role_arn`: The ARN of the IAM role we created

To use this module, you'll need to provide the ARN of your S3 bucket. It is very important that you've already set up the S3 bucket module before using this one. This IAM setup ensures that our API Gateway has the necessary permissions to access our S3 bucket, while following the principle of least privilege. It's a crucial part of our infrastructure that enables secure communication between our services. 

## Route 53 Module
Within this module, I've set up Amazon Route 53 to manage the DNS for our Tween-gency project. Here's what I've implemented:

#### Key Components

1. **Route 53 Hosted Zone**  I created a hosted zone for our domain, but only if we choose to create DNS records.
2. **DNS Record**  I set up an A record that points our domain to the CloudFront distribution.

#### What This Module Does

- Conditionally creates a Route 53 hosted zone for our domain
- Sets up an A record alias pointing to our CloudFront distribution

#### How I Configured It

- I used a count parameter to conditionally create resources based on the `create_dns_record` variable
- The hosted zone is only created if `create_dns_record` is true
- The A record is set up as an alias to the CloudFront distribution, which is more efficient than a CNAME
- The A record is also only created if `create_dns_record` is true
- I set `evaluate_target_health` to false for the alias, as CloudFront doesn't support health checks

#### Variables I Used

- `create_dns_record`: A boolean to determine whether to create Route 53 resources
- `domain_name`: The domain name for our website
- `cloudfront_domain_name`: The domain name of our CloudFront distribution
- `cloudfront_hosted_zone_id`: The hosted zone ID of our CloudFront distribution

## API Gateway Module

Upon gettig to this module, I set up an API Gateway to create an API that acts as a proxy for our S3 bucket. This allows us to serve our static website content through a customizable API endpoint. Here's how I implemented it:

#### Key Components
1. **REST API (`aws_api_gateway_rest_api`)**  I created a new REST API named "tween-gency-api".
2. **API Resource (`aws_api_gateway_resource`)**  I set up a proxy resource that can handle any path.
3. **API Method (`aws_api_gateway_method`)**  I configured a catch-all method that can handle any HTTP method.
4. **API Integration (`aws_api_gateway_integration`)**  I integrated the API with our S3 bucket, allowing it to fetch content from S3.
5. **Method Response (`aws_api_gateway_method_response`)**  I defined a 200 OK response for successful requests.
6. **Integration Response(`aws_api_gateway_integration_response`)**  I set up the response mapping from S3 to the API client.
7. **API Deployment (`aws_api_gateway_deployment`)**  I created a deployment to make our API live

#### What This Module Does
- Creates an API Gateway that can serve content from our S3 bucket
- Sets up a proxy integration that can handle any path in our bucket
- Configures the necessary method and integration responses
- Deploys the API to make it accessible

#### How I Configured It

- The API uses a {proxy+} resource to catch all paths
- It's set up to accept ANY HTTP method, making it flexible
- The integration is configured to use GET requests to S3, regardless of the incoming HTTP method
- I used the IAM role we created earlier to give API Gateway permission to access S3
- The deployment uses the environment variable to name the stage

#### Variables I Used

- `aws_region`: The AWS region where our resources are located
- `bucket_name`: The name of our S3 bucket
- `iam_role_arn`: The ARN of the IAM role we created for API Gateway
- `environment`: The deployment environment such as dev 

### Conclusion
I used AWS tools like S3, CloudFront, API Gateway, and IAM to set up a strong and flexible system for hosting a website. Through the use of Terraform, the whole process was easy to manage and made automated.

This setup helps the website load fast and highly available. It also has good security to protect the resouces within it. I also made the setup in a way that's easy to change and update as your website grows.

I hope this guide helped you understand how everything works and the purpose of using terraform to deploy this website. 

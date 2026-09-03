# SammyPulse ECS

This is my AWS ECS project using Gatus, an open-source monitoring application.

My aim is to deploy Gatus on ECS Fargate and build the supporting AWS infrastructure. I am documenting the project across 10 stages.

## What I Have Completed

I first ran Gatus on my laptop and checked that the health page returned:

```json
{"status":"UP"}
```

I then wrote a Dockerfile, built the image and ran Gatus inside a container.

After testing the container, I created a private ECR repository and uploaded the image to AWS. The first image scan found issues linked to Alpine packages. I updated the packages in the Dockerfile, rebuilt the image and tested Gatus again before uploading the new version.

I then created an ECS cluster and used the image from ECR to run Gatus on Fargate. I added a health check so ECS could check whether the container was responding. I also sent the Gatus logs to CloudWatch.

The application ran successfully on AWS and the ECS task showed as running and healthy.

## Run Gatus Locally

Build the Docker image:

```bash
docker build -t gatus-local:latest .
```

Run the container:

```bash
docker run -d --name gatus -p 8080:8080 gatus-local:latest
```

Check the health page:

```bash
curl http://localhost:8080/health
```

## AWS Resources Created

- ECR repository called `gatus`
- ECS cluster called `SammyPulse-cluster`
- Task definition called `SammyPulse-task`
- Container called `gatus`
- CloudWatch log group called `/ecs/sammypulse`
- IAM execution role called `ecsTaskExecutionRole`

The ECS service is set to zero running tasks while I am not using it. This prevents unnecessary Fargate charges.

## Security

I enabled image scanning in ECR and updated the affected Alpine packages found during the first scan.

I used an IAM role to let ECS download the image and send logs to CloudWatch. AWS credentials are not stored inside the container.

For this first ECS test, port `8080` was limited to my current public IP.

Files containing credentials, private keys and Terraform state are excluded from Git.

## Next Steps

The next stage is to create a custom AWS network. This will include public and private subnets across two Availability Zones and an Application Load Balancer.

Later stages will add HTTPS, DNS, Terraform, GitHub Actions, automated checks and monitoring.

## Application Credit

Gatus was created by [TwiN](https://github.com/TwiN/gatus). My work in this repository covers the Docker, AWS, security and deployment parts of the project.
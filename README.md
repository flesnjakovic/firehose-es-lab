# firehose-es-lab

It's a prerequisite that you have terraform and python installed. Run `terraform init` to fetch the AWS provider plugin and `terraform apply` to provision the infrastructure on AWS. `write-to-kinesis.py` script can be used to feed the data in Kinesis Firehose. From there, data is transferred to ElasticSearch cluster. 

**CAUTION: By default, ElastiSearch cluster is publicly available**

![image](https://raw.githubusercontent.com/flesnjakovic/firehose-es-lab/3bdfb3fea3e61c0fed0c8422bc3a362f1fe3c4d4/firehose-es-lab.jpg)

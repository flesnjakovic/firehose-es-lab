data "aws_iam_role" "firehose_delivery_es_role" {
    name = "firehose_delivery_es_role"
}

resource "aws_s3_bucket" "firehose-es-bucket" {
  bucket = "firehose-es-backup-bucket"
  acl = "private"
  force_destroy = "true"

  tags = {
      Description = "Used as a backup for firehose delivery stream"
  }
}

resource "aws_elasticsearch_domain" "es_lab_cluster" {
    domain_name = "firehose-es-lab"
    elasticsearch_version = "6.3"

    cluster_config {
        instance_type = "t2.small.elasticsearch"
    }

    ebs_options {
        ebs_enabled = true
        volume_size = 10
    }

    access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:*:*:domain/*"
    }
  ]
}
POLICY
}

resource "aws_kinesis_firehose_delivery_stream" "reviews_stream" {
    name = "firehose-es-lab-stream"
    destination = "elasticsearch"

    s3_configuration {
        role_arn = "${data.aws_iam_role.firehose_delivery_es_role.arn}"
        bucket_arn = "${aws_s3_bucket.firehose-es-bucket.arn}"
    }

    elasticsearch_configuration {
        domain_arn = "${aws_elasticsearch_domain.es_lab_cluster.arn}"
        role_arn = "${data.aws_iam_role.firehose_delivery_es_role.arn}"
        index_name = "reviews"
        type_name = "review"
        buffering_interval = 60
        buffering_size = 1
        index_rotation_period = "NoRotation"
    }
}
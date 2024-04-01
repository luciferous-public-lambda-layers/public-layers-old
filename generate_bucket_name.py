#!/usr/bin/env python
from os import getenv

region = getenv("AWS_DEFAULT_REGION")
role_arn = getenv("AWS_ROLE_ARN")
account_id = role_arn.split(":")[4]

bucket_name = f"layer-artifacts-{account_id}-{region}"

print(bucket_name, end="")

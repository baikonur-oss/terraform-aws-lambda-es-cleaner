import logging
import os

import certifi
import curator
from curator.exceptions import NoIndices
from elasticsearch import Elasticsearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

logger = logging.getLogger()
logger.setLevel(logging.INFO)

elasticsearch_host = os.environ['ES_HOST']
max_age_days = int(os.environ['MAX_AGE_DAYS'])
dry_run_only = os.environ['DRY_RUN_ONLY'] in ['true', 'True', 'yes']

# do auth because we are outside VPC
aws_auth = AWS4Auth(os.environ['AWS_ACCESS_KEY_ID'],
                    os.environ['AWS_SECRET_ACCESS_KEY'],
                    os.environ['AWS_REGION'],
                    'es',
                    session_token=os.environ['AWS_SESSION_TOKEN'])


# noinspection PyUnusedLocal
def handler(event, context):
    entries = []
    es = Elasticsearch(hosts=[{'host': elasticsearch_host, 'port': 443}],
                       http_auth=aws_auth,
                       use_ssl=True,
                       verify_certs=True,
                       connection_class=RequestsHttpConnection)

    logger.info(f"Connected to Elasticsearch at https://{elasticsearch_host}")

    ilo = curator.IndexList(es)
    try:
        ilo.filter_by_age(source='name', direction='older',
                          timestring='%Y%m%d', unit='days', unit_count=max_age_days)
        ilo.filter_by_regex(kind='suffix', value='-reload', exclude=True)
        delete_indices = curator.DeleteIndices(ilo)

        logger.info(f"Got {len(ilo.indices)} indices : {ilo.indices}")

        if dry_run_only:
            logger.info("Performing dry run only")
            delete_indices.do_dry_run()
        else:
            logger.info("Deleting real indices:")
            delete_indices.do_action()

    except NoIndices as e:
        logger.info("Got 0 indices, shutting down")

import time
import redis
import os, sys
from flask import Flask

try:
   os.environ["REDIS_HOST"]
except KeyError:
   print "Please set the environment variable REDIS_HOST "
   sys.exit(1)

   try:
      os.environ["REDIS_PORT"]
   except KeyError:
      print "Please set the environment variable REDIS_PORT "
      sys.exit(1)


# Get environment variables
REDIS_HOST = os.getenv('REDIS_HOST')
REDIS_PORT = os.getenv('REDIS_PORT')

print(REDIS_HOST)
print(REDIS_PORT)

app = Flask(__name__)
cache = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


@app.route('/')
def hit():
    count = get_hit_count()
    return 'Hello CloudCover, you have %i visitors on this page.\n' % int(count)


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)

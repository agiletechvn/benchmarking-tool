## How to run

```bash

# start server
python demo_server.py

# spam
wrk -c 2 -d 1m -t 1 -s post.lua http://localhost:8000/api/detect \
    -H "username: user" -H "password: 123456" --latency --timeout 30s -- \
    -d "request_id=12121212&customer_id=12121212&app_id=asdasdasdasd" -f "file=cmt.jpg" \
    -d "request_id=12121213&customer_id=12121213&app_id=bdbdbdbdbdbd" -f "file=cmt2.jpg"

# sample hottab
wrk -c 4 -d 1m -t 4 -s post.lua 'https://donut-dot-hottab-net.appspot.com/v3/restaurant/filter?secret_key=VNL597QypdptbydjBt3jT4yxaYSQYNGe7EWCavXCYZQ6gZ9Z&pagination=6&city=3f236e20-04c5-11e8-8586-b3151add17a4&sort=1&lang=en' \
  -H 'authority: donut-dot-hottab-net.appspot.com' \
  -H 'origin: https://sopa.asia' \
  -H 'referer: https://sopa.asia/' \
  --latency --timeout 30s -- \
  -m GET -v


# Usage
Benchmarking tool.

Options:
         -m <method>,    HTTP method.
   --method <method>
          -v [<verbose>],
   --verbose [<verbose>]
                         Print response.
       -f <file>,        Image file.
   --file <file>
       -d <data>,        Form data.
   --data <data>
   -h, --help            Show this help message and exit.


```

- run more than 1 thread will use seperate lua context per thread

## How to run

```bash

# start server
python demo_server.py

# spam
wrk -c 2 -d 1m -t 1 -s post.lua http://localhost:8000/api/detect \
    -H "username: user" -H "password: 123456" --latency --timeout 30s -- \
    -d "request_id=12121212&customer_id=12121212&app_id=asdasdasdasd" -f "file=cmt.jpg" \
    -d "request_id=12121213&customer_id=12121213&app_id=bdbdbdbdbdbd" -f "file=cmt2.jpg"

```

- run more than 1 thread will use seperate lua context per thread

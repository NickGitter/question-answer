"""
    *** Hello world app to starting with Gunicorn. ***
"""

def my_app(environ, start_response):
    text = "Hello World!\n"
    text = text.encode("utf-8")
    status = "200 OK"
    headers = [
        ("Content-Type", "text/plain"),
        ("Content-Length", str(len(text)))
    ]
    start_response(status, headers)
    return [ text ]



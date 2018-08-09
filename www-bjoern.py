#!/usr/bin/env python

import bjoern

exec(open("./nipap-www.wsgi").read())

bjoern.run(application, '0.0.0.0', 8080)

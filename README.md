# RUBERT

Rubert is a little command line application meant to combine/replicate some of the functionality of `jrnl` and `taskwarrior`. I'm writing it mostly as an exercise to learn Ruby and cement it as one of my go-to tools, so I am interested in things like maintenance and readability over performance.  

## run
`rake run`

## goals
- learn basic ruby
- pick up some advanced ruby
- learn about interactive CLI apps
- learn a testing framework like minitest

## models

* note to replicate in SQL, have a ledgers table, 1-many with a record table, which has an indexed record_type column and nullable columns with Task properties, then something like :ledger_Activity works really easily
